Pod::Spec.new do |s|
  s.name         = "NetworkActivityIndicatorManager"
  s.version      = "0.1.0"
  s.summary      = "A manager library of the network activity indicator."
  s.description  = <<-DESC
                   NetworkActivityIndicatorManager is a manager library of the network activity indicator in the status bar.
                   DESC

  s.homepage     = "https://github.com/ymyzk/NetworkActivityIndicatorManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Yusuke Miyazaki" => "miyazaki.dev@gmail.com" }
  s.social_media_url   = "https://twitter.com/ymyzk"

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/ymyzk/NetworkActivityIndicatorManager.git", :tag => "#{s.version}" }

  s.source_files  = "Source/*.{h,m,swift}"
  s.public_header_files = "Source/*.h"

  s.frameworks = "Foundation", "UIKit"
end
