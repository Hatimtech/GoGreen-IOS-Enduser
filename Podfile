# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GoGreen' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

        pod 'Alamofire', '~> 4.4'
        pod 'MBProgressHUD'
        pod 'AlamofireImage', '~> 3.1'
        pod 'PullToRefresher', '~> 3.0'
        pod 'FacebookCore'
        pod 'FBSDKCoreKit'
        pod 'FacebookLogin'
        pod 'FacebookShare'
        pod 'FBSDKMarketingKit'
        pod 'GoogleSignIn'
        pod 'Google-Mobile-Ads-SDK'
        pod 'IQKeyboardManagerSwift', '5.0.0'
        pod 'DropDown'
        pod 'SlideMenuControllerSwift'
        pod 'AKSideMenu'
        pod 'SinchVerification-Swift'
        pod 'Fabric'
        pod 'Crashlytics'
        pod 'SwipeCellKit'
#        pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :commit => '9bd4543ebd4d7f104b2c4d732782e330500da220'
        pod 'FloatRatingView'
        pod 'Firebase/Core'
        pod 'Firebase/Messaging'
        pod 'BIObjCHelpers', '~> 0.4.3'
        pod 'Mantle', '~> 2.1.0'
        pod 'Lockbox'
        pod 'SDWebImage'
        pod 'DGActivityIndicatorView'
        pod 'SBJson'
        pod 'PINCache'
        pod 'YLGIFImage'
        pod 'Reachability'
        pod 'AFNetworking'
        pod 'CountryPickerSwift', '~> 1.8.0'
	pod 'PayTabs', '~> 4.3.2'
       
        
//
end
#To enable bitcode flag
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
            config.build_settings['ENABLE_BITCODE'] = 'YES'
        end
    end
end

