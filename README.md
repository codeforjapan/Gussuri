# Gussuri
睡眠不足大国日本の寝不足や睡眠にまつわる課題を研究者・臨床現場で働く医療関係者・睡眠の困りごとを抱える当事者がともに考え、ともにつくるシチズンサイエンス・シビックテックのプロジェクトとして、睡眠記録シートのデジタル版「gussuri（ぐっすり）」の開発プロジェクトに取り組んでいます。
本プロジェクトはFlutter×Firebaseで開発されています。

## Project Setup
```shell
$ brew tap leoafarias/fvm
$ brew install fvm
$ fvm --version
$ fvm install
$ fvm flutter pub get
$ brew install cocoapods
$ fvm flutter emulators
# この部分はご自身の環境に依存します
# 2 available emulators:
# apple_ios_simulator       • iOS Simulator             • Apple  • ios
# Pixel_3a_API_32_arm64-v8a • Pixel_3a_API_32_arm64-v8a • Google • android
# To run an emulator, run 'flutter emulators --launch <emulator id>'.
# To create a new emulator, run 'flutter emulators --create [--name xyz]'.

# ios で起動する場合
$ fvm flutter emulators --launch apple_ios_simulator
# android で起動する場合
$ fvm flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# appの起動
$ fvm flutter devices
# 3 connected devices:
# iPhone 14 Pro Max (mobile) • 93E3B70F-B378-4295-BC3E-5DAA4958D463 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
# macOS (desktop)            • macos                                • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
# Chrome (web)               • chrome                               • web-javascript • Google Chrome 111.0.5563.110
# 上記の場合

$ fvm flutter run -d ${deviceのid} # この場合、93E3B70F-B378-4295-BC3E-5DAA4958D463
```

## 推奨環境
* AndroidStudio　https://developer.android.com/studio
```
Android Studio の設定例

Preferences > Language & Frameworks > Flutter の 「SDK」内 Flutter SDK path　に以下のパスを入力します。
/{プロジェクトまでのパス}/.fvm/flutter_sdk
```

* Visual Studio Code　https://code.visualstudio.com/

## firebaseとの初期接続時
*事前にfirebaseの環境のご用意と[firebase CLI](https://firebase.google.com/docs/cli?hl=ja)をインストールしている必要があります。
```shell
# それぞれの開発環境で、firestoreセットアップをして以下のコマンドでログインをする　
$ firebase login

$ dart pub global activate flutterfire_cli
# https://console.firebase.google.com/ このページで対象の projectのidを選択する
# Gussuri-devの環境は、Code for japanが開発用に用意したプロジェクトです。必要な場合は招待して対応します
$ flutterfire configure --project=Gussuri-dev
```
https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios