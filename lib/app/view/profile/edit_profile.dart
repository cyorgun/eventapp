import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evente/evente.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? name;
  String? imageUrl;

  File? imageFile;
  String? fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nameCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    //var imagepicked = await _imagePicker.getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }

  Future uploadPicture() async {
    final SignInProvider sb = context.read<SignInProvider>();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('Profile Pictures/${sb.uid}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUrl = _imageUrl;
      });
    });
  }

  handleUpdateData() async {
    final sb = context.read<SignInProvider>();
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              ('No internet').tr(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() => loading = true);

          imageFile == null
              ? await sb
                  .updateUserProfile(nameCtrl.text, imageUrl!, phoneCtrl.text)
                  .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        ('Upload Success').tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );

                  setState(() => loading = false);
                })
              : await uploadPicture().then((value) => sb
                      .updateUserProfile(
                          nameCtrl.text, imageUrl!, phoneCtrl.text)
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text(
                          ('Update Success').tr(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                    setState(() => loading = false);
                  }));
        }
      }
    });
  }

  @override
  void initState() {
    final SignInProvider sb = context.read<SignInProvider>();
    @override
    void initState() {
      super.initState();
      nameCtrl.text = sb.name ?? "";
      phoneCtrl.text = sb.phone ?? "";
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInProvider>();
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          Navigator.of(context).pop();
        },
        title: getCustomFont(("Edit Profile").tr(), 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              getVerSpace(15.h),
              InkWell(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  child: Container(
                    height: 120,
                    width: 120,

                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[800]!),
                        color: Colors.grey[500],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: (imageFile == null
                                    ? CachedNetworkImageProvider(sb.imageUrl!)
                                    : FileImage(imageFile!))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover)),
                    // ignore: prefer_const_constructors
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                ),
                onTap: () {
                  pickImage();
                },
              ),
              getDivider(
                dividerColor,
                1.h,
              ),
              Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      getVerSpace(10.h),

                      // getAssetImage("profile_image.png",
                      // width: 110.h, height: 110.h),
                      getVerSpace(30.h),
                      getCustomFont(('Full Name').tr(), 16.sp, Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                      getVerSpace(4.h),
                      getDefaultTextFiledWithLabel(
                        context,
                        sb.name ?? "",
                        nameCtrl,
                        isEnable: false,
                        height: 60.h,
                        validator: (value) {
                          if (value!.length == 0)
                            return ("Name can't be empty").tr();
                          return null;
                        },
                      ),
                      getVerSpace(20.h),

                      getCustomFont(
                          ('Phone Number').tr(), 16.sp, Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                      getVerSpace(4.h),
                      getDefaultTextFiledWithLabel2(
                        context,
                        sb.phone ?? "",
                        phoneCtrl,
                        isEnable: false,
                        height: 60.h,
                        validator: (value) {
                          if (value!.length == 0)
                            return ("Phone can't be empty").tr();
                          return null;
                        },
                      ),
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : getButton(
                        context, accentColor, ("Save").tr(), Colors.white, () {
                        handleUpdateData();

                        sb.saveDataToSP();
                      }, 18.sp,
                        weight: FontWeight.w700,
                        buttonHeight: 60.h,
                        borderRadius: BorderRadius.circular(22.h)),
              ),
              getVerSpace(30.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget getDefaultTextFiledWithLabel2(BuildContext context, String s,
      TextEditingController textEditingController,
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
      GestureTapCallback? onTap,
      bool isReadonly = false}) {
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
              fontSize: 16.sp,
              fontFamily: Constant.fontsFamily),
          decoration: InputDecoration(
              counter: Container(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: vertical.h, horizontal: horizontal.h),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: accentColor, width: 1.h)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: errorColor, width: 1.h)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: errorColor, width: 1.h)),
              errorStyle: TextStyle(
                  color: errorColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5.h,
                  fontFamily: Constant.fontsFamily),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 24.h,
              ),
              suffixIcon: withSufix == true
                  ? GestureDetector(
                      onTap: () {
                        imagefunction;
                      },
                      child: getPaddingWidget(
                        EdgeInsets.only(right: 18.h),
                        getSvgImage(suffiximage.toString(),
                            width: 24.h, height: 24.h),
                      ))
                  : null,
              prefixIconConstraints: constraint,
              prefixIcon: isprefix == true ? prefix : null,
              hintText: s,
              hintStyle: TextStyle(
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  fontFamily: Constant.fontsFamily)),
        );
      },
    );
  }
}
