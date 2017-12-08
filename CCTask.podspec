Pod::Spec.new do |s|
  s.name         = "CCTask"
  s.version      = "1.0.2"
  s.summary      = "An iOS Thread waiter"
  s.description  = <<-DESC
                    You can use CCTask to make the thread wait until the operation finished.
                   DESC
  s.homepage     = "http://www.wujios.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'youzige' => 'topqicc@163.com' }
  s.source       = { :git => "https://github.com/youzige/CCTask.git", :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'CCTask/*.{h,m}'
  s.frameworks   = "Foundation"
  s.requires_arc = true
end
