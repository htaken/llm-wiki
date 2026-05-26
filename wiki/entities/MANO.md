---
title: MANO
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, パラメトリックモデル, 3Dメッシュ]
sources: [2409.12259v2.md, 2603.25726v2.md]
aliases: [MANO hand model]
---

# MANO

**M**odeling **a**nd capturing **h**ands a**n**d b**o**dies together。Romero et al.（SIGGRAPH Asia 2017）による**手のパラメトリックモデル** [56]。手の形状（shape）とポーズ（pose）を低次元のパラメータで表現する。

## 役割

3D 手姿勢推定（[[concepts/3D手姿勢推定]]）における事実上の標準表現。多くの近年手法は単一画像から MANO パラメータを回帰することで手メッシュを復元する。

- **β（shape パラメータ）**: 個体差（手の大きさ・指の太さ等）を表す
- **pose パラメータ**: 関節の articulation を表す

身体モデル SMPL / SMPL+H ファミリ [39, 49] の手部分に相当し、前腕メッシュは SMPL/SMPL+H から抽出して MANO 手首フレームに整列させられる。

## AnyHand での利用

[[entities/AnyHand データセット]] のレンダリングは MANO を基盤とする:
- 手形状: 47,438 個の MANO β を FreiHAND + InterHand2.6M の経験分布からサンプリング
- 手ポーズ: DPoser-Hand 拡散事前分布からサンプルした MANO ポーズ
- アノテーション: 各サンプルに正確な 3D MANO ポーズ・形状パラメータを格納

[[entities/HaMeR]]・[[entities/WiLoR]] はいずれも MANO のポーズ・形状を直接回帰する（WiLoR は 96 次元 = 15 関節 + 1 グローバルの 6D 回転表現 + 10 形状）。なお関連先行研究 Zhao et al. [75] は NIMBLE [33] という骨・筋肉を持つ非剛体手モデルを MANO アノテーションにフィットさせて合成ポーズを生成する。

## WHIM の自動アノテーションでの利用

[[sources/WiLoR]] は [[entities/WHIM データセット]] の 3D アノテーションを、2D ランドマークへの MANO フィッティングで生成する。再投影損失に加え、骨長・関節角を可動域に拘束する**生体力学制約**（Spurr et al.）と ARCTIC 由来の **PCA 事前分布**を併用し、手の高自由度ゆえの不自然なポーズを抑制する。

## 関連

- [[entities/AnyHand データセット]] / [[entities/HaMeR]] / [[entities/WiLoR]]
- [[concepts/3D手姿勢推定]]
