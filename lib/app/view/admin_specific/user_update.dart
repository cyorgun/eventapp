
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/provider/sign_in_provider.dart';
import 'package:evente/evente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../modal/users_model.dart';

// ignore: must_be_immutable
class UserUpdate extends StatefulWidget {
  UserModel? user;
   UserUpdate({Key? key,this.user}) : super(key: key);

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {

  void backClick() {
    Get.back();
  }

  String dropdownvalue = 'Female';

  var items = ['Female', "Male"];

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
    final  _imagePicker = ImagePicker();
    //var imagepicked = await _imagePicker.getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    var imagepicked = await _imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    
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
    Reference storageReference = FirebaseStorage.instance.ref().child('Profile Pictures/${widget.user?.id}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(()async{
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUrl = _imageUrl;
      });
      });
      
    }




  handleUpdateData () async {
    final sb = context.read<SignInProvider>();
    await AppService().checkInternet().then((hasInternet) async {
      if(hasInternet == false){       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'No internet',
              textAlign: TextAlign.center,
            ),
          ),
        );
        
      }
      else{

        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          setState(()=> loading = true);
          
          imageFile == null ?
          // await sb.updateUserProfile(nameCtrl.text, imageUrl??widget.admin_specific?.imageurl??"",phoneCtrl.text)
       await   FirebaseFirestore.instance.collection('users').doc(widget.user?.id)
    .update({
      'name': nameCtrl.text,
      'image url' : imageUrl??widget.user?.imageurl??"",
      'phone': phoneCtrl.text,
    })
         
          .then((value){
               ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'Upload Success',
              textAlign: TextAlign.center,
            ),
          ),
        );
        Navigator.of(context).pop();
        
        Navigator.of(context).pop();
          setState(()=> loading = false);})


          : await uploadPicture()
            .then((value) =>     FirebaseFirestore.instance.collection('users').doc(widget.user?.id)
    .update({
      'name': nameCtrl.text,
      'image url' : imageUrl??widget.user?.imageurl??"",
      'phone': phoneCtrl.text,
    })
         
            .then((_) {
               ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              'Update Success',
              textAlign: TextAlign.center,
            ),
          ),
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
            setState(()=> loading = false );}));
        }   
      }
    });
  }

@override
  void initState() {
    
     @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.user?.name??"";
    phoneCtrl.text = widget.user?.phone??"";
    
  }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final sb = context.read<SignInProvider>();
     final UserModel user = widget.user!;
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
       appBar: AppBar(
        title: const Text(
          'User Detail',
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      // body: Container(),
      body: SafeArea(
        child:
          Form(
            key: formKey,
          child: Column(
            children: [
          getVerSpace(15 ),
              InkWell(
                child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                  child: Container(
                  height: 120,
                  width: 120,
                  
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey[800]!
                      ),
                      
                      color: Colors.grey[500],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: (imageFile == null ? CachedNetworkImageProvider(user.imageurl??"") : FileImage(imageFile!)) as ImageProvider<Object>,
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
              onTap: (){
                pickImage();
              },
          ),

    getDivider(
                dividerColor,
                1 ,
              ),
              Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20 ),
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      getVerSpace(10 ),
                    
                      // getAssetImage("profile_image.png",
                          // width: 110 , height: 110 ),
                      getVerSpace(30 ),
                      getCustomFont('Full Name', 16 , Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5 ),
                      getVerSpace(4 ),
                      getDefaultTextFiledWithLabel(
                        context,
                        user.name??"",
                        nameCtrl,
                        isEnable: false,
                        height: 60 ,
                         validator: (value){
                if (value!.length == 0) return "Name can't be empty";
                return null;
              },
                      ),
                      getVerSpace(20 ),
                    
                      getCustomFont('Phone Number', 16 , Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5 ),
                      getVerSpace(4 ),
                      getDefaultTextFiledWithLabel2(context,
                          user.phone??"0", 
                          phoneCtrl,
                          isEnable: false,
                          
                          height: 60 , validator: (value){
                if (value!.length == 0) return "Phone can't be empty";
                return null;
              },
                        ),

                        
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20 ),
               loading == true 
                ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),)
                :   getButton(context, accentColor, "Save", Colors.white, () {
                handleUpdateData();
                
      // sb.saveDataToSP();
                }, 18 ,
                    weight: FontWeight.w700,
                    buttonHeight: 60 ,
                    borderRadius: BorderRadius.circular(22 )),
              ),
              getVerSpace(30 )
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
            fontSize: 16 ,
            fontFamily: Constant.fontsFamily),
        decoration: InputDecoration(
          
            counter: Container(),
            contentPadding: EdgeInsets.symmetric(
                vertical: vertical , horizontal: horizontal ),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: borderColor, width: 1 )),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: borderColor, width: 1 )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: accentColor, width: 1 )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: errorColor, width: 1 )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: errorColor, width: 1 )),
            errorStyle: TextStyle(
                color: errorColor,
                fontSize: 13 ,
                fontWeight: FontWeight.w500,
                height: 1.5 ,
                fontFamily: Constant.fontsFamily),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22 ),
                borderSide: BorderSide(color: borderColor, width: 1 )),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 24 ,
            ),
            
            suffixIcon: withSufix == true
                ? GestureDetector(
                    onTap: () {
                      imagefunction;
                    },
                    child: getPaddingWidget(
                      EdgeInsets.only(right: 18 ),
                      getSvgImage(suffiximage.toString(),
                          width: 24 , height: 24 ),
                    ))
                : null,
            prefixIconConstraints: constraint,
            prefixIcon: isprefix == true ? prefix : null,
            hintText: s,
            
            hintStyle: TextStyle(
                color: greyColor,
                fontWeight: FontWeight.w500,
                fontSize: 16 ,
                fontFamily: Constant.fontsFamily)),
                
      );
    },
  );
    }
}
