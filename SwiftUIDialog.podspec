Pod::Spec.new do |s|
  s.name             = 'SwiftUIDialog'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.homepage         = 'https://github.com/duyduong/dddialog'
  s.author           = { 'Duong Dao' => 'dduy.duong@gmail.com' }

  s.summary          = 'DDDialog is a simple library for preseting a dialog using SwiftUI'
  s.source           = { :git => 'https://github.com/duyduong/dddialog.git', :tag => s.version }
  s.swift_versions   = ['5']

  s.platform              = :ios, '14.0'
  s.ios.deployment_target = '14.0'
  s.source_files = 'Sources/DDDialog/**/*.swift'
  s.resource_bundles = {
    'DDialog' => ['Sources/DDDialog/PrivacyInfo.xcprivacy'] 
  }
end
