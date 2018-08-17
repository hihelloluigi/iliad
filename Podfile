## Target platform
platform :ios, '10.0'

## External source
source 'https://github.com/CocoaPods/specs.git'

## Use frameworks
use_frameworks!


def graphics_components_pods
	pod 'SkyFloatingLabelTextField'
	pod 'BEMCheckBox'
	pod 'TransitionButton'
	pod 'SwiftMessages'
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


