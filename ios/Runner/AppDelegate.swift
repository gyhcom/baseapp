import Flutter
import UIKit
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Google Sign-In 클라이언트 ID 직접 설정
    let configuration = GIDConfiguration(clientID: "519214372910-4am179ffmbj8927ocftg5pq7qjes7rsv.apps.googleusercontent.com")
    GIDSignIn.sharedInstance.configuration = configuration
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Google Sign-In URL 처리
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    
    return super.application(app, open: url, options: options)
  }
}
