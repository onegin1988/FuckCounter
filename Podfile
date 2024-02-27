# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'
inhibit_all_warnings!

target 'FuckCounter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'lottie-ios'
  pod 'GoogleSignIn'
  pod 'KeychainSwift'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
#      if target.name == "Firebase"
#        xcconfig_path = config.base_configuration_reference.real_path
#        xcconfig = File.read(xcconfig_path)
#        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
#        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
#      end
    end
  end
end
