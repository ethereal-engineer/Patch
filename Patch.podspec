Pod::Spec.new do |s|
  s.name             = "Patch"
  s.version          = "0.1.0"
  s.summary          = "A stand-in for the real Patch, coming VERY soon."
  s.description      = <<-DESC
                       Patch is a flexible datasource framework for iOS. You're going to love it.
                       DESC
  s.homepage         = "https://github.com/iosengineer/Patch"
  s.license          = 'MIT'
  s.author           = { "Adam Iredale" => "@iosengineer" }
  s.source           = { :git => "https://github.com/iosengineer/Patch.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/iosengineer'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
 
  s.frameworks = 'UIKit'
end
