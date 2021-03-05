# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Mission Athletics' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mission Athletics
  
#  Insatlled using swift package manager
#pod 'ObjectMapper'
#pod 'SDWebImage'
#pod 'Alamofire'
#  Insatlled using swift package manager

pod 'IQKeyboardManagerSwift'
pod 'SwiftValidators'
pod 'ISEmojiView'
pod 'SVProgressHUD'
pod 'FacebookCore'
pod 'FacebookLogin'
#pod 'FacebookShare'
pod 'Firebase/Messaging'
pod 'Socket.IO-Client-Swift', '~> 13.3.0'
pod 'Optik'
pod 'FSCalendar'
#pod 'QuickBlox'
#pod 'Quickblox-WebRTC', '~> 2.7'
pod 'TwilioVideo', '~> 3.2'
pod 'ReverseExtension'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end

end
