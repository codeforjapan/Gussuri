# Gussuri
Gussuri (Good Sleep)
Researchers, healthcare professionals working in clinical settings, and those experiencing sleep problems are working together on a citizen science/civic tech project to address sleep and sleep-related issues in sleep-deprived Japan. As part of this project, we are developing a digital version of a sleep record sheet called "gussuri" which is using Flutter × Firebase.

## Project Setup
```shell
$ brew tap leoafarias/fvm
$ brew install fvm
$ fvm --version
$ fvm install
$ fvm flutter pub get
$ brew install cocoapods
$ fvm flutter emulators
# below information is depends the environment you obtain
# 2 available emulators:
# apple_ios_simulator       • iOS Simulator             • Apple  • ios
# Pixel_3a_API_32_arm64-v8a • Pixel_3a_API_32_arm64-v8a • Google • android
# To run an emulator, run 'flutter emulators --launch <emulator id>'.
# To create a new emulator, run 'flutter emulators --create [--name xyz]'.

# Launch iOS simulator in laptop
$ fvm flutter emulators --launch apple_ios_simulator
# Launch Android simulator in laptop
$ fvm flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# List out the simulators 
$ fvm flutter devices
# 3 connected devices:
# iPhone 14 Pro Max (mobile) • 93E3B70F-B378-4295-BC3E-5DAA4958D463 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
# macOS (desktop)            • macos                                • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
# Chrome (web)               • chrome                               • web-javascript • Google Chrome 111.0.5563.110
# Example CLI result for list out simulator

$ fvm flutter run -d ${deviceのid} # Install the app and run in the simnulator for this env、93E3B70F-B378-4295-BC3E-5DAA4958D463
```

## Recommended development environment 
* AndroidStudio　https://developer.android.com/studio
```
Configuration of Android Studio

Preferences > Language & Frameworks > Flutter , Modify「SDK」with your Flutter SDK path　
/{PATH_OF_YOUR_PROJECT}/.fvm/flutter_sdk
```

* Visual Studio Code　https://code.visualstudio.com/

## Setup the connection with firebase 
*You must install the firebase environment with [firebase CLI](https://firebase.google.com/docs/cli?hl=ja)
```shell
# After installation and setup firebase dev environment、login firebase and setup th e firestore
$ firebase login

$ dart pub global activate flutterfire_cli
# https://console.firebase.google.com/ Select the project ID in this page
# Gussuri-dev env、project of Code for japan。If necessary, we will you invite and handle it.
$ flutterfire configure --project=Gussuri-dev
```
https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios