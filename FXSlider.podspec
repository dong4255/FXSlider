
Pod::Spec.new do |spec|

  spec.name         = "FXSlider"
  spec.version      = "0.1.2"
  spec.summary      = "FXSlider its custom implementation of slider such as UISlider."
  spec.description  = <<-DESC
	自定义的UISlider，继承自UIControl
                   DESC
  spec.homepage     = "https://github.com/dong4255/FXSlider"
  spec.license      = "MIT"
  spec.author             = { "Dong" => "fanxiaodong94@hotmail.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/dong4255/FXSlider.git", :tag => "#{spec.version}" }
  spec.source_files  = "FXSlider/*.{h,swift}"
  spec.swift_version= '5.0'

end
