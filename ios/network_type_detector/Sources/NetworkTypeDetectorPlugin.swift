import Flutter
import UIKit
import Reachability
import CoreTelephony

public class NetworkTypeDetectorPlugin: NSObject, FlutterPlugin {

  private var reachability: Reachability?
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "network_type_detector", binaryMessenger: registrar.messenger())
    let instance = NetworkTypeDetectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let streamChannel = FlutterEventChannel(name: "network_type_detector_status", binaryMessenger: registrar.messenger())
    streamChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "networkStatus" {
      result(statusForNetWork())
    }else{
      result(FlutterMethodNotImplemented)
    }
  }
}

extension NetworkTypeDetectorPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    // Add notification
    NotificationCenter.default.addObserver(self, selector:#selector(networkStatusChange(_:)) , name: .reachabilityChanged, object: nil)
    do {
      reachability = try Reachability()
      try reachability?.startNotifier()
    }catch(let erro as NSError){
      return FlutterError(code: "\(erro.code)", message: erro.domain, details: "Failed to initialize network monitoring");
    }
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if reachability != nil {
      do {
        try reachability?.startNotifier()
        reachability = nil
      }catch(let erro as NSError){
        return FlutterError(code: "\(erro.code)", message: erro.domain, details: "Failed to stop network monitoring");
      }
    }
    NotificationCenter.default.removeObserver(self)
    return nil
  }


  @objc func networkStatusChange(_ notice: Notification) {
    eventSink?(statusForNetWork())
  }

  private func statusForNetWork() -> String {
    // 0:unreachable 1:2G 2:3G 3:Wi-Fi 4:4G 5:5G 6:othermobie
    if reachability == nil {
      reachability = try! Reachability()
    }
    guard let netReach = reachability else { return "0" }
    switch netReach.connection {
    case .wifi:
      return NetworkStatus.wifi.value
    case .unavailable:
      return NetworkStatus.unreach.value
    case .cellular:
      let teleInfo = CTTelephonyNetworkInfo()
      var access: String?
      if #available(iOS 12.0, *) {
          guard let serviceDict = teleInfo.serviceCurrentRadioAccessTechnology,
                let firstKey = serviceDict.keys.first else {
              return NetworkStatus.other.value
          }
          access = serviceDict[firstKey]
      } else {
          access = teleInfo.currentRadioAccessTechnology
      }
      
      guard let access = access else {
        return  NetworkStatus.other.value
      }

      if [CTRadioAccessTechnologyEdge,
        CTRadioAccessTechnologyGPRS,
        CTRadioAccessTechnologyCDMA1x].contains(access) {
        return NetworkStatus.mobile2G.value
      }

      if [CTRadioAccessTechnologyHSDPA,
        CTRadioAccessTechnologyWCDMA,
        CTRadioAccessTechnologyHSUPA,
        CTRadioAccessTechnologyCDMAEVDORev0,
        CTRadioAccessTechnologyCDMAEVDORevA,
        CTRadioAccessTechnologyCDMAEVDORevB,
        CTRadioAccessTechnologyeHRPD].contains(access) {
        return NetworkStatus.mobile3G.value
      }

      if [CTRadioAccessTechnologyLTE].contains(access) {
        return NetworkStatus.mobile4G.value
      }
      if #available(iOS 14.1, *), [CTRadioAccessTechnologyNRNSA,
                                  CTRadioAccessTechnologyNR].contains(access) {
        return NetworkStatus.mobile5G.value
    }
      return NetworkStatus.other.value
    }
  }

  enum NetworkStatus: String {
    case unreach = "UNREACHABLE"
    case mobile2G = "MOBILE_2G"
    case mobile3G = "MOBILE_3G"
    case wifi = "WIFI"
    case mobile4G = "MOBILE_4G"
    case mobile5G = "MOBILE_5G"
    case other = "MOBILE_OTHER"
    var value: String{
      return "\(self.rawValue)"
    }
  }
}