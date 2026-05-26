---
title: DETR
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [モデル, 物体検出, Transformer, アーキテクチャ, コンピュータビジョン, 深層学習]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [DEtection TRansformer, MDETR]
---

# DETR

**DEtection TRansformer**（Carion et al., 2020）。物体検出を**集合予測問題**として定式化し、学習可能な **object query** と二部マッチング（Hungarian matching）で、NMS や anchor などの手作り要素なしに end-to-end で検出を行う Transformer アーキテクチャ。[[entities/SAM 3]] の検出器の基盤。本Wikiでは主に [[sources/SAM 3]] の文脈から記述する。

## 基本アイデア

- encoder-decoder Transformer。デコーダの **object query** が画像特徴に cross-attention し、各 query が1つの物体（or 「物体なし」）を予測。
- 予測集合とGT集合を二部マッチングで対応付け、集合ベースの損失で学習。

## 派生・SAM 3 が採用する変種

- **MDETR**（Kamath et al., 2021）: 生のテキストクエリで条件付け。閉集合に限られる素のDETRを**オープン語彙／phrase grounding**へ拡張。SAM 3 の text 条件付き検出はこの系譜。
- SAM 3 の検出器は素のDETRに加え、強力なDETR変種の手法を組み合わせる:
  - **iterative box refinement**（Zhu et al., 2020 / Deformable DETR）
  - **look-forward-twice**（Zhang et al., 2022a / DINO）
  - **hybrid matching**（Jia et al., 2022 / H-DETR）
  - **DAC-DETR** の dual supervision（Hu et al., 2023）
  - **Align loss**（Cai et al., 2024）
  - **box-to-pixel relative position bias**（Lin et al., 2023）
- ただし最近のDETRと異なり **vanilla attention** を採用。デフォルト object query 数 Q=200。

## SAM 3 での位置づけ

SAM 3 の検出器は「DETR パラダイムに従う」と明記され、PE で符号化した画像・テキスト・exemplar を fusion encoder で融合し、DETR風デコーダで全インスタンスを予測する。[[concepts/Promptable Concept Segmentation]] における「概念に一致する全インスタンス検出」を、object query の集合予測として実現している。

## 関連

- [[sources/SAM 3]] — DETR を検出器基盤に用いた論文
- [[entities/SAM 3]] — DETR ベースの検出器を持つモデル
- [[concepts/Self-Attention]] — Transformer の中核機構
- [[concepts/インスタンスセグメンテーション]] — DETR系が解く検出・セグメンテーションタスク
