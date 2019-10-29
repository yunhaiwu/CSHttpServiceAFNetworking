Pod::Spec.new do |s|


s.name         = "CSHttpServiceAFNetworking"
s.version      = "1.0.1"
s.summary      = "基于AFNetworking对CSHttpServiceAPI实现."

s.description  = <<-DESC
    http服务组件（AFNetworking）
DESC

s.homepage     = "https://github.com/yunhaiwu"


s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "吴云海" => "halayun@gamil.com" }


s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/yunhaiwu/CSHttpServiceAFNetworking.git", :tag => "#{s.version}" }

s.source_files  = "CSHttpServiceAFNetworking/*.{h,m}"
s.exclude_files = "Example"

s.public_header_files = "CSHttpServiceAFNetworking/*.h"

s.frameworks = "Foundation"

s.requires_arc = true

s.dependency "CocoaService"
s.dependency "CSHttpServiceAPI", '~>1.0.0'
s.dependency "AFNetworking/NSURLSession", '~> 3.0'

end
