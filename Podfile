install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!

target 'Youi macOS' do
  platform :osx, '10.15'
  pod 'Satin'
end

target 'Youi iOS' do
  platform :ios, '14.0'
  pod 'Satin'
end
