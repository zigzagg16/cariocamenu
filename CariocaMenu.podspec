Pod::Spec.new do |s|
  s.name = 'CariocaMenu'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'The fastest zero-tap iOS menu.'
  s.homepage = 'https://github.com/'
  s.social_media_url = 'https://twitter.com/arnaud_momo'
  s.authors = { 'Arnaud Schloune' => 'arnaud.schloune@gmail.com' }
  s.source = { :git => 'https://github.com/arn00s/cariocamenu.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Library/*.swift'

  s.requires_arc = true
end
