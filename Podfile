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
end

def debugging_pods
    pod 'Reveal-SDK', :configurations => ['Debug']
end

abstract_target 'Abstract Target' do 
	firebase_pods
	graphics_components_pods
	networking_pods
	utilites_pods
	debugging_pods
	security_pods

	target 'AreaPersonaleProd' do
	end

	target 'AreaPersonaleStaging' do
	end

	target 'AreaPersonaleDev' do
	end
end


