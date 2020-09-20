install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!
target 'Youi macOS' do
  use_frameworks!
  platform :osx, '10.14'
  pod 'Satin', '>= 1.0.0'
  pod 'SwiftFormat/CLI'
end
