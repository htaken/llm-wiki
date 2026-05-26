---
title: Perception Encoder
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [モデル, Vision Transformer, 視覚言語, バックボーン, コントラスティブ学習, Meta]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [PE, Perception Encoder (PE)]
---

# Perception Encoder

Meta（Bolya et al., 2025）の**視覚言語バックボーン**。画像エンコーダとテキストエンコーダを整合（aligned）させたコントラスティブ学習ベースの Transformer で、[[entities/SAM 3]] の共有バックボーンとして採用された。本Wikiでは主に [[sources/SAM 3]] での利用文脈から記述する。

## SAM 3 における役割

- **整合した画像・テキストエンコーダ**を提供し、検出器とトラッカーが共有する。SAM 3 の vision encoder 約450M ＋ text encoder 約300M を占める。
- **5.4B image-text対**でコントラスティブ視覚言語学習（SAM 3 の学習ステージ1）。
- 画像エンコーダ: windowed attention＋一部層のみ global attention（32層中4層）。1008pxを 3×3 の336pxウィンドウに分割。各層で **RoPE**＋windowed絶対位置埋め込み。
- テキストエンコーダ: causal、最大コンテキスト長32。

## なぜ PE か（[[sources/SAM 3]] §A.1 のエンコーダ比較）

SAM 2 は幾何的な PVS 向けに MAE事前学習の Hiera を用いたが、SAM 3 は**意味的・言語的理解と広い概念カバレッジ**を要する。エンコーダ比較（SA-Co/Gold cgF1 / COCO-O AP）:

| エンコーダ | SA-Co/Gold cgF1 | COCO-O AP |
|---|---|---|
| **PE-L+ (14)** | **43.2** | **42.5** |
| PE-L+ (14) ＋ DistilRoBERTa | 38.1 | 39.6 |
| DINOv2-L (14) | 35.3 | 31.9 |
| Hiera-L (16) | 32.8 | 22.0 |

PE が最良で、**PE自身の整合テキストエンコーダ**を使うことで非整合ベースラインよりさらに改善。COCO-O での高 AP は sketch / cartoon / painting 等のドメインシフトへの頑健性も示す。

## 関連

- [[sources/SAM 3]] — PE をバックボーンに採用した論文
- [[entities/SAM 3]] — PE を共有バックボーンとするモデル
- [[entities/SAM 2]] — 前身。Hiera バックボーンを使用していた
- [[concepts/Self-Attention]] — windowed/global attention、RoPE の機構
- [[concepts/自己教師あり学習]] — 比較対象 DINOv2 / MAE の事前学習目的
