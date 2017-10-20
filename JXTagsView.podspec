#
#  Be sure to run `pod spec lint JXTagsView.podspec' to ensure this is a


Pod::Spec.new do |s|

 

  s.name         = "JXTagsView"
  s.version      = "1.0.0"
  s.summary      = "高度封装标签控件"

  s.description  = "支持拖动排序，支持拖动是否滚动，高度自动计算，支持多选单选"
                   
  s.homepage     = "http://github.com/HJXIcon/JXTagsView"
  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  

  s.author             = { "HJXIcon" => "x1248399884@163.com" }
  # Or just: s.author    = "HJXIcon"
  # s.authors            = { "HJXIcon" => "" }
  # s.social_media_url   = "http://twitter.com/HJXIcon"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  

  s.platform     = :ios
  s.platform     = :ios, "8.0"



  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  

  s.source       = { :git => "https://github.com/HJXIcon/JXTagsView.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.source_files  = "Classes", "Classes/JXTagsView/JXTagsView/**/*.{h,m}"



  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
  s.requires_arc = true



end
