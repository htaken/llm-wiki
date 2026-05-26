---
title: SAPIEN
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [シミュレータ, レンダラ, 合成データ, コンピュータビジョン]
sources: [2603.25726v2.md]
aliases: []
---

# SAPIEN

**S**imulated **P**art-based **I**nteractive **EN**vironment。Xiang et al.（CVPR 2020）による、部品ベースのインタラクティブシミュレーション環境 [66]。UCSD の Hao Su らのグループが開発しており、AnyHand 論文の著者陣と同系統。

## AnyHand での役割

[[entities/AnyHand データセット]] の全シーンは SAPIEN の**レイトレーシングレンダラ**でレンダリングされる。これにより:
- リアルなシェーディング、cast shadow、スペキュラ効果を再現
- 前景（手・前腕）の正確な metric depth をレンダリング可能（背景深度は MoGe-2 で推定して融合）

テクスチャ付き手メッシュ（[[entities/MANO]] + Handy テクスチャ）と前腕メッシュ（SMPLitex テクスチャ）を 3D 空間で合成し、背景認識ライティングでレンダリングするパイプラインの基盤。

## 関連

- [[entities/AnyHand データセット]] — SAPIEN でレンダリングされる合成データ
- [[sources/AnyHand]]
