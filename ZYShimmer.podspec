
Pod::Spec.new do |s|
  s.name          = "ZYShimmer"
  s.version       = "0.1.2"
  s.summary       = "Shimmeringe View."
  s.homepage      = "https://github.com/zhouyudk/ZYShimmering/"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "yu zhou" => "384986004@qq.com" }
  s.source        = { :git => "https://github.com/zhouyudk/ZYShimmering.git", :tag => s.version }
  s.source_files  = "Source/*.swift"
  s.ios.deployment_target = "9.0"
  s.swift_versions = "5.0"
end
