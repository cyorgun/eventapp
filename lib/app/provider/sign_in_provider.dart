import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

import '../dialog/snacbar.dart';

class SignInProvider extends ChangeNotifier {
  SignInProvider() {
    checkIfUserIsAuthenticated();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // final GoogleSignIn _googlSignIn = new GoogleSignIn();
  // final FacebookAuth _fbAuth = FacebookAuth.instance;
  final String defaultUserImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/sport-event-a637a.appspot.com/o/s.png?alt=media&token=81430708-4f97-4b03-884e-96dc1b0f1325';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  bool _isSubscriptionActive = false;

  bool get isSubscriptionActive => _isSubscriptionActive;

  String? _subscriptionPlan;

  String? get subscriptionPlan => _subscriptionPlan;

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

  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future<void> verifyUserSubscription() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Kullanıcı giriş yapmamış.");
      return;
    }

    // Kullanıcının Firebase Authentication ID Token'ını al
    String? idToken = await user.getIdToken();
    print("Flutter'dan Gönderilen ID Token: $idToken");

    try {
      HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('verifyUserSubscription');

      // ID Token'ı bir JSON objesi içinde gönderiyoruz
      final result = await callable.call({"idToken": idToken});

      print("Cloud Function Cevabı: ${result.data}");
    } catch (e) {
      print("Cloud Function Hatası: $e");
    }
    try {
      await checkSubscription();
    } catch (e) {
    }
  }

  Future signInWithApple() async {
    final _firebaseAuth = FirebaseAuth.instance;
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (result.status == AuthorizationStatus.authorized) {
      try {
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential!.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;

        this._uid = firebaseUser!.uid;
        this._name =
            '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
        this._email = appleIdCredential.email ?? 'null';
        this._imageUrl = firebaseUser.photoURL ?? defaultUserImageUrl;
        this._signInProvider = 'apple';

        print(firebaseUser);
        _isSignedIn = true;
        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else if (result.status == AuthorizationStatus.error) {
      _hasError = true;
      _errorCode = 'Appple Sign In Error! Please try again';
      notifyListeners();
    } else if (result.status == AuthorizationStatus.cancelled) {
      _hasError = true;
      _errorCode = 'Sign In Cancelled!';
      notifyListeners();
    }
  }

  Future signUpWithEmailPassword(
      userName, userEmail, userPassword, isOrganization)
  async {
    try {
      final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      ))
          .user!;
      assert(user != null);
      await user!.getIdToken();
      this._name = userName;
      this._uid = user.uid;
      this._imageUrl = defaultUserImageUrl;
      this._email = user.email;
      this._role = isOrganization? "admin_specific" : "user";
      this._signInProvider = 'email';

      _isSignedIn = true;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future signInWithEmailPassword(userEmail, userPassword) async {
    try {
      final User? user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword))
          .user!;
      assert(user != null);
      await user!.getIdToken();
      final User currentUser = _firebaseAuth.currentUser!;
      this._uid = currentUser.uid;
      this._signInProvider = 'email';

      _isSignedIn = true;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user!;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        this._signInProvider = 'google';

        _isSignedIn = true;
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

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new admin_specific');
      return false;
    }
  }

  getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name': _name,
      'phone': _phone,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'role': _role,
      'timestamp': timestamp,
      'bookmarked items': [],
      'interest_items': [],
      'eventCount': _role == "admin_specific" ? 2 : 1
    };
    await ref.set(userData);
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }

  Future getUserDataFromFirebase(uid) async {
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

  Future<void> checkIfUserIsAuthenticated() async {
    await Firebase.initializeApp();  // Firebase'i başlat

    User? user = FirebaseAuth.instance.currentUser;  // Şu anki kullanıcıyı al

    if (user != null) {
      this._uid = user.uid;
      _isSignedIn = true;
      notifyListeners();
    }
  }

  Future userSignOut() async {
    if (_signInProvider == 'apple') {
      await _firebaseAuth.signOut();
    } else if (_signInProvider == 'facebook') {
      await _firebaseAuth.signOut();
      // await _fbAuth.logOut();
    } else if (_signInProvider == 'email') {
      await _firebaseAuth.signOut();
    } else { // google
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    }
  }

  Future afterUserSignOut() async {
    await userSignOut().then((_) async {
      _isSignedIn = false;
      notifyListeners();
    });
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
    }).catchError((err) {});
  }

  Future addPhone(String newPhone) async {
    FirebaseFirestore.instance.collection('users').doc(_uid).set({
      'phone': newPhone,
    }, SetOptions(merge: true));
    _phone = newPhone;
  }

  Future updateUserProfile(
      String newName, String newImageUrl, String newPhone) async {

    FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'name': newName,
      'image url': newImageUrl,
      'phone': newPhone,
    });

    _name = newName;
    _imageUrl = newImageUrl;
    _phone = newPhone;

    //TODO: may need to also add these firebaseauth user too

    notifyListeners();
  }

  Future<bool> isUserVerified() async {
      // Eğer kullanıcı giriş yapmamışsa, false döndür
      if (_firebaseAuth.currentUser == null) {
        return false;
      } else {
        // Eğer phoneNumber null değilse, kullanıcı doğrulama yapmıştır
        return _firebaseAuth.currentUser!.phoneNumber != null;
      }
  }

  Future signInWithCredential(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future checkSubscription() async {
    User? user = FirebaseAuth.instance.currentUser;  // Şu anki kullanıcıyı al
    if (user == null) {
      return;
    }
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      final subscription = userDoc['subscription'];
      if (subscription != null) {
        Timestamp endDate = subscription['endDate'];
        Timestamp now = Timestamp.now();
        _isSubscriptionActive = now.seconds < endDate.seconds;
        _subscriptionPlan = subscription['plan'];
        notifyListeners();
      }
    }
  }
}
