
Pod::Spec.new do |spec|

  spec.name         = "FXSlider"
  spec.version      = "0.1.3"
  spec.summary      = "FXSlider its custom implementation of slider such as UISlider."
  spec.homepage     = "https://github.com/dong4255/FXSlider"
  spec.license      = "MIT"
  spec.author             = { "Dong" => "fanxiaodong94@hotmail.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/dong4255/FXSlider.git", :tag => "#{spec.version}" }
  spec.source_files  = "FXSlider/*.{h,swift}"
  spec.swift_version= '5.0'

end
