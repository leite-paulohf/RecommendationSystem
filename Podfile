platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target 'RecommendationSystemApp' do
    # Swift Pods
    pod 'Kingfisher', :inhibit_warnings => true
    pod 'NVActivityIndicatorView', :inhibit_warnings => true
    pod 'CPF-CNPJ-Validator', :inhibit_warnings => true
    pod 'AFDateHelper', :inhibit_warnings => true
    pod 'ObjectMapper', :inhibit_warnings => true
    pod 'Constraints', :inhibit_warnings => true
    pod 'Tags', :inhibit_warnings => true
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
