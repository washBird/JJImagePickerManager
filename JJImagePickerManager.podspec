#
#  Be sure to run `pod spec lint JJImagePickerManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "JJImagePickerManager"
  s.version      = "0.1"
  s.summary      = "A image picker manager"

  s.homepage     = "https://github.com/washBird/JJImagePickerManager"
  s.license      = "MIT"
  s.author       = { "zoujie" => "http://www.jianshu.com/u/53c30d50712c" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/washBird/JJImagePickerManager.git", :tag => "#{s.version}" }

  s.source_files = "JJImagePickerManager/JJImagePickerManager/*.{h,m}"

end
