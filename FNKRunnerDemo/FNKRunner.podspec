Pod::Spec.new do |s|
s.name         = "FNKRunner"
s.version      = "1.2.0"
s.summary      = "FNKRunner"
s.description  = <<-DESC
Execute Objective-C code Dynamically. iOS hotfix SDK.
DESC
s.homepage     = "https://github.com/frankKiwi/HotfixSolve.git"
s.license      = "MIT"
s.author             = { "HotfixSolve" => "xxx.qq.com" }
s.ios.deployment_target = "9.0"
s.source       = { :git => "https://github.com/frankKiwi/HotfixSolve.git", :tag => "#{s.version}" }
s.source_files  = "FNKRunner/**/*.{h,m,c,mm}"
s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
s.vendored_libraries  = 'FNKRunner/libffi/libffi.a'
s.dependency "ORPatchFile", "1.2.0"
end

