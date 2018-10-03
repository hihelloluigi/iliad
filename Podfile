## Target platform
platform :ios, '10.0'

## External source
source 'https://github.com/CocoaPods/specs.git'

## Use frameworks
use_frameworks!

def firebase_pods
	pod 'Firebase/Core'
	pod 'Firebase/Performance'
end

def graphics_components_pods
	pod 'SkyFloatingLabelTextField'
	pod 'BEMCheckBox'
	pod 'TransitionButton'
	pod 'SwiftMessages'
	pod 'NVActivityIndicatorView'
	pod 'BmoViewPager'
end

def networking_pods
    pod 'Moya'
end

def security_pods
	pod 'KeychainAccess'
	pod 'iOSAuthenticator', :git => 'https://github.com/mo3bius/iOSAuthenticator'
end

def utilites_pods
    pod 'SwiftyJSON'
    pod 'IQKeyboardManager'
    pod 'SwiftyUserDefaults'
    pod 'ClusterKit/MapKit'
end

def debugging_pods
    pod 'Reveal-SDK', :configurations => ['Debug']
    pod 'Fabric'
	pod 'Crashlytics'
end

abstract_target 'Abstract Target' do 
	firebase_pods
	graphics_components_pods
	networking_pods
	utilites_pods
	debugging_pods
	security_pods

	target 'IliadProd' do
	end

	target 'IliadStaging' do
	end

	target 'IliadDev' do
	end
end


post_install do |installer|
	installer.pods_project.targets.each do |target|
		if target.name == 'BmoViewPager' || target.name == 'TransitionButton'
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '4'
			end
		end
	end
end


