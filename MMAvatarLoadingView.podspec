
Pod::Spec.new do |s|
  s.name             = 'MMAvatarLoadingView'
  s.version          = '0.1.0'
  s.summary          = 'Awesome image loading library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Image loading library that fetches specified image from remote URL, cache it if necessary and view the progress of downloading with handy animaiton. 
                       DESC

  s.homepage         = 'https://github.com/Meseery2/MMAvatarLoadingView.git'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'm7med4ever@gmail.com' => 'eng.m.elmeseery@gmail.com' }
  s.source           = { :git => 'https://github.com/Meseery2/MMAvatarLoadingView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
    s.swift_version = '4.0'
  s.source_files = 'MMAvatarLoadingView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MMAvatarLoadingView' => ['MMAvatarLoadingView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
