
xcodeproj 'PackMule.xcodeproj'

target :"PackMule" do
    platform :osx, '10.6'
     
    pod 'FishLamp/Cocoa', :path => '..'
    pod 'FishLamp/CodeGenerator', :path => '..'
    pod 'FishLamp/OSX', :path => '..'

    pod 'HockeySDK-Mac', '~> 2.0.0'
end

# target :"Whittle" do
#    platform :osx, '10.7'
# end

post_install do |installer|
  installer.project.targets.each do |target|
    puts "#{target.name}"
  end
end