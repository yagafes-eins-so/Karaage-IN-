# からあげ in!

大学文化祭向けミニゲーム。ヤガあげクンを操作して、左右に動く紙コップへ
唐揚げを投げ入れる、1プレイ約30秒のカジュアルゲーム。

Flutter + Flame で実装。MVVM構成:

- **Model** (`lib/models/`): `ThrowResult` / `GameResult` / `Rank` — 純粋なデータ
- **ViewModel** (`lib/viewmodels/`): `GameViewModel` — スコア計算・状態遷移の唯一のソース
- **View**:
  - Flutter Widget側 (`lib/overlays/`, `lib/widgets/`) — タイトル/HUD/リザルト
  - Flame Component側 (`lib/game/`) — ゲーム世界の描画・入力・物理

## セットアップ

```bash
flutter pub get
```

`assets/images/` `assets/audio/` にアセットが無くても、各コンポーネントが
フォールバック描画(単色図形)をするため、そのままロジック確認ができます。
本番アセットの仕様は `assets/ASSETS_README.md` を参照してください。

## 実行

```bash
# Chrome等ブラウザで起動(スマホ幅のデバッグは Chrome DevTools のデバイスモードで確認)
flutter run -d chrome

# 実機/エミュレータ
flutter run
```

## テスト

物理計算(`ProjectilePhysics`)とスコア計算(`GameViewModel`)は
Flutter/Flameの描画に依存しない純粋ロジックとして分離してあるため、
ウィジェットテストなしで高速にユニットテストできます。

```bash
flutter test
```

## Web (GitHub Pages) へのデプロイ

### 手動デプロイ

```bash
# リポジトリ名が例えば `karaage-in` の場合
flutter build web --base-href "/karaage-in/" --release

# build/web の中身を gh-pages ブランチ、または /docs に配置して push
```

### GitHub Actions での自動デプロイ

`.github/workflows/deploy.yml` を同梱しています。`main` ブランチへの push で
自動的に `flutter build web` → GitHub Pages へ公開します。
リポジトリの Settings → Pages → Source を「GitHub Actions」に設定してください。
ワークフロー内の `base-href` は自分のリポジトリ名に合わせて書き換えてください。

## 難易度について

`lib/core/difficulty.dart` の `Difficulty.forSession` が、
プレイ回数(セッション数)に応じて Easy → Normal → Hard とカップの移動速度・
可動範囲を自動で引き上げます。バランス調整はこのファイルと
`lib/core/constants.dart` の2箇所に集約されています。

## 主な調整ポイント早見表

| 調整したいこと | 触るファイル |
|---|---|
| 重力・投球パワー・スコア配点 | `lib/core/constants.dart` |
| 難易度カーブ(速度・可動域) | `lib/core/difficulty.dart` |
| ランクのスコア境界 | `lib/models/rank.dart` |
| カップ中央判定の許容幅 | `GameConfig.cupCenterToleranceRatio` (constants.dart) |
| キャラクター/カップ/背景の見た目 | `lib/game/components/*.dart` の `render()` (アセット未配置時のフォールバック) |
