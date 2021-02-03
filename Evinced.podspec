#
# Be sure to run `pod lib lint Evinced.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Evinced'
  s.version          = '1.0.0'
  s.summary          = 'Evinced internal SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/GetEvinced'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alambov-gd' => 'alambov@evinced.com' }
  s.source           = { :git => 'https://github.com/GetEvinced/ios-sdk-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Evinced/Classes/**/*'
  
  s.resource_bundles = {
    'Evinced' => ['Evinced/Assets/**/*']
  }
  
  s.resources = ['Evinced/Assets/*.{xcassets}']

  s.public_header_files = 'Evinced/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Starscream', '~> 4.0'
end
