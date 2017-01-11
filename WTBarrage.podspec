
Pod::Spec.new do |s|
  s.name             = "WTBarrage"
  s.version          = "1.0.0"
  s.summary          = "A marquee view used on iOS."
  s.description      = <<-DESC
                       It is a marquee view used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/benzhipeng1024/SDWebImageExtend"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "B.E.N" => "benzhipeng1990@gmail.com" }
  s.source           = { :git => "https://github.com/benzhipeng/WTBarrage.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'


  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'WTBarrageDemo/Sources/*.{h,m}'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

  s.dependency 'Masonry', '~> 1.0.1'
  s.dependency 'SDWebImage'
end
