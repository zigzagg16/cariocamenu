Pod::Spec.new do |s|
  s.name         = "CariocaMenu"
  s.version      = "2.0"
  s.summary      = ""
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/arn00s/cariocamenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Arnaud Schloune" => "arnaud.schloune@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/arn00s/cariocamenu.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
