# ubiparksdk-ios
UbiPark SDK for iOS

CocoaPods:
pod 'UbiParkSDK', :git => 'https://github.com/UbiParkDev/ubiparksdk-ios.git'

Requirements
Important Note: iOS 11.0 introduces breaking changes on how location permission is requested for background ‘Always’ scanning. See below for details on new NSLocationAlwaysAndWhenInUseUsageDescription plist key.

When using UbiPark SDK in an iOS app there are a number of static descriptions required to explain how the app will use Bluetooth and Beacon technology. These are used by iOS to customise permission prompts when requested by the app. These are included in the application plist file as explained below.

Required for App Store submission (not currently displayed to app users):

NSBluetoothPeripheralUsageDescription (Privacy - Bluetooth Peripheral Usage Description)
Location prompt to app users requesting permission to detect beacons either when the app is in use or also when it is closed:

Required when requesting When in Use permission only:

for iOS 8.0 to iOS 11.0 support NSLocationWhenInUseUsageDescription
or required when requesting Always and/or When in Use permission:

for iOS 8.0 to iOS 10.0 support NSLocationAlwaysUsageDescription and
for iOS 11.0 support NSLocationAlwaysAndWhenInUseUsageDescription
Additional Apple documentation on requesting location authorization including escalating your app’s authorization level from When in Use to Always.

Privacy - Bluetooth Peripheral Usage Description in iOS 10.0
Starting in iOS 10 any app using CoreBluetooth is required to include a static NSBluetoothPeripheralUsageDescription plist value in the application plist file (displayed as ‘Privacy - Bluetooth Peripheral Usage Description’). This is a requirement for submission to the App Store for any app that includes the UbiPark SDK or other code that interacts with Bluetooth devices using the CoreBluetooth APIs. The UbiPark SDK uses CoreBluetooth to monitor beacon battery life, apply remote secure settings updates, verify beacon ownership and detect secure beacons. Currently this description is not displayed to app users but could be used in the future so should include appropriate messaging about how beacons are being used by the app.

In case of a failed app submission, for example a rejection stating “Missing Info.plist key - This app attempts to access privacy-sensitive data without a usage description. The app’s Info.plist must contain an NSBluetoothPeripheralUsageDescription key with a string value explaining to the user how the app uses this data.” inclusion of the required key containing a message similar to that used for the location Always or While in Use descriptions should be sufficient to proceed with the submission process.

Location Access Description
Starting in iOS8, iOS requires a description to be presented to the user when an app requests access to a user’s location. It is also recommended that a description be provided when requesting access to a user’s location on iOS7 devices.

Descriptions are provided by adding a Plist entry corresponding to the level of location use requested. Add a description for each level of location access you wish to request. These can easily be entered from the ‘Info’ section of your project target (see below) or directly into your Plist file.

Keys:

NSLocationWhenInUseUsageDescription
NSLocationAlwaysUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
