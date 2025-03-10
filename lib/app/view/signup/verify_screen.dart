import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
import '../../routes/app_routes.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool phoneNumberEntered = false;
  String verificationId = "";
  TextEditingController codeController = TextEditingController();
  String completePhoneNumber = '';
  bool isLoading = false;

  Future<void> _verifyPhoneNumber() async {
    setState(() => isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completePhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.linkWithCredential(credential);
          } else {
            await FirebaseAuth.instance.signInWithCredential(credential);
          }
          _navigateToNextScreen();
        } catch (e) {
          _showSnackbar("Verification failed: ${e.toString()}");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => isLoading = false);
        _showSnackbar("Verification failed: ${e.message}");
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId; // ✅ verificationId kaydediliyor
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() {
          verificationId = verId; // ✅ Timeout durumunda da verificationId kaydediliyor
        });
      },
    );
  }

  Future<void> _verifyCode() async {
    if (verificationId.isEmpty) {
      _showSnackbar("Verification ID is missing. Please restart verification.");
      return;
    }
    if (codeController.text.isEmpty || codeController.text.length != 6) {
      _showSnackbar("Please enter a valid 6-digit verification code.");
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, // ✅ Kaydedilen verificationId kullanılıyor
        smsCode: codeController.text, // ✅ Kullanıcının girdiği kod alınıyor
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      _navigateToNextScreen();
    } catch (e) {
      _showSnackbar("Invalid code. Try again.");
    }
  }

  void _navigateToNextScreen() {
    final sb = context.read<SignInProvider>();
    sb.addPhone(completePhoneNumber);
    bool isOrganization = sb.role == "admin_specific";
    isOrganization
        ? Navigator.popAndPushNamed(context, Routes.adminHomeScreenRoute)
        : Navigator.popAndPushNamed(context, Routes.selectInterestRoute);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 73.h,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: !phoneNumberEntered
            ? Column(
          children: [
            getCustomFont(
                ("Please enter your phone number").tr(), 16.sp, Colors.black, 1,
                fontWeight: FontWeight.w600),
            getVerSpace(12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'TR',
                onChanged: (phone) {
                  setState(() {
                    completePhoneNumber = phone.completeNumber;
                  });
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              onPressed: () {
                setState(() {
                  phoneNumberEntered = true;
                  _verifyPhoneNumber();
                });
              },
              child: const Text('Numarayı Kaydet', style: TextStyle(color: Colors.white)),
            ),
          ],
        )
            : Column(
          children: [
            getDivider(dividerColor, 1.h),
            getVerSpace(60.h),
            getCustomFont(("Verify").tr(), 24.sp, Colors.black, 1,
                fontWeight: FontWeight.w700, textAlign: TextAlign.center, txtHeight: 1.5.h),
            getVerSpace(8.h),
            getMultilineCustomFont(
                ("Enter code sent to your phone number!" + "\n$completePhoneNumber").tr(),
                16.sp, Colors.black, txtHeight: 1.5.h,
                textAlign: TextAlign.center, fontWeight: FontWeight.w500),
            getVerSpace(30.h),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34.h)),
                  boxShadow: [
                    BoxShadow(color: "#2B9CC3C6".toColor(), blurRadius: 24, offset: const Offset(0, -2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    getVerSpace(50.h),
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter verification code",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    getVerSpace(20.h),
                    getButton(context, accentColor, "Verify", Colors.white, _verifyCode, 18.sp,
                        weight: FontWeight.w700, buttonHeight: 60.h,
                        borderRadius: BorderRadius.circular(22.h)),
                    getVerSpace(20.h),
                    TextButton(
                      onPressed: _verifyPhoneNumber,
                      child: Text("Resend Code", style: TextStyle(fontSize: 16.sp)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
