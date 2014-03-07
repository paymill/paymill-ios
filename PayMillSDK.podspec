Pod::Spec.new do |s|
  s.name         = 'PayMillSDK'
  s.version      = '2.0.1'
  s.summary      = "PAYMILL iOS SDK enables processing of payments for iOS applications. Visit http://www.paymill.com for more information."
  s.homepage     = "https://www.paymill.com/en-gb/documentation-3/reference/mobile-sdk/"
  s.license      = 'Commercial, :file => License.md'
  s.author       = { "Paymill GmbH" => "support@paymill.de" }
  s.source       = { :git => "https://github.com/paymill/paymill-ios.git", :tag => '2.0.1' }
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.ios.source_files = 'samples/vouchermill/PayMillSDK/PayMillSDK.framework/Versions/A/Headers/*.h'
  s.osx.source_files = 'samples/vouchermill/PayMillSDK/PayMillSDK.framework/Versions/A/Headers/*.h'
  s.ios.vendored_library = 'samples/vouchermill/PayMillSDK.framework/Versions/A/PayMillSDK'
  s.osx.vendored_library = 'macos/PayMillSDK.framework/Versions/A/PayMillSDK'
  s.requires_arc = true
  s.framework =  'Security'
  s.resources    = 'samples/vouchermill/PayMillSDK/PayMillSDK.bundle'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
end
