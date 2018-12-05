Pod::Spec.new do |s|
#1.
s.name               = "KrishnaSupport"
#2.
s.version            = "1.0.1"
#3.
s.summary            = "Sort description of 'KrishnaSupport' framework"
#4.
s.homepage           = "http://www.hcgharish.com"
#5.
s.license            = "MIT"
#6.
s.author             = "harish"
#7.
s.platform           = :ios, "8.3"
#8.
s.source             = { :git => "https://github.com/hcgharish/KrishnaSupport.git", :tag => "#{s.version}" }
#9.
s.source_files       = "KrishnaSupport", "KrishnaSupport/**/*.{h,m,swift}"
end

# cd /Users/apple/KrishnaSupport/KrishnaSupport && git add -A && git commit -m 'upload' && git push -u origin master && git tag 1.0.1 && git push tag