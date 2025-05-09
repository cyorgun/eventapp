import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evente/evente.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/chatroom_logic/providers/chatroom_provider.dart';
import 'app/chatroom_logic/providers/home_provider.dart';
import 'app/chatroom_logic/providers/setting_provider.dart';
import 'app/provider/bookmark_provider.dart';
import 'app/provider/event_provider.dart';
import 'app/provider/search_provider.dart';
import 'app/provider/sign_in_provider.dart';
import 'app/provider/theme_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/view/featured_event/featured_event_detail.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51MkcnODzHsmg6hHDOxhHPeN6U4tJXa6IMOcFROtQDq7jXUseOUKmCxXXHt1Ktmld2dV0o1bOfwP2S1b68Zxxr7pr00PU1lElJj";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox("notifications");
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.dark
  // ));
  setupFcm();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Konfigurasi untuk platform Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    startLocale: Locale('en', 'US'),
    path: 'assets/Lang',
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
      Locale('de', 'DE'),
      Locale('en', 'ES'),
      Locale('fi', 'FI'),
      Locale('hi', 'IN'),
      Locale('zh', 'CN'),
      Locale('fr', 'CH'),
      Locale('tr', 'TR'),
    ],
    child: MaterialApp(debugShowCheckedModeBanner: false, home: const MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? notifTitle, notifBody;

  @override
  void initState() {
    NotificationService().initFirebasePushNotification(context);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mendapatkan message di foreground!');
      print('Message data adalah : ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification : ${message.notification}');
        setState(() {
          notifTitle = message.notification!.title;
          notifBody = message.notification!.body;
        });
      }
    });
    FirebaseMessaging.instance
        .getToken()
        .then((value) => {print("FCM Token Is: "), print(value)});
    // TODO: implement initState
    super.initState();
  }

  late final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInProvider>(
                create: (context) => SignInProvider(),
                lazy: false,
              ),
              ChangeNotifierProvider<BookmarkProvider>(
                create: (context) => BookmarkProvider(),
              ),
              ChangeNotifierProvider<EventProvider>(
                create: (context) => EventProvider(),
              ),
              ChangeNotifierProvider<SearchProvider>(
                create: (context) => SearchProvider(),
              ),
              Provider<SettingProvider>(
                create: (_) => SettingProvider(
                  prefs: this.prefs,
                  firebaseFirestore: this.firebaseFirestore,
                  firebaseStorage: this.firebaseStorage,
                ),
              ),
              Provider<HomeProvider>(
                create: (_) => HomeProvider(
                  firebaseFirestore: this.firebaseFirestore,
                ),
              ),
              Provider<ChatroomProvider>(
                create: (_) => ChatroomProvider(
                  firebaseFirestore: this.firebaseFirestore,
                  firebaseStorage: this.firebaseStorage,
                ),
              ),
            ],
            child: MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,

              debugShowCheckedModeBanner: false,
              initialRoute: Routes.splashScreen,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }),
                // textTheme: GoogleFonts.manropeTextTheme(),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  centerTitle: false,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                ),
              ),
              routes: AppPages.routes,
              onGenerateRoute: (settings) {
                if (settings.name == Routes.featuredEventDetailRoute) {
                  return PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeaturedEventDetail(),
                    transitionDuration: const Duration(milliseconds: 1000),
                    transitionsBuilder: (_, animation, __, child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    },
                  );
                }
                return null;
              },
            ),
          );
        }));
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  FirebaseMessaging.onMessage.listen((event) async {
    print("firebase Background");
    try {
      print("getLoc");
    } catch (e) {}
  });
}
