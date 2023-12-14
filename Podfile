source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GZEApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GZEApp
  pod 'CYLTabBarController'
  pod 'FBRetainCycleDetector' 
  pod 'JXCategoryView'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'GKPhotoBrowser/Core'
  pod 'GKPhotoBrowser/SD'
  pod 'GKPhotoBrowser/AVPlayer'
  pod 'GKPhotoBrowser/Progress'
  pod 'Masonry'
  pod 'MBProgressHUD'
  pod 'MJRefresh' 
  pod 'MLeaksFinder'
  pod 'MMKV'
  pod 'ReactiveObjC'
  pod 'SDCycleScrollView','>= 1.82'
  pod 'TTGTagCollectionView'
  pod 'UICollectionViewLeftAlignedLayout'
  pod 'youtube-ios-player-helper', '~> 1.0.4'
  pod 'YPNavigationBarTransition'
  pod 'YKWoodpecker'
  pod 'YTKNetwork'
  pod 'YYModel'
end

post_install do |installer|
    ## Fix Xcode 14.3 issue
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end

    ## Fix for XCode 12.5
    find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
      "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
    find_and_replace("Pods/FBRetainCycleDetector/fishhook/fishhook.c",
         "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;", "if (i < (sizeof(indirect_symbol_bindings) /
              sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }")
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
