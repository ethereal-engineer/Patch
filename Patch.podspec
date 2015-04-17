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

  s.default_subspec = 'base' # make all optional pods opt-in

  s.subspec 'base' do |ss|
    ss.source_files = 'Pod/Classes/Base/**/*'
    ss.frameworks = 'UIKit'
  end

  s.subspec 'iCarousel' do |ss|
    ss.dependency 'Patch/base', 'iCarousel'
    ss.source_files = 'Pod/Classes/Adapters/PDSCarouselDataSourceAdapter.{m,h}'
  end

  s.subspec 'CoreData' do |ss|
    ss.dependency 'Patch/base'
    ss.frameworks = 'CoreData'
    ss.source_files = 'Pod/Classes/Extensions/PDSCoreDataSource.{m,h}'
  end

#
#  // Coming Soon...
#
#  s.subspec 'YapDatabase' do |ss|
#    ss.dependency 'Patch/base', 'YapDatabase'
#    ss.source_files = 'Pod/Classes/Extensions/PDSYapDataSource.{m,h}'
#  end
#

end
