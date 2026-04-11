---
title: I3D
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [深層学習, CNN, 動画認識, アーキテクチャ]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [Inflated 3D ConvNet]
---

# I3D (Inflated 3D ConvNet)

Inceptionモデルの畳み込みフィルタ、プーリング操作、特徴マップを3次元（時間軸を追加）に拡張したCNNベースの動画認識モデル。連続フレームのスタックから時間的情報を学習する。

## AIxSuture での使用

[[sources/AIxSuture]]において、[[entities/Temporal Segment Network]]のバックボーンとして使用された。Kinetics400で事前学習済み。訓練時は最後の3層のみを解凍。

| 構成 | テストF1 | テスト精度 |
|------|----------|-----------|
| 64snippets, 12seg | 0.692 ± 0.029 | **0.746 ± 0.063** |
| 64snippets, 10seg | 0.647 ± 0.028 | 0.674 ± 0 |
| 75snippets, 10seg | 0.629 ± 0.023 | 0.645 ± 0.013 |

精度では最良構成が[[entities/Video Swin Transformer]] Tinyを上回るが、F1スコアではやや劣る。GPUメモリ使用量がVideo Swin Tinyより大幅に少ないため、メモリ制約がある場合の選択肢として推奨されている。

## 関連ページ

- [[entities/Video Swin Transformer]]
- [[entities/Temporal Segment Network]]
- [[sources/AIxSuture]]
