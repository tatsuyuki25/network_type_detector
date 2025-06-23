# network_type_detector

[![Pub](https://img.shields.io/pub/v/network_type_detector.svg?style=flat-square)](https://pub.dartlang.org/packages/network_type_detector)

This package allows your Flutter app to detect the current network type, supporting 2G, 3G, 4G, 5G, and Wi-Fi. The iOS plugin now supports both CocoaPods and Swift Package Manager integration, with a minimum deployment target of iOS 12.0.

"network_type_detector" is a Flutter package inspired by the connection_network_type library. This package has been updated to support configurations for the Android namespace. Additionally, it is designed to use specific Android APIs based on different versions of Android. This approach allows the package to better adapt to various versions of the Android system, providing accurate network connection type detection. This is particularly important for the development of cross-platform applications.

## Example

1. To detect the current Network Type:

    ```dart
        // If this plugin is used on Android, request the READ_PHONE_STATE permission.
        if(Platform.isAndroid) {
            await Permission.phone.request();
        }

        NetworkStatus networkStatus = await ConnectionNetworkType().currentNetworkStatus();
        
        switch(networkStatus) {
          case NetworkStatus.unreachable:
            // unreachable
          case NetworkStatus.wifi:
            // wifi
          case NetworkStatus.mobile2G:
            // 2G
          case NetworkStatus.mobile3G:
            // 3G
          case NetworkStatus.mobile4G:
            // 4G
          case NetworkStatus.mobile5G:
            // 5G
          case NetworkStatus.otherMobile:
            // other connection
        }
    ```

2. To listen changes on Network Type:

    ```dart
        ConnectionNetworkType().onNetworkStateChanged
            .listen((NetworkStatus networkStatus) {
            // Trigger one function or manage state from here
        });
    ```
