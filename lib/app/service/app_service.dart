import 'dart:io';

import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class AppService {
  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = false;
    }
    return internet;
  }

  Future openLink(context, String url) async {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      print("Can't launch the url");
    }
  }

// Future openEmailSupport(context) async {

//   final Uri params = Uri(
//     scheme: 'mailto',
//     path: Config().supportEmail,
//     query: 'subject=About ${Config().appName}&body=', //add subject and body here
//   );

//   var url = params.toString();
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     openToast1(context, "Can't open the email app");
//   }
// }

// Future openLinkWithCustomTab(BuildContext context, String url) async {
//   try{
//     await FlutterWebBrowser.openWebPage(
//     url: url,
//     customTabsOptions: CustomTabsOptions(
//       colorScheme: context.read<ThemeBloc>().darkTheme! ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
//       //addDefaultShareMenuItem: true,
//       instantAppsEnabled: true,
//       showTitle: true,
//       urlBarHidingEnabled: true,
//     ),
//     safariVCOptions: SafariViewControllerOptions(
//       barCollapsingEnabled: true,
//       dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//       modalPresentationCapturesStatusBarAppearance: true,
//     ),
//   );
//   }catch(e){
//     openToast1(context, 'Cant launch the url');
//     debugPrint(e.toString());
//   }
// }

// Future launchAppReview(context) async {
//   final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
//   await LaunchReview.launch(
//       androidAppId: sb.packageName,
//       iOSAppId: Config().iOSAppId,
//       writeReview: false);
//   if (Platform.isIOS) {
//     if (Config().iOSAppId == '000000') {
//       openToast1(context, 'The iOS version is not available on the AppStore yet');
//     }
//   }
// }

// static getYoutubeVideoIdFromUrl (String videoUrl){
//   return YoutubePlayer.convertUrlToId(videoUrl, trimWhitespaces: true);
// }
}
