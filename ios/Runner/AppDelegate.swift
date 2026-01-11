import Flutter
import UIKit
import UserNotifications
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up notification center
    UNUserNotificationCenter.current().delegate = self
    
    // Request notification permissions
    requestNotificationPermissions()
    
    // Set up location manager if needed
    setupLocationManager()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle deep linking
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return application(app, open: url, sourceApplication: nil, annotation: [:])
  }
  
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    handleDeepLink(url: url)
    return true
  }
  
  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if let url = userActivity.webpageURL {
      handleDeepLink(url: url)
    }
    return true
  }
  
  // Handle deep link URLs
  private func handleDeepLink(url: URL) {
    let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    
    if urlComponents?.scheme == "tranzfort" {
      // Handle custom scheme deep links
      let path = urlComponents?.path ?? ""
      let queryItems = urlComponents?.queryItems ?? []
      
      // Send deep link data to Flutter
      if let flutterViewController = window?.rootViewController as? FlutterViewController {
        let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/deeplink", binaryMessenger: flutterViewController.binaryMessenger)
        
        var deepLinkData: [String: Any] = [
          "path": path,
          "query": queryItems.map { ["name": $0.name, "value": $0.value ?? ""] }
        ]
        
        methodChannel.invokeMethod("onDeepLinkReceived", arguments: deepLinkData)
      }
    }
  }
  
  // Request notification permissions
  private func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        print("Notification permissions granted")
      } else {
        print("Notification permissions denied")
      }
    }
  }
  
  // Set up location manager
  private func setupLocationManager() {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestAlwaysAuthorization()
  }
  
  // Handle notification response
  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    handleNotificationResponse(response: response)
    completionHandler()
  }
  
  private func handleNotificationResponse(response: UNNotificationResponse) {
    let userInfo = response.notification.request.content.userInfo
    
    // Send notification data to Flutter
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/notifications", binaryMessenger: flutterViewController.binaryMessenger)
      
      methodChannel.invokeMethod("onNotificationReceived", arguments: userInfo)
    }
  }
  
  // Handle app becoming active
  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Notify Flutter when app becomes active
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/lifecycle", binaryMessenger: flutterViewController.binaryMessenger)
      methodChannel.invokeMethod("onAppResumed", arguments: nil)
    }
  }
  
  // Handle app going to background
  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Notify Flutter when app goes to background
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/lifecycle", binaryMessenger: flutterViewController.binaryMessenger)
      methodChannel.invokeMethod("onAppPaused", arguments: nil)
    }
  }
  
  // Handle memory warning
  override func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    // Notify Flutter about memory warning
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/system", binaryMessenger: flutterViewController.binaryMessenger)
      methodChannel.invokeMethod("onMemoryWarning", arguments: nil)
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Send location updates to Flutter
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/location", binaryMessenger: flutterViewController.binaryMessenger)
      
      let locationData = locations.map { location in
        [
          "latitude": location.coordinate.latitude,
          "longitude": location.coordinate.longitude,
          "accuracy": location.horizontalAccuracy,
          "altitude": location.altitude,
          "speed": location.speed,
          "timestamp": location.timestamp.timeIntervalSince1970
        ]
      }
      
      methodChannel.invokeMethod("onLocationUpdate", arguments: locationData)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // Send location error to Flutter
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/location", binaryMessenger: flutterViewController.binaryMessenger)
      
      methodChannel.invokeMethod("onLocationError", arguments: ["error": error.localizedDescription])
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Send authorization status to Flutter
    if let flutterViewController = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: "com.tranzfort.tms/location", binaryMessenger: flutterViewController.binaryMessenger)
      
      let statusString: String
      switch status {
      case .authorizedAlways:
        statusString = "always"
      case .authorizedWhenInUse:
        statusString = "whenInUse"
      case .denied:
        statusString = "denied"
      case .restricted:
        statusString = "restricted"
      case .notDetermined:
        statusString = "notDetermined"
      @unknown default:
        statusString = "unknown"
      }
      
      methodChannel.invokeMethod("onAuthorizationChanged", arguments: ["status": statusString])
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
  }
}
