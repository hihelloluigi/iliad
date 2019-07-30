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
	pod 'ClusterKit/MapKit'
end

def networking_pods
    pod 'Moya'
end

def security_pods
	pod 'KeychainAccess'
	pod 'iOSAuthenticator'
end

def utilites_pods
    pod 'SwiftyJSON'
	pod 'IQKeyboardManagerSwift'
    pod 'SwiftyUserDefaults'
	pod 'R.swift'
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

	target 'Iliad Production' do
	end

	target 'Iliad Testing' do
	end

	target 'Iliad Staging' do
	end

	target 'Iliad Development' do
	end
end
