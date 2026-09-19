# Copyright 2021 Google LLC
# SPDX-License-Identifier: Apache-2.0

Pod::Spec.new do |s|
  s.name             = 'pay_ios'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
  No-op implementation of the pay plugin on iOS
                       DESC
  s.homepage         = 'https://github.com/google-pay/flutter-plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Google Pay Developer Relations' => 'payments-devrel-flutter@googlegroups.com' }
  s.source           = { :http => 'https://github.com/google-pay/flutter-plugin' }
  s.source_files = 'pay_ios/Sources/pay_ios/**/*'
  s.exclude_files = 'pay_ios/Sources/pay_ios/Resources/**/*'
  s.resource_bundles = { 'pay_ios_privacy' => ['pay_ios/Sources/pay_ios/Resources/PrivacyInfo.xcprivacy'] }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.frameworks  = 'PassKit'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
