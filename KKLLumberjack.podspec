#
# Be sure to run `pod lib lint KKLLumberjack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKLLumberjack'
  s.version          = '0.4.4'
  s.summary          = 'A short description of KKLLumberjack.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git.mistong.com/ios-framework/KKLLumberjack'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张丽' => 'zhangli1959@kaike.la' }
  s.source           = { :git => 'http://git.mistong.com/ios-framework/KKLLumberjack.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KKLLumberjack/Classes/**/*'
  s.ios.vendored_frameworks = 'KKLLumberjack/Frameworks/CrashReporter.framework'
  # s.resource_bundles = {
  #   'KKLLumberjack' => ['KKLLumberjack/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  #s.dependency 'AFNetworking', '~> 3.1.0'
  # pod 'KKLConfigManager'
  s.dependency 'CocoaLumberjack', '~> 3.4.1'
  #s.dependency 'PLCrashReporter', '~> 1.2.0'
end
