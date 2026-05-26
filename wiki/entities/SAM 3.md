---
title: SAM 3
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [モデル, セグメンテーション, オープン語彙, 物体検出, 物体追跡, 動画, DETR, 基盤モデル, Meta]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [Segment Anything Model 3, Segment Anything with Concepts]
---

# SAM 3

Meta Superintelligence Labs が開発した、**コンセプトプロンプト**で画像・動画中の物体を検出・セグメント・追跡する統合モデル（約850Mパラメータ）。SAM・[[entities/SAM 2]] の系譜に連なり、新タスク **[[concepts/Promptable Concept Segmentation]]（PCS）** を解く。原論文は [[sources/SAM 3]]。

## 概要

- **入力プロンプト**: 短い名詞句（NP, 例「yellow school bus」）、画像exemplar（正/負のbbox）、それらの組み合わせ。加えて従来の PVS 用の点/ボックス/マスクも受け付ける。
- **出力**: 概念に一致する**全インスタンス**のマスク（＋bbox、semantic mask）と、動画では時間を越えた固有ID。
- **対話性**: exemplar や PVS クリックで個別マスクを反復修正できる。
- 既存システムの画像・動画 PCS 精度を**約2倍**にし、PVS でも [[entities/SAM 2]] を上回る。
- **公開**: チェックポイント・推論コード（[github.com/facebookresearch/sam3](https://github.com/facebookresearch/sam3)）と SA-Co ベンチマークをオープンソース化。

## アーキテクチャ

[[entities/Perception Encoder]]（PE）バックボーンを検出器とトラッカーで**共有**するデュアル encoder-decoder Transformer。

| 構成要素 | パラメータ規模 | 役割 |
|---|---|---|
| Vision encoder（PE） | 約450M | 画像/フレームの符号化（windowed + global attention、RoPE） |
| Text encoder（PE） | 約300M | 名詞句の符号化（causal、最大コンテキスト32） |
| 検出器＋トラッカー | 約100M | DETR風検出 ＋ SAM 2風追跡 |

### 検出器（[[entities/DETR]]ベース）
- PEで画像・テキストを符号化、画像exemplarは exemplar encoder で符号化（位置・ラベル・ROI-pooled特徴）。
- **fusion encoder**（6ブロック）が無条件フレーム埋め込みを prompt tokens で条件付け。
- **デコーダ**（6ブロック、デフォルト Q=200 object queries）が条件付き埋め込みに cross-attention。各層で分類ロジット（プロンプト一致の2値）とボックス delta を予測。
- 強力なDETR変種の手法を採用: iterative box refinement、look-forward-twice、hybrid matching、DAC-DETR の dual supervision、Align loss、box-to-pixel relative position bias。
- mask head は MaskFormer 由来。semantic segmentation head も併設。

### Presence Token（認識と位置特定の分離）
- 各 object query に「認識（what）」と「位置特定（where）」を同時に課すと、グローバル文脈を要する認識とローカルな位置特定が競合する。
- 学習された **presence token** が `p(名詞句が画像に存在)` のみを担当し、各 object query は `p(query一致 | 概念が存在)` のみ担当。
- 最終スコア = presence スコア × object スコア。これにより画像レベル認識（IL_MCC）が向上（アブレーションで cgF1 +1.5）。

### トラッカー（[[entities/SAM 2]] 継承）
- SAM 2 の prompt encoder・mask decoder・memory encoder・memory bank を継承。バックボーンは検出器と共有。
- 各フレームで検出器が新物体 O_t を検出、トラッカーが前フレームのマスクレット M_{t-1} を伝播 → IoU マッチングで統合。
- **時間的曖昧性解消**: masklet detection score が閾値を下回れば抑制、高信頼検出マスクで定期的に re-prompt。

## 学習（4ステージ）

1. **PE 事前学習**（5.4B image-text対のコントラスティブ学習）
2. **検出器 事前学習**
3. **検出器 fine-tuning**（presence post-training を含む）
4. バックボーン凍結で**トラッカー学習**（SAM 2 流）

学習データは [[concepts/データエンジン]] で構築した [[entities/SA-Co]]（HQ/SYN/EXT/VIDEO）。

## 性能ハイライト

- **LVIS** zero-shot マスク AP **48.8**（従来最高 38.5）。
- **SA-Co/Gold** cgF1 **54.0**（人間性能の約74%、最強ベースラインの2倍超）。
- **VOS** で SAM 2 超え（MOSEv2 で +6.5）。
- **SAM 3 Agent**（MLLM併用）が ReasonSeg / OmniLabel / RefCOCO+ で zero-shot SOTA。
- H200 1枚で 100+物体の単一画像を **30ms**。動画は約5物体まで準リアルタイム。

## 限界

細粒度・ドメイン外概念への zero-shot 汎化が弱い／単純名詞句に制約（複雑クエリは MLLM併用）／動画推論コストが物体数に線形。詳細は [[sources/SAM 3]] §B。

## 関連

- [[sources/SAM 3]] — 原論文
- [[entities/SAM 2]] — 前身。トラッカー・PVS能力を継承
- [[entities/Perception Encoder]] — 共有バックボーン
- [[entities/DETR]] — 検出器の基盤
- [[entities/SA-Co]] — 学習・評価データ
- [[concepts/Promptable Concept Segmentation]] — 解くタスク
- [[concepts/データエンジン]] — 学習データ構築の仕組み
- [[concepts/インスタンスセグメンテーション]] — 下流タスクの一つ
