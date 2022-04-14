Pod::Spec.new do |spec|
  spec.name                   = "Youi"
  spec.version                = "4.0.0"
  spec.summary                = "Youi is a small library of UI components to help rapidly prototype and tweak parameters in Satin"
  spec.description            = <<-DESC
  Youi is a small library of UI components (sliders, buttons, dropdown, labels, etc) to help rapidly prototype and tweak Satin parameters
                   DESC
  spec.homepage               = "https://github.com/Hi-Rez/Youi"
  spec.license                = { :type => "MIT", :file => "LICENSE" }
  spec.author                 = { "Reza Ali" => "reza@hi-rez.io" }
  spec.social_media_url       = "https://twitter.com/rezaali"
  spec.source                 = { :git => "https://github.com/Hi-Rez/Youi.git", :tag => spec.version.to_s }

  spec.osx.deployment_target  = "10.15"
  spec.osx.source_files       = "Sources/Youi/*.swift", "Sources/Youi/**/*.swift"
  spec.osx.frameworks         = "AppKit"
  spec.osx.resources          = "Sources/Youi/Resources/Assets.xcassets"

  spec.ios.deployment_target  = "14.0"
  spec.ios.source_files       = "Sources/Youi/*.swift", "Sources/Youi/**/*.swift"
  spec.ios.frameworks         = "UIKit"
  spec.ios.resources          = "Sources/Youi/Resources/Assets.xcassets"

  spec.module_name            = "Youi"
  spec.swift_version          = "5.1"
  spec.dependency             'Satin'
end
