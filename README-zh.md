## Gussuri
Gussuri (中譯：睡得香)
Gussuri項目是由日本的研究人員、臨床專業人員和睡眠問題患者開發的公民科技項目。旨在調查和解決與日本睡眠和失眠有關的問題，而然日本是以睡眠不足而聞名。該項目是以使用Flutter × Firebase 創建數碼版本的睡眠記錄表。

## 項目設置

要設置項目，請按照以下步驟進行：

```
$ brew tap leoafarias/fvm
$ brew install fvm
$ fvm --version
$ fvm install
$ fvm flutter pub get
$ brew install cocoapods
$ fvm flutter emulators
# This part depends on your environment
# 2 available emulators:
# apple_ios_simulator       • iOS Simulator             • Apple  • ios
# Pixel_3a_API_32_arm64-v8a • Pixel_3a_API_32_arm64-v8a • Google • android
# 利用Flutter 啟動模擬器, run 'flutter emulators --launch <emulator id>'.
# To create a new emulator, run 'flutter emulators --create [--name xyz]'.

# 啟動IOS模擬裝置
$ fvm flutter emulators --launch apple_ios_simulator
# 啟動 ANDROID 模擬裝置
$ fvm flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# 在模擬器安裝和啟動 Gussuri APP
$ fvm flutter devices
# 3 connected devices:
# iPhone 14 Pro Max (mobile) • 93E3B70F-B378-4295-BC3E-5DAA4958D463 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-16-2 (simulator)
# macOS (desktop)            • macos                                • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
# Chrome (web)               • chrome                               • web-javascript • Google Chrome 111.0.5563.110
# In this case,

$ fvm flutter run -d ${device_id} # In this case, 93E3B70F-B378-4295-BC3E-5DAA4958D463

```


## 推薦環境

- AndroidStudio https://developer.android.com/studio

```
Android Studio的設置示例

在Preferences > Language & Frameworks > Flutter 修改’SDK’路徑，並輸入以下路徑。
/{project_path}/.fvm/flutter_sdk

```

- Visual Studio Code https://code.visualstudio.com/

## 與Firebase連接

- 這需要事先準備firebase環境和安裝firebase CLI。

```
# 在開發環境中設置firestore，並使用以下命令登錄
$ firebase login

$ dart pub global activate flutterfire_cli
# 在此頁面上選擇項目ID<https://console.firebase.google.com/>
# Gussuri-dev是開發環境，是由Code for Japan為開發目的準備。必要時我們會邀請您。
$ flutterfire configure --project=Gussuri-dev

```

有關更多詳細信息，請參閱此頁面[https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios。](https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios%E3%80%82)