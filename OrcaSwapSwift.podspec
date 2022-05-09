Pod::Spec.new do |s|
  s.name             = 'OrcaSwapSwift'
  s.version          = '2.0.0'
  s.summary          = 'A client for OrcaSwap written in Swift.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/p2p-org/OrcaSwapSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chung Tran' => 'bigearsenal@gmail.com' }
  s.source           = { :git => 'https://github.com/p2p-org/OrcaSwapSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version    = '5.5'

  s.source_files = 'Sources/OrcaSwapSwift/**/*'
  # s.resources = 'Sources/OrcaSwapSwift/Resources/*'
  
  # s.resource_bundles = {
  #   'OrcaSwapSwift' => ['OrcaSwapSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SolanaSwift', '~> 2.0.0'
end
