Pod::Spec.new do |s|
  s.name         = 'View-Controller-Transitions-Library'
  s.version      = '1.0.0'
  s.summary      = 'A collection of interactive iOS 7 custom transitions, including flip, fold, cross-fade and more'
  s.author = {
    'Colin Eberhardt' => 'colin.eberhardt@gmail.com'
  }
  s.source = {
    :git => 'https://github.com/ColinEberhardt/View-Controller-Transitions-Library.git',
    :tag => '1.0.0'
  }
  s.license      = {
    :type => 'MIT',
    :file => 'MIT-LICENSE.txt'
  }
  s.source_files = 'AnimationControllers/*.{h,m}' 
  s.homepage = 'https://github.com/ColinEberhardt/View-Controller-Transitions-Library'
end