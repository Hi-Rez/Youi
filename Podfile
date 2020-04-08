install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true

target 'Youi macOS' do
  use_frameworks!
  platform :osx, '10.15'
  pod 'Satin', :git => 'git@github.com:Hi-Rez/Satin.git'
  pod 'SwiftFormat/CLI'
end

target 'Youi iOS' do
  use_frameworks!
  platform :ios, '13.4'
  pod 'Satin', :git => 'git@github.com:Hi-Rez/Satin.git'
  pod 'SwiftFormat/CLI'
end
