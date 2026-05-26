---
title: AnyHandNet-D
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, RGB-D, 深度融合, モデル, クロスアテンション]
sources: [2603.25726v2.md]
aliases: []
---

# AnyHandNet-D

[[sources/AnyHand]] で提案された **RGB-D 手姿勢推定モデル**。[[entities/WiLoR]] の RGB-only パイプラインを拡張し、軽量な**深度融合モジュール**を追加して RGB-D 入力を扱えるようにしたもの。

## アーキテクチャ（Fig. 6）

1. **デュアル埋め込み分岐**: RGB と深度をそれぞれ並列のトークン列にトークン化
2. **双方向クロスアテンション**: 対応する画像パッチ間で 2 モダリティの情報を交換する軽量モジュール（[[concepts/RGB-D深度融合]]）。[[concepts/Self-Attention]] のクロスアテンションを RGB↔深度間で適用
3. 融合トークンをタスクトークンと連結し、残りの Transformer ブロック（ViT バックボーン）と refinement ヘッドへ
4. 出力を MANO デコード（[[entities/MANO]]）

融合モジュールは軽量かつ modular で、既存の ViT ベースアーキテクチャに最小限の変更で統合できるよう設計されている。

## 訓練

- **Real-only**: 実 RGB-D データセット HO-3D + DexYCB のみで訓練
- **Real + AnyHand**: 上記に [[entities/AnyHand データセット]] を加えて共訓練（RGB 実験と同じレシピ）

## 結果（HO-3D v2、単位 cm）

| 手法 | STA-MPJPE↓ | PA-MPJPE↓ |
|---|---|---|
| Keypoint-Fusion [38] | 1.87 | — |
| AnyHandNet-D (Real-only) | 1.20 | 0.891 |
| **AnyHandNet-D (Real + AnyHand)** | **1.097** | **0.814** |
| 〃 + MoGe-2 推定深度 | 1.06 | 0.793 |

- Keypoint-Fusion 比で STA-MPJPE を 1.87→1.09cm へ約 **41.7% 削減**
- Real-only 版でも既存 RGB-D 手法を上回り、融合モジュール単体の頑健性を示す
- **クロスアテンション除去**のアブレーションでは収束が悪化し誤差増大（STA 1.211）→ 融合機構の重要性を裏付け
- **欠損深度**: GT 深度を MoGe-2 推定深度で置換するとむしろ改善。GT の HO-3D 深度が量子化・欠損を含む一方、MoGe-2 は滑らかで密、かつ AnyHand の背景深度も MoGe ベースのため訓練分布に合致

## 関連

- [[entities/WiLoR]] — 基盤となる RGB-only パイプライン
- [[concepts/RGB-D深度融合]] — 融合機構の概念
- [[entities/AnyHand データセット]] — 共訓練に用いる合成 RGB-D データ
