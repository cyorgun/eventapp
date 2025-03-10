import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';

import 'package:evente/evente.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/snacbar.dart';
import '../../provider/sign_in_provider.dart';
import '../../widget/Rounded_Button.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var phoneController = TextEditingController();
  var nameCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _btnController = new RoundedLoadingButtonController();

  bool offsecureText = true;

  late String email;
  late String pass;
  late String phone;
  String? name;
  bool isOrganization = false;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        // lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        // lockIcon = LockIcon().lock;
      });
    }
  }

  Future handleSignUpwithEmailPassword() async {
    final SignInProvider sb = Provider.of<SignInProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await AppService().checkInternet().then((hasInternet) {
        if (hasInternet == false) {
          openSnacbar(_scaffoldKey, 'no internet');
        } else {
          setState(() {
            // signUpStarted = true;
          });
          sb.signUpWithEmailPassword(name, email, pass, isOrganization).then((_) async {
            if (sb.hasError == false) {
               sb.getTimestamp().then((value) => sb
                  .saveToFirebase().then((value) {
                    showDialog(
                        builder: (context) {
                          return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(37 ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20 ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerSpace(30 ),
          Container(
            width: double.infinity,
            height: 190 ,
            margin: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(34 ))),
            child: Column(
              children: [
                getVerSpace(40 ),  
                 Image.asset( 'assets/images/Sukses.gif',
              width: 150,
              
            ), 
           ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37 ),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      offset: const Offset(0, -2),
                      blurRadius: 24)
                ]),
            child: Column(
              children: [
                getVerSpace(30 ),
                getCustomFont('User Created', 22 , Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5 ),
                getVerSpace(8 ),
                getMultilineCustomFont(
                    "User succes created", 16 , Colors.black,
                    fontWeight: FontWeight.w500, txtHeight: 1.5 ),
                getVerSpace(30 ),
                getButton(context, Colors.redAccent, "Close", Colors.white, () {
                     Navigator.pop(context);
                          Navigator.pop(context);
                }, 18 ,
                    weight: FontWeight.w700,
                    buttonHeight: 60 ,
                    borderRadius: BorderRadius.circular(22 )),
                getVerSpace(30 ),
              ],
            ),
          )
        ],
      ),
    );
                        },
                        context: context);
                        _btnController.success();
                  }));
            } else {
              setState(() {
                // signUpStarted = false;
              });
               _btnController.reset();
             ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Failed Create Please Check Your Mail and Password!',
              textAlign: TextAlign.center,
            ),
          ),
        );
              openSnacbar(_scaffoldKey, sb.errorCode);
             
            }
          });
        }
      });
    }
    else{
              _btnController.reset();}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text("Create User",style: const TextStyle(fontFamily: "sofia",fontSize: 19.0,fontWeight: FontWeight.w600),),
    ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Stack(
            children: 
              [ 
                    Column(  mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

                children: [
            
                  Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(34)),
                                boxShadow: [
                                  BoxShadow(
                                      color: "#2B9CC3C6".toColor(),
                                      blurRadius: 24,
                                      offset: const Offset(0, -2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getVerSpace(24),
                                getCustomFont("Full Name", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                                TextFormField(
                                  controller: nameCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      labelText: 'Enter Name',
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: Constant.fontsFamily)),
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return "Name can't be empty";
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                                getVerSpace(24),
                                getCustomFont("Email", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                                TextFormField(
                                  decoration: InputDecoration(
                                      hintText: 'username@mail.com',
                                      labelText: 'Enter Email',
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: Constant.fontsFamily)),
                                  controller: emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return "Email can't be empty";
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                ),
                                getVerSpace(24),
                                getCustomFont(
                                    "Phone Number", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                             
                         
                                      getDefaultTextFiledWithLabel2(
                                          context,
                                          "Phone Number",
                                          
                                          phoneController,
                                          isEnable: false,
                                          height: 60,
                                          validator: (String? value){
                        if (value!.isEmpty) return "Phone can't be empty";
                        return null;
                      },
                      
                                          isprefix: true,
                                          onChanged: (String value){
                        setState(() {
                          phone = value;
                        });
                      },
                                     
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.,]')),
                                          ],
                                          constraint: BoxConstraints(
                                              maxWidth: 135, maxHeight: 24)),
                                
                                getVerSpace(24),
                                getCustomFont("Password", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                                TextFormField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: Constant.fontsFamily),
                                  decoration: InputDecoration(
                                    counter: Container(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: accentColor, width: 1)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: errorColor, width: 1)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: errorColor, width: 1)),
                                    errorStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                        fontFamily: Constant.fontsFamily),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1)),
                                    suffixIconConstraints: BoxConstraints(
                                      maxHeight: 24,
                                    ),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          lockPressed();
                                        },
                                        child: getPaddingWidget(
                                          EdgeInsets.only(right: 18),
                                          getSvgImage("show.svg".toString(),
                                              width: 24, height: 24),
                                        )),
                                    prefixIconConstraints: BoxConstraints(
                                      maxHeight: 12,
                                    ),
                                    hintText: "Enter Password",
                                  ),
                                  obscureText: offsecureText,
                                  controller: passCtrl,
                                  validator: (String? value) {
                                    if (value!.isEmpty)
                                      return "Password can't be empty";
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      pass = value;
                                    });
                                  },
                                ),
                                getVerSpace(7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Organizasyon musunuz?"),
                                    Checkbox(
                                      value: isOrganization,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isOrganization = value ?? false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                getVerSpace(36),
                                RoundedLoadingButton(
                      animateOnTap: true,
                      successColor: accentColor,
                      controller: _btnController,
                      onPressed: () {
                       handleSignUpwithEmailPassword();
                      },
                      width: MediaQuery.of(context).size.width * 1.0,
                      color:accentColor,
                      elevation: 0,
                      child: Wrap(
                        children: const [  Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                                // getButton(
                                //     context, accentColor, "Sign Up", Colors.white,
                                //     () {
                                //   handleSignUpwithEmailPassword();
                                // }, 18,
                                //     weight: FontWeight.w700,
                                //     buttonHeight: 60,
                                //     borderRadius: BorderRadius.circular(22)),
                            
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  
Widget getDefaultTextFiledWithLabel2(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool withSufix = false,
    bool minLines = false,
    bool isPass = false,
    bool isEnable = true,
    bool isprefix = false,
    Widget? prefix,
    double? height,
    String? suffiximage,
    Function? imagefunction,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
    BoxConstraints? constraint,
    ValueChanged<String>? onChanged,
    double vertical = 20,
    double horizontal = 18,
    int? length,
    String obscuringCharacter = '•',
    GestureTapCallback? onTap,bool isReadonly = false}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        readOnly: isReadonly,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
        enabled: true,
        inputFormatters: inputFormatters,
        maxLines: (minLines) ? null : 1,
        controller: textEditingController,
        obscuringCharacter: obscuringCharacter,
        autofocus: false,
        obscureText: isPass,
                                keyboardType: TextInputType.number,
        showCursor: true,
        cursorColor: accentColor,
        maxLength: length,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            fontFamily: Constant.fontsFamily),
        decoration: InputDecoration(
          
            counter: Container(),
            contentPadding: EdgeInsets.symmetric(
                vertical: vertical, horizontal: horizontal),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: borderColor, width: 1)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: borderColor, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: accentColor, width: 1)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: errorColor, width: 1)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: errorColor, width: 1)),
            errorStyle: TextStyle(
                color: errorColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontFamily: Constant.fontsFamily),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: borderColor, width: 1)),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 24,
            ),
            
            suffixIcon: withSufix == true
                ? GestureDetector(
                    onTap: () {
                      imagefunction;
                    },
                    child: getPaddingWidget(
                      EdgeInsets.only(right: 18),
                    Icon(Icons.phone_rounded,color: accentColor,)
                    ))
                : null,
            prefixIconConstraints: constraint,
            prefixIcon: isprefix == true ? prefix : null,
            hintText: s,
            
            hintStyle: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: Constant.fontsFamily)),
                
      );
    },
  );
}

}
