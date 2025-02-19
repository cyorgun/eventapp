import 'package:event_app/app/view/Multiple_Language/multiple_language_screen.dart';
import 'package:event_app/app/view/create_event/create_event_screen.dart';
import 'package:event_app/app/view/featured_event/buy_ticket.dart';
import 'package:event_app/app/view/featured_event/featured_event_detail.dart';
import 'package:event_app/app/view/featured_event/payment.dart';
import 'package:event_app/app/view/home/home_screen.dart';
import 'package:event_app/app/view/intro/onboarding.dart';
import 'package:event_app/app/view/login/forgot_password.dart';
import 'package:event_app/app/view/login/reset_password.dart';
import 'package:event_app/app/view/my_card/edit_card_screen.dart';
import 'package:event_app/app/view/my_card/my_card_screen.dart';
import 'package:event_app/app/view/notification/notification_screen.dart';
import 'package:event_app/app/view/profile/edit_profile.dart';
import 'package:event_app/app/view/select_interest/select_interest_screen.dart';
import 'package:event_app/app/view/setting/help_screen.dart';
import 'package:event_app/app/view/setting/privacy_screen.dart';
import 'package:event_app/app/view/setting/setting_screen.dart';
import 'package:event_app/app/view/signup/signup_screen.dart';
import 'package:event_app/app/view/signup/verify_screen.dart';
import 'package:event_app/app/view/splash_screen.dart';
import 'package:event_app/app/view/ticket/ticket_detail.dart';
import 'package:flutter/material.dart';

import '../chat/views/chat_screen.dart';
import '../view/category/category_screen.dart';
import '../view/intro/welcome.dart';
import '../view/login/login_screens.dart';
import '../view/popular_event/popular_event_list.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.homeRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.onboardingPage: (context) => const OnBoarding(),
    Routes.splashScreen: (context) => const SplashScreen(),
    Routes.loginRoute: (context) => LoginScreen(),
    Routes.homeScreenRoute: (context) => const HomeScreen(),
    Routes.forgotPasswordRoute: (context) => const ForgotPassword(),
    Routes.resetPasswordRoute: (context) => const ResetPassword(),
    Routes.signUpRoute: (context) => const SignUpScreen(),
    Routes.multipleLanguageScreen: (context) => MultipleLanguageScreen(),
    Routes.chatRoute: (context) => const ChatScreen(),
    Routes.verifyRoute: (context) => const VerifyScreen(),
    Routes.selectInterestRoute: (context) => const SelectInterestScreen(),
    Routes.trendingScreenRoute: (context) => const CategoryScreen(),
    Routes.buyTicketRoute: (context) => const BuyTicket(),
    Routes.welcomePage: (context) => const WelcomePage(),
    Routes.paymentRoute: (context) => PaymentScreen(),
    Routes.createEventRoute: (context) => const CreateEventScreen(),
    Routes.ticketDetailRoute: (context) => TicketDetail(),
    Routes.settingRoute: (context) => const SettingScreen(),
    Routes.featuredEventDetailRoute: (context) => const FeaturedEventDetail(),
    Routes.editProfileRoute: (context) => const EditProfile(),
    Routes.notificationScreenRoute: (context) => const NotificationScreen(),
    Routes.myCardScreenRoute: (context) => const MyCardScreen(),
    Routes.editCardScreenRoute: (context) => const EditCardScreen(),
    Routes.privacyScreenRoute: (context) => const PrivacyScreen(),
    Routes.helpScreenRoute: (context) => const HelpScreen(),
    // Routes.featureEventListRoute: (context) => const FeatureEventList(),
    Routes.popularEventListRoute: (context) => const PopularEventList()
  };
}
