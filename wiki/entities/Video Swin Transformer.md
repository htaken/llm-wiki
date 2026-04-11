---
title: Video Swin Transformer
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [深層学習, Transformer, 動画認識, アーキテクチャ]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [Video Swin, Swin Transformer (Video)]
---

# Video Swin Transformer

Vision Transformer（ViT）を動画に拡張したモデル。Liu et al. (2021) によって提案された。Swin Transformerの局所シフトウィンドウ機構を空間ドメインから時空間ドメインに拡張し、動画中の時間的・空間的な長距離依存関係を効率的に捕捉する。

## バリエーション

- **Tiny**: パラメータ数が少なく、訓練可能パラメータの割合が高い（51.34%）
- **Small**: 中規模
- **Big**: 大規模だが、ハードウェア制約下では訓練可能パラメータ比率が30%未満に制限される

## AIxSuture での結果

[[sources/AIxSuture]]において、[[entities/Temporal Segment Network]]のバックボーンとして使用された。

| モデル | テストF1 | テスト精度 |
|--------|----------|-----------|
| Tiny | **0.716** | 0.732 |
| Small | 0.631 | 0.659 |
| Big | 0.636 | 0.652 |

Tinyが最良性能を達成。これはハードウェア制約によりSmall/Bigでは訓練可能層が限定され、過学習が発生したためと推測されている。Kinetics400で事前学習済み。

## 関連ページ

- [[entities/I3D]]
- [[entities/Temporal Segment Network]]
- [[sources/AIxSuture]]
