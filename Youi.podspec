Pod::Spec.new do |spec|
  spec.name                   = "Youi"
  spec.version                = "0.0.1"
  spec.summary                = "Youi is a small library of UI components to help rapidly prototype and tweak parameters in Satin"
  spec.description            = <<-DESC
  Youi is a small library of UI components to help rapidly prototype and tweak parameters in Satin
                   DESC
  spec.homepage               = "https://github.com/Hi-Rez/Youi"
  spec.license                = { :type => "MIT", :file => "LICENSE" }
  spec.author                 = { "Reza Ali" => "reza@hi-rez.io" }
  spec.social_media_url       = "https://twitter.com/rezaali"
  spec.source                 = { :git => "https://github.com/Hi-Rez/Youi.git", :tag => spec.version.to_s }

  spec.osx.deployment_target  = "10.14"
  spec.ios.deployment_target  = "12.4"

  spec.osx.source_files       = "Youi/*.h", "Youi/Shared/*.{h,m,swift}", "Youi/macOS/*.{h,m,swift}"
  spec.ios.source_files       = "Youi/*.h", "Youi/Shared/*.{h,m,swift}", "Youi/iOS/*.{h,m,swift}"

  spec.resources              = "Assets.xcassets"
  spec.osx.frameworks         = "AppKit"
  spec.ios.frameworks         = "UIKit"
  spec.module_name            = "Youi"
  spec.swift_version          = "5.1"
  spec.dependency             'Satin'
end
