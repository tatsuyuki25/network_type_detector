#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint network_type_detector.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'network_type_detector'
  s.version          = '0.0.1'
  s.summary          = 'This package allows your Flutter app to detect the current network type, supporting 2G, 3G, 4G, 5G, and Wi-Fi.'
  s.description      = <<-DESC
A Flutter plugin to detect the current network type. It provides support for identifying various network connections such as 2G, 3G, 4G, 5G, and Wi-Fi by leveraging native platform APIs.
                       DESC
  s.homepage         = 'https://github.com/tatsuyuki25/network_type_detector'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'tatsuyuki' => 'jordandes@gmail.com' }
  s.source           = { :git => 'https://github.com/tatsuyuki25/network_type_detector.git', :tag => s.version.to_s }
  s.source_files = 'network_type_detector/Sources/**/*'
  s.dependency 'Flutter'
  s.dependency 'ReachabilitySwift', '~> 5.2.4'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
