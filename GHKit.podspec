Pod::Spec.new do |s|
  s.name         = "GHKit"
  s.version      = "1.0.0"
  s.summary      = "The GHKit framework is a set of extensions and utilities for Mac OS X and iOS."
  s.homepage     = "http://github.com/Yelp/gh-kit"
  s.license      = "MIT"
  s.author       = "Yelp"
  s.source       = { :git => 'https://github.com/Yelp/gh-kit', :tag => 'v1.0.0' }  
  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.7"

  s.source_files = "Classes/**/*.{h,m}"
  s.ios.exclude_files = "Classes/MacOSX/*"
  s.osx.exclude_files = "Classes/MacOSX/*"
end
