/************************************************/

Pod::Spec.new do |s|

s.name        = "cainimaB"

s.version      = "0.0.1"

s.summary      = "A marquee view used on iOS."

s.description  = <<-DESC

It is a marquee view used on iOS, which implement by Objective-C.

DESC

s.homepage    = "https://github.com/fangtianfu/caonimaB"

# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

s.license      = "MIT"

s.author      = { "fangtianfu" => "fangtianfu@adsmart.com.cn" }

s.source      = { :git => "https://github.com/fangtianfu/caonimaB.git", :tag => "#{s.version}" }

s.platform    = :ios, '7.0'

# s.ios.deployment_target = '5.0'

# s.osx.deployment_target = '10.7'

s.requires_arc = true

s.source_files  = 'ADSBLEManager/ADSBLEManager/BLEManagerFile/*'

# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'

# s.osx.exclude_files = 'Classes/ios'

# s.public_header_files = 'Classes/**/*.h'

s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end

/************************************************/
