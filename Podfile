
xcodeproj 'PackMule.xcodeproj'

target :"PackMule" do
    platform :osx, '10.6'
     
    pod 'FishLamp/Cocoa/Async', :path => 'FishLamp'
    pod 'FishLamp/Cocoa/CodeGenerator', :path => 'FishLamp'
    pod 'FishLamp/Cocoa/Encoding', :path => 'FishLamp'

    pod 'FishLamp/OSX/TextViewController', :path => 'FishLamp'
    pod 'FishLamp/OSX/TextViewLogger', :path => 'FishLamp'
    pod 'FishLamp/OSX/ErrorWindowController', :path => 'FishLamp'

#    pod 'FishLamp/OSX', :path => 'FishLamp'

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