Pod::Spec.new do |s|
  s.name                  = "TextDrawer"
  s.version               = "1.0.9"
  s.summary               = "TextDrawer, is a UIView allows you to add text, with gesture, on UIView, or UIImage."
  s.requires_arc          = true
  s.homepage              = "https://github.com/remirobert/TextDrawer"
  s.ios.deployment_target = '8.0'
  s.screenshots           = "http://share.gifyoutube.com/vJAB4g.gif"

  s.license               = "MIT"

  s.social_media_url      = 'https://twitter.com/remi936'
  s.author                = { "rémi " => "remirobert33530@gmail.com" }

  s.source                = { :git => "https://github.com/Foild/TextDrawer.git", :tag => "1.0.9" }
  s.source_files          = 'TextDrawer/TextDrawer/*.swift'
  s.dependency 'Masonry'
end
