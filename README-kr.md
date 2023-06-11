# Gussuri
저희는 수면 기록지의 디지털 버전인 "Gussuri”라는 프로젝트를 개발하고 있습니다. 
Gussuri는 연구자들과 임상 현장에서 일하는 의료진, 수면 문제가 있는 사람들이 함께 생각하는 시민과학 시빅테크 프로젝트입니다. 
이 프로젝트는 Flutter×Firebase로 개발되고 있습니다.

## Project Setup
```shell
$ brew tap leoafarias/fvm
$ brew install fvm
$ fvm --version
$ fvm install
$ fvm flutter pub get
$ brew install cocoapods
$ fvm flutter emulators
# 아래와 같이 개별적인 개발 환경에 따라 다르게 적용할 수 있습니다.
# 2 available emulators:
# apple_ios_simulator       • iOS Simulator             • Apple  • ios
# Pixel_3a_API_32_arm64-v8a • Pixel_3a_API_32_arm64-v8a • Google • android
# To run an emulator, run 'flutter emulators --launch <emulator id>'.
# To create a new emulator, run 'flutter emulators --create [--name xyz]'.

# ios로 개발하는 경우
$ fvm flutter emulators --launch apple_ios_simulator
# Android Studio로 개발하는 경우
$ fvm flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# 앱 런칭
$ fvm flutter devices
# 3 connected devices:
# iPhone 14 Pro Max (mobile) • 93E3B70F-B378-4295-BC3E-5DAA4958D463 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
# macOS (desktop)            • macos                                • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
# Chrome (web)               • chrome                               • web-javascript • Google Chrome 111.0.5563.110
# 위와 같은 경우

$ fvm flutter run -d ${deviceのid} # 이와 같은 경우、93E3B70F-B378-4295-BC3E-5DAA4958D463
```

## 추천 개발 환경
* AndroidStudio　https://developer.android.com/studio
```
Android Studio로 작업하는 경우 예시

Preferences > Language & Frameworks > 아래와 같이 Flutter SDK 경로로 접근하세요.
/{프로젝트로 접근하기}/.fvm/flutter_sdk
```

* Visual Studio Code　https://code.visualstudio.com/

## Firebase로 시작하기
*Firebase 환경을 갖추고 있어야 하며 [firebase CLI](https://firebase.google.com/docs/cli?hl=ja)를 미리 설치해야 합니다. 
```shell
# 각자의 개발 환경에서 다음 명령을 사용하여 Firestore를 설정하고 로그인합니다.
$ firebase login

$ dart pub global activate flutterfire_cli
# https://console.firebase.google.com/ 이 페이지에서 대상 프로젝트의 ID를 선택하세요.
# Gussuri 개발 환경은 Code for Japan(코드포재맨)이 지원하는 프로젝트입니다. 필요하실 경우 응답 요청을 위해 연락드리겠습니다.
$ flutterfire configure --project=Gussuri-dev
```
https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios
