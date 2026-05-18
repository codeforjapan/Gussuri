# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

**Gussuri（ぐっすり）** は、睡眠記録シートのデジタル版シビックテックアプリ。Flutter × Firebase で開発。ユーザー認証なし、デバイス固有IDを Firestore のコレクション識別子として使用する。IDは iOS Keychain（`flutter_secure_storage`）に永続保存し、初回起動時に `identifierForVendor` から移行する（アプリ再インストール後も同じIDを返す）。Android は `androidInfo.id`（SSAID、再インストールで変わらない）。

## 開発コマンド

```sh
# Flutter バージョン管理（FVM 3.41.5 固定）
brew tap leoafarias/fvm && brew install fvm
fvm install
fvm flutter pub get

# iOS 実機/シミュレータ起動
fvm flutter emulators --launch apple_ios_simulator
fvm flutter run -d <device_id>

# Android 起動
fvm flutter emulators --launch Pixel_3a_API_32_arm64-v8a

# ビルド
fvm flutter build ios
fvm flutter build apk

# l10n 自動生成（lib/gen_l10n/ 以下が生成される）
fvm flutter gen-l10n

# 静的解析
fvm flutter analyze

# テスト
fvm flutter test
```

## アーキテクチャ

### 画面構成（TabItem enum）
- `Home`（`home.dart`）: 今日の睡眠記録ボタン + gussuri チャレンジTips
- `Calendar`（`calendar.dart`）: `table_calendar` で睡眠記録一覧。日付タップで Input / Edit へ遷移
- `Print`（`print.dart`）: 指定期間の CSV エクスポート
- `Help`（`help.dart`）: プライバシーポリシー・利用規約リンク

### ナビゲーション
`Base`（`base.dart`）がボトムナビゲーションの親。各タブは独立した `Navigator` を持つ `Offstage` ウィジェット。

### 状態管理
`provider` パッケージ。`CalenderState`（`utils.dart`）が `kEvents`（`Map<DateTime, List<Event>>`）をアプリ全体で共有。`getEvents()` はデバイスIDを使い Firestore から取得する処理だが、`base.dart`・`home.dart`・`calendar.dart` に重複実装されている。

### デバイスID管理（`lib/helper/DeviceData.dart`）
`DeviceData.getDeviceUniqueId()` はシングルトン Future でレース条件を防ぐ。初回呼び出し時に Keychain を確認し、なければ `identifierForVendor`（iOS）または `androidInfo.id`（Android）を取得して保存する。`identifierForVendor` が null の場合は UUID を生成（シミュレータ等での衝突防止）。

### Firestore データ構造
```
{deviceUniqueId}/          ← コレクション（Keychain 永続化されたデバイス固有ID）
  {yyyy}/                  ← ドキュメント（年）
    {MM}/                  ← サブコレクション（月 0埋め2桁）
      {dd}                 ← ドキュメント（日 0埋め2桁）
        bed_time: Timestamp
        get_up_time: Timestamp
        dysfunction: int (0–10)  ← 睡眠の主観的品質
        SOL: string              ← 入眠所要時間カテゴリ
        WASO: string             ← 中途覚醒時間カテゴリ
        NOA: int                 ← 覚醒回数
        TASAFA: string           ← 起床所要時間カテゴリ
```
`tips` コレクションにランダム表示する睡眠チャレンジTipsが格納されている（doc ID: "0", "1"）。

### i18n
テンプレートは `lib/l10n/app_ja.arb`（日本語）。`lib/l10n/` に en/ko/tw もある。`l10n.yaml` で `output-dir: lib/gen_l10n` を指定。`flutter gen-l10n` で `lib/gen_l10n/app_localizations.dart` が生成される（`.gitignore` 対象）。各ファイルからは相対パスでインポートする（例: `../gen_l10n/app_localizations.dart`）。

### Material デザイン
`main.dart` で `useMaterial3: false` を明示指定し、Material 2 の外観を維持している（Flutter 3.16 以降 Material 3 がデフォルトになったため）。

### iOS デプロイターゲット
`ios/Podfile` および `ios/Runner.xcodeproj/project.pbxproj` のすべてのターゲットで `15.0` に統一済み（`cloud_firestore` v6 が iOS 15 以上を要求するため）。

### CI/CD（Xcode Cloud）
`ios/ci_scripts/ci_post_clone.sh` が `.fvmrc` の Flutter バージョンを読んで git clone、`pod install`、Firebase 設定ファイルの注入（base64環境変数: `FIREBASE_OPTIONS`、`FIREBASE_APP_ID`）を行う。`ci_post_xcodebuild.sh` でアーカイブ時に Crashlytics へ dSYM をアップロード。

## 既知の問題・要対応事項

### 優先度：中

1. **カレンダーの表示範囲が狭い**
   - `kFirstDay` が「今月の1ヶ月前」のみ。`getEvents` も直近2ヶ月しか取得しない

2. **`pdf_utils.dart` が未完成**
   - 値がハードコードのスタブ状態。`Print` タブは CSV エクスポートのみ動作しており PDF 機能は未接続

3. **`about_me.dart`（使い方ページ）がスタブ**
   - `help.dart` でコメントアウトされており実質未実装

4. **`getEvents()` の重複実装**
   - `base.dart`、`home.dart`、`calendar.dart` に同一コードが3箇所存在

5. **ユーザーが自身のデバイスIDを確認できるページがない**
   - サポート対応や将来のデータ移行のために必要になる可能性がある

### Firebase 設定
`lib/firebase_options.dart` と `ios/firebase_app_id_file.json` はリポジトリ管理外（`.gitignore` 対象）。CI では base64 環境変数から注入される。ローカルでは `flutterfire configure --project=<project_id>` で生成する。
