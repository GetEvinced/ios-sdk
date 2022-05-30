# Evinced SDK for iOS applications

## Deprecation notice
The Evinced UIKit SDK is deprecated and will be removed soon. Please see our new and improved mobile accessibility tools [here](https://www.evinced.com/products/automation-mobile).

## Overview
The Evinced iOS solution consists of 2 parts:

### The iOS SDK
It is a simple open source SDK that extracts relevant UI information from the app and sends it securely to the desktop client for analysis. You need to build this with the dev version of your app.

### The desktop application
This receives the raw data from the SDK and analyzes the app for accessibility compliance, detects issues and suggests fixes.

## Importing the Evinced iOS SDK
### Prerequisites
* The current version supports the following:
* Deployment targets on iOS 12.0 and above
* Cocapods as an import mechanism - other frameworks will be supported later.
* Native UIKit based iOS apps - Native swift UI based, React native and Hybrid apps will follow soon.

### How to integrate
1 - Setup a separate build target for running your application with Evinced.
2 - Install the Evinced pod.
3 - Add code to invoke the Evinced SDK within your app.
4 - Select the test target and build the application.

#### STEP 1
Setup a separate build target for running your application with Evinced.
* Clone the existing app target under a different name (in order to prevent conflicts, do not use “Evinced” as a target name).

##### CONTINUE
Add `-D EVINCEDTEST` in "Other Swift Flags" in Build Settings to mark the test target. Use `EVINCEDTEST=1` in "Preprocessed Macros" for Objective C apps.

##### OPTIONAL
if you want to use QR code pairing with the desktop app, AND your test app does not use the camera, then do this step.

Make sure your test target uses a different Info.plist file.
Add the "Privacy - Camera Usage Description" key to the test target Info.plist file via Xcode, or directly edit the Info.plist source code by adding the below into the `<dict> … </dict>` block:
```
<key>NSCameraUsageDescription</key>
<string>Allow pairing via QR code</string>
```

#### STEP 2
Install the Evinced pod.
* Add the following under your target name in Podfile:
```ruby
pod 'EvincedSDKiOS'
```
Your Podfile then should look like this:
```ruby
use_frameworks!

platform :ios, '13.0'

target '<your target name>' do

    pod 'EvincedSDKiOS'

end
```
* Run `pod install` in your project directory;

#### STEP 3
Add code to invoke the Evinced SDK within your app.
* Add the following import statement in `AppDelegate.swift`. Note - even if your application uses the SceneDelegate UIKit lifecycle, you should still use the AppDelegate class to start Evinced.
```swift
#if EVINCEDTEST

    import EvincedSDKiOS

#endif
```
* For Objective C add the below to `AppDelegate.m`
```objc
#ifdef EVINCEDTEST

    @import EvincedSDKiOS;

#endif
```
* Start Evinced engine:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

     // Other code if needed...

    #if EVINCEDTEST

        EvincedEngine.start()

    #endif

    return true
}
```
* For Objective-C code it should look like:
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Other code if needed...

    #ifdef EVINCEDTEST

        [EvincedEngine start];

    #endif

    return YES;

}
```
#### STEP 4
* Run `pod init` in your project directory.
* Select the test target and build the application (make sure that this target builds for iOS 12 and above).
* Use shake gesture to open Evinced SDK screen.
