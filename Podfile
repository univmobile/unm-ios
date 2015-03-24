# Uncomment this line to define a global platform for your project
platform :ios, '6.0'

target 'unm-ios' do
pod 'AFNetworking', '~> 2.0'
pod 'MFSideMenu'
pod 'SSKeychain'
pod 'Google-Maps-iOS-SDK', '~> 1.9'
pod 'ZBarSDK', '~> 1.3'
pod 'SVPullToRefresh'
pod 'TTTAttributedLabel'
end

target 'unm-iosTests' do

end

# build for all architectures
post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

