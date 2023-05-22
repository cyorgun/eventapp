import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class SignInBloc extends ChangeNotifier {

  
  SignInBloc() {
    checkSignIn();
    checkGuestUser();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn _googlSignIn = new GoogleSignIn();
  // final FacebookAuth _fbAuth = FacebookAuth.instance;
  final String defaultUserImageUrl = 'https://firebasestorage.googleapis.com/v0/b/sport-event-a637a.appspot.com/o/s.png?alt=media&token=81430708-4f97-4b03-884e-96dc1b0f1325';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _name;
  String? get name => _name;

  String? _phone;
  String? get phone => _phone;

  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _role;
  String? get role => _role;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _signInProvider;
  String? get signInProvider => _signInProvider;

  String? timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  // final FacebookAuth _fbAuth = FacebookAuth.instance;


  void initPackageInfo () async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
    
  }



  Future signInWithApple () async {

    final _firebaseAuth = FirebaseAuth.instance;
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

    if(result.status == AuthorizationStatus.authorized){
      try
      {
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential!.identityToken!),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;

        this._uid = firebaseUser!.uid;
        this._name = '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
        this._email = appleIdCredential.email ?? 'null';
        this._imageUrl = firebaseUser.photoURL ?? defaultUserImageUrl;
        this._signInProvider = 'apple';

        
        print(firebaseUser);
        _hasError = false;
        notifyListeners();


      }
      catch(e)
      {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    }
    else if (result.status == AuthorizationStatus.error)
    {
      _hasError = true;
      _errorCode = 'Appple Sign In Error! Please try again';
      notifyListeners();
    }
    else if (result.status == AuthorizationStatus.cancelled)
    {
      _hasError = true;
      _errorCode = 'Sign In Cancelled!';
      notifyListeners();
    }
    
  }



  

  Future signUpwithEmailPassword (userName,userEmail, userPassword,userPhone) async{
    try{
      final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: userEmail,password: userPassword,)).user!;
      assert(user != null);  
      await user!.getIdToken();
      this._name = userName;
      this._uid = user.uid;
      this._imageUrl = defaultUserImageUrl;
      this._email = user.email;
      this._phone = userPhone;
      this._role = "user";
      this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    }catch(e){
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
    
  }



  Future signInwithEmailPassword (userEmail, userPassword)async{
    try{
        final User? user = (await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword)).user!;    
        assert(user != null);    
        await user!.getIdToken();    
        final User currentUser = _firebaseAuth.currentUser!;    
        this._uid = currentUser.uid;
        this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    }catch(e){
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googlSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails = (await _firebaseAuth.signInWithCredential(credential)).user!;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        this._signInProvider = 'google';

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }



  // Future signInwithFacebook() async {

  //   User currentUser;
  //   final LoginResult facebookLoginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
  //   if(facebookLoginResult.status == LoginStatus.success){
  //     final _accessToken = await FacebookAuth.instance.accessToken;
  //     if(_accessToken != null){
  //       try{
  //         final AuthCredential credential = FacebookAuthProvider.credential(_accessToken.token);
  //         final User user = (await _firebaseAuth.signInWithCredential(credential)).user!;
  //         assert(user.email != null);
  //         assert(user.displayName != null);
  //         assert(!user.isAnonymous);
  //         await user.getIdToken();
  //         currentUser = _firebaseAuth.currentUser!;
  //         assert(user.uid == currentUser.uid);

  //         this._name = user.displayName;
  //         this._email = user.email;
  //         this._imageUrl = user.photoURL;
  //         this._uid = user.uid;
  //         this._signInProvider = 'facebook';
        
        
  //         _hasError = false;
  //         notifyListeners();
  //       }catch(e){
  //         _hasError = true;
  //         _errorCode = e.toString();
  //         notifyListeners();
  //       }
        
  //     }
  //   }else{
  //     _hasError = true;
  //     _errorCode = 'cancel or error';
  //     notifyListeners();
  //   }
  // }




  Future<bool> checkUserExists() async {
    
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if(snap.exists){
      print('User Exists');
      return true;
    }else{
      print('new user');
      return false;
    }
  }


  Future saveToFirebase() async {
    final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name': _name,
      'phone': _phone,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'role': _role,
      'timestamp': timestamp,
      'loved items': [],
      'bookmarked items': [],
      'interest_items':[]
    };
    await ref.set(userData);
  }




  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }



  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name!);
    await sp.setString('phone', _phone??"");
    await sp.setString('email', _email!);
    await sp.setString('image_url', _imageUrl!);
    await sp.setString('role', _role??"user");
    await sp.setString('uid', _uid!);
    await sp.setString('sign_in_provider', _signInProvider!);
  }



  Future getDataFromSp () async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _phone = sp.getString('phone');
    _role = sp.getString('role');
    _imageUrl = sp.getString('image_url');
    _uid = sp.getString('uid');
    _signInProvider = sp.getString('sign_in_provider');
    notifyListeners();
  }



  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap['uid'];
      this._name = snap['name'];
      this._phone = snap['phone'];
      this._role = snap['role'];
      this._email = snap['email'];
      this._imageUrl = snap['image url'];
      
      print(_name);
    });
    notifyListeners();
  }



  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }



  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }



  Future userSignout() async {
    if(_signInProvider == 'apple'){
      await _firebaseAuth.signOut();
    }
    else if (_signInProvider == 'facebook'){
      await _firebaseAuth.signOut();
      // await _fbAuth.logOut();
    }else if(_signInProvider == 'email'){
      await _firebaseAuth.signOut();
    }
    
    else{
      await _firebaseAuth.signOut();
      await _googlSignIn.signOut();
    }
    
  }

  


  Future afterUserSignOut ()async{
    await userSignout().then((_)async{
      await clearAllData();
      _isSignedIn = false;
      _guestUser = false;
      notifyListeners();
    });
  }



  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }



  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }




  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }





  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }


  void changePassword(String currentPassword, String newPassword) async {
final user = await FirebaseAuth.instance.currentUser;
final cred = EmailAuthProvider.credential(
    email: user!.email!, password: currentPassword);

user.reauthenticateWithCredential(cred).then((value) {
  user.updatePassword(newPassword).then((_) {
    //Success, do something
  }).catchError((error) {
    //Error, show something
  });
}).catchError((err) {
 
});}


  Future updateUserProfile (String newName, String newImageUrl,String newPhone) async{
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection('users').doc(_uid)
    .update({
      'name': newName,
      'image url' : newImageUrl,
      'phone': newPhone,
    });

    sp.setString('name', newName);
    sp.setString('image_url', newImageUrl);
    sp.setString('phone', newPhone);
    _name = newName;
    _imageUrl = newImageUrl;
    _phone=newPhone;
    
    notifyListeners();


  }



  Future<int> getTotalUsersCount () async {
    final String fieldName = 'count';
    final DocumentReference ref = firestore.collection('item_count').doc('users_count');
      DocumentSnapshot snap = await ref.get();
      if(snap.exists == true){
        int itemCount = snap[fieldName] ?? 0;
        return itemCount;
      }
      else{
        await ref.set({
          fieldName : 0
        });
        return 0;
      }
  }


  Future increaseUserCount () async {
    await getTotalUsersCount()
    .then((int documentCount)async {
      await firestore.collection('item_count')
      .doc('users_count')
      .update({
        'count' : documentCount + 1
      });
    });
  }


}