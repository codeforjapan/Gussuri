# Gussuri
睡眠不足大国日本の寝不足や睡眠にまつわる課題を研究者・臨床現場で働く医療関係者・睡眠の困りごとを抱える当事者がともに考え、ともにつくるシチズンサイエンス・シビックテックのプロジェクトとして、睡眠記録シートのデジタル版「gussuri（ぐっすり）」の開発プロジェクトに取り組んでいます。
本プロジェクトはFlutter×Firebaseで開発されています。

## Requirements
```
flutter --version
Flutter 3.3.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 18a827f393 (6 months ago) • 2022-09-28 10:03:14 -0700
Engine • revision 5c984c26eb
Tools • Dart 2.18.2 • DevTools 2.15.0
```

## Project Setup
```shell
$ flutter pub get
$ brew install cocoapods
$ flutter emulators
# この部分はご自身の環境に依存します
# 2 available emulators:
# apple_ios_simulator       • iOS Simulator             • Apple  • ios
# Pixel_3a_API_32_arm64-v8a • Pixel_3a_API_32_arm64-v8a • Google • android
# To run an emulator, run 'flutter emulators --launch <emulator id>'.
# To create a new emulator, run 'flutter emulators --create [--name xyz]'.

# ios で起動する場合
$ flutter emulators --launch apple_ios_simulator
# android で起動する場合
$ flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# appの起動
$ flutter devices
# 3 connected devices:
# iPhone 14 Pro Max (mobile) • 93E3B70F-B378-4295-BC3E-5DAA4958D463 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
# macOS (desktop)            • macos                                • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
# Chrome (web)               • chrome                               • web-javascript • Google Chrome 111.0.5563.110
# 上記の場合

$ flutter run -d ${deviceのid} # この場合、93E3B70F-B378-4295-BC3E-5DAA4958D463
```

## 推奨環境
* AndroidStudio　https://developer.android.com/studio
* Visual Studio Code　https://code.visualstudio.com/

## firebaseとの初期接続時
https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios
```shell
# それぞれの開発環境で、firestoreセットアップをして以下のコマンドでログインをする
$ firebase login

$ dart pub global activate flutterfire_cli
$ flutterfire configure
```
