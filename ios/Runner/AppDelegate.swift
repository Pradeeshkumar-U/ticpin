import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC2gFDSPGY7wtSFHzYwzbPkP6tcq61Lmt8")
    GMSPlacesClient.provideAPIKey("AIzaSyC2gFDSPGY7wtSFHzYwzbPkP6tcq61Lmt8")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
