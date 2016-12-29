Pod::Spec.new do |s|
  s.name         = "CariocaMenu"
  s.version      = "1.1"
  s.summary      = "The fastest zero-tap iOS menu"
  s.description  = <<-DESC
                   A simple, fast, and very accessible menu for your iOS apps.
                   The menu will show when the user slides from an edge of the screen, or taps on it.
                   DESC
  s.homepage     = "https://github.com/arn00s/cariocamenu"
  s.screenshots  = "https://raw.githubusercontent.com/arn00s/cariocamenu/master/cariocamenu.gif"
  s.license      = "MIT"
  s.author       = { "Arnaud Schloune" => "arnaud.schloune@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/arn00s/cariocamenu.git", :tag => "1.1" }
  s.source_files  = "Classes", "carioca/Library/CariocaMenu.swift"
  s.requires_arc = true
  s.social_media_url   = "http://twitter.com/arnaud_momo"
end
