# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

flutter_application_path = '/Users/fauzanakmalmahdi/Documents/Main/Flutter Project/flutter_module1'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
  
target 'sample_application2' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for sample_application2
  
  # Flutter Module Configuration
  install_all_flutter_pods(flutter_application_path)

  target 'sample_application2Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'sample_application2UITests' do
    # Pods for testing
  end
  
  # pod 'SampleLibrary2', :path => '/Users/fauzanakmalmahdi/Documents/Main/iOS Project/SampleLibrary2'
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
  installer.pods_project.targets.each do |target|
   flutter_additional_ios_build_settings(target)
   target.build_configurations.each do |config|
         config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
           '$(inherited)',
           'PERMISSION_MICROPHONE=1',
           'PERMISSION_CAMERA=1',
           'PERMISSION_PHOTOS=1',
         ]
       end
 end
end
