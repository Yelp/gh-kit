Pod::Spec.new do |s|
  s.name         = "GHKitYelpFork"
  s.version      = "1.0.3"
  s.summary      = "The GHKit framework is a set of extensions and utilities for Mac OS X and iOS."
  s.homepage     = "http://github.com/Yelp/gh-kit"
  s.license      = "MIT"
  s.author       = "Yelp"
  s.source       = { :git => 'https://github.com/Yelp/gh-kit.git', :tag => 'v' + s.version.to_s }  
  s.platform     = :ios
  s.ios.deployment_target = "6.0"
  s.header_dir   = "GHKit"
  s.requires_arc = false

  s.source_files = "Classes/**/*.{h,m}"
end
