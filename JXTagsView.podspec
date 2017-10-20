Pod::Spec.new do |s|

s.name         = "JXTagsView"
s.version      = "1.0.1"
s.summary      = "标签控件，封装简单，易使用，支持拖拽排序、单多选、高度自适应"

s.homepage     = "https://github.com/HJXIcon/JXTagsView"

s.license      = "MIT"

s.author       = { "HJXIcon" => "x1248399884@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/HJXIcon/JXTagsView.git", :tag => "1.0.1"}


s.source_files  = "JXTagsView/JXTagsView/JXTagsView/**/*.{h,m}"


s.requires_arc = true



end
