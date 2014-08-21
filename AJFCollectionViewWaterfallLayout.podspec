#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AJFCollectionViewWaterfallLayout"
  s.version          = "0.3.0"
  s.summary          = "UICollectionViewLayout subclass that accomodates sections with different numbers of columns."
  s.description      = <<-DESC
                       A UICollectionViewLayout subclass that allows you to specify a different number of columns for each section.  Cells will be tiled in a waterfall (Pinterest-style) layout with new cells always appearing in the shortest column.
                       DESC
  s.homepage         = "https://github.com/austinfitzpatrick/AJFCollectionViewWaterfallLayout"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Austin Fitzpatrick" => "fitzpatrick.austin@gmail.com" }
  s.source           = { :git => "https://github.com/austinfitzpatrick/AJFCollectionViewWaterfallLayout.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
