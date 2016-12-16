Pod::Spec.new do |s|
  s.name     = 'Swizzle'
  s.version  = '0.1.0'
  s.license  = { :type => 'MIT' }
  s.homepage = 'https://github.com/inamiy/Swizzle'
  s.authors  = { 'Yasuhiro Inami' => 'inamiy@gmail.com' }
  s.summary  = 'Method-Swizzling for Swift.'
  s.source   = { :git => 'https://github.com/inamiy/Swizzle.git', :tag => "#{s.version}" }

  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Swizzle/*.swift'
end
