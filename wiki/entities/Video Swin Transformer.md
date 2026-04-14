---
title: Video Swin Transformer
type: entity
created: 2026-04-11
updated: 2026-04-13
tags: [深層学習, Transformer, 動画認識, アーキテクチャ]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [Video Swin, Swin Transformer (Video)]
---

# Video Swin Transformer

Vision Transformer（ViT）を動画に拡張したモデル。Liu et al. (2021) によって提案された。Swin Transformerの局所シフトウィンドウ機構を空間ドメインから時空間ドメインに拡張し、動画中の時間的・空間的な長距離依存関係を効率的に捕捉する。

## アーキテクチャ

### [[concepts/Self-Attention]]との関係

ViTは画像パッチ間のグローバルな[[concepts/Self-Attention]]で長距離依存関係を捕捉するが、計算量がO(N²)と大きい。Video Swinはこれを**局所ウィンドウ内のAttention**に制限し、ウィンドウ間の情報伝播を**シフト機構**で実現する。

### シフトウィンドウ機構

時空間パッチを固定サイズのウィンドウ（T'×H'×W'）に分割し、ウィンドウ内でSelf-Attentionを計算する:

- **偶数層**: 固定位置のウィンドウ内でAttention
- **奇数層**: ウィンドウを時間・空間方向に半分シフトしてAttention

シフトにより、隣接ウィンドウ間の情報交換が可能になり、局所Attentionでもグローバルな情報を層を重ねるごとに伝播できる。計算量はO(N²)からO(N)に削減される。

このシフトウィンドウはCNNの局所性バイアスとTransformerのグローバルAttentionの折衷案として機能し、小規模データセットでも効果的に学習できる要因となっている。

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
- [[concepts/Self-Attention]]
- [[concepts/転移学習]]
- [[sources/AIxSuture]]
