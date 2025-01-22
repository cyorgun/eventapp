import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBN1BpT0Wuvwr3Ggs1vcuX1ZiZRcFdRlRw")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
