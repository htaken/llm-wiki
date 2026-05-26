---
title: I3D
type: entity
created: 2026-04-11
updated: 2026-04-13
tags: [深層学習, CNN, 動画認識, アーキテクチャ]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md, 1-s2.0-S0039606025009316-main.md]
aliases: [Inflated 3D ConvNet]
---

# I3D (Inflated 3D ConvNet)

Inceptionモデルの畳み込みフィルタ、プーリング操作、特徴マップを3次元（時間軸を追加）に「膨張（inflate）」させたCNNベースの動画認識モデル。連続フレームのスタックから時間的情報を学習する。

## アーキテクチャ

### Inflation（膨張）の概念

2D画像認識で成功したInception（GoogLeNet）の構造をそのまま3次元に拡張する:

- 2D Inception: `k×k` の畳み込みフィルタ → 空間パターンを認識
- I3D: `k×k×k` の畳み込みフィルタ → 時空間パターンを認識（H × W × T の3次元）

プーリング操作や特徴マップも同様に3次元化される。

### 重みの初期化

2D Inceptionの事前学習済み重みを3次元に再利用できる。2Dフィルタ（k×k）をT方向にコピーし、Tで割ることで初期化する。これにより、画像認識の知識を動画認識にブートストラップできる。

### 特性

- **受容野**: 畳み込みカーネルサイズで決まる局所的な範囲。層を深くすることで間接的に広い時間範囲をカバーする
- **帰納バイアス**: 局所性（近くのフレーム/ピクセルが関連しやすい）と平行移動等価性を持つ。少ないデータでも効率的に学習できる
- **計算効率**: [[entities/Video Swin Transformer]]と比較してGPUメモリ使用量が大幅に少ない

## AIxSuture での使用

[[sources/AIxSuture]]において、[[entities/Temporal Segment Network]]のバックボーンとして使用された。Kinetics400で事前学習済み。訓練時は最後の3層のみを解凍。

| 構成 | テストF1 | テスト精度 |
|------|----------|-----------|
| 64snippets, 12seg | 0.692 ± 0.029 | **0.746 ± 0.063** |
| 64snippets, 10seg | 0.647 ± 0.028 | 0.674 ± 0 |
| 75snippets, 10seg | 0.629 ± 0.023 | 0.645 ± 0.013 |

精度では最良構成が[[entities/Video Swin Transformer]] Tinyを上回るが、F1スコアではやや劣る。GPUメモリ使用量がVideo Swin Tinyより大幅に少ないため、メモリ制約がある場合の選択肢として推奨されている。

## 比較ベースラインとしての利用

[[sources/開放手術スキルの時空間特徴ML評価]]（Alipour et al. 2026）は、上記のAIxSuture報告値（マクロF1 0.6917、Novice 0.857 / Intermediate 0.403 / Proficient 0.752）を比較ベースラインに採用し、自前の[[entities/CNN-LSTMハイブリッドモデル]]（マクロF1 0.82）がI3Dを全スキルレベルで上回ったと主張している。特に intermediate での差（0.63 vs 0.40）が大きい。

## 関連ページ

- [[entities/Video Swin Transformer]]
- [[entities/Temporal Segment Network]]
- [[entities/ResNet50]]
- [[entities/CNN-LSTMハイブリッドモデル]]
- [[concepts/転移学習]]
- [[sources/AIxSuture]]
- [[sources/開放手術スキルの時空間特徴ML評価]]
