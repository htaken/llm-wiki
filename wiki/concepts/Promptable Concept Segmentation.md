---
title: Promptable Concept Segmentation
type: concept
created: 2026-05-26
updated: 2026-05-26
tags: [セグメンテーション, オープン語彙, 物体検出, 物体追跡, 動画, タスク定義, コンピュータビジョン]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [PCS, プロンプタブルコンセプトセグメンテーション, 概念セグメンテーション]
---

# Promptable Concept Segmentation (PCS)

[[sources/SAM 3]] が定式化した視覚タスク。**コンセプトプロンプト**を入力に、画像 or 短い動画中で概念に一致する**全インスタンス**を検出・セグメント・（動画では）追跡する。

## 定義

> 画像または短い動画（≤30秒）が与えられたとき、短いテキスト句・画像exemplar・その組み合わせで指定された視覚概念の**全インスタンス**を検出・セグメント・追跡する（動画ではフレーム間で物体IDを保持）。

- **コンセプトプロンプト**: ①短い名詞句（NP, 名詞＋任意の修飾語。例「red apple」「striped cat」）、②画像exemplar（フレーム単位の正/負のbbox）、③両者の組み合わせ。
- 名詞句は画像/動画の全フレームにグローバル。exemplar は個別フレームで対話的に追加し、ターゲットマスクを反復精緻化できる。
- 出力はインスタンスマスク＋（動画では）固有ID。semantic mask や bbox も出せる。

## PVS との違い

| | PVS（[[entities/SAM 2]]） | PCS（[[entities/SAM 3]]） |
|---|---|---|
| プロンプト | 点/ボックス/マスク | 名詞句・画像exemplar（＋PVSも可） |
| 出力 | プロンプトした**1物体** | 概念に一致する**全インスタンス** |
| exemplar の意味 | その物体だけをセグメント | 同種の物体を**全て**検出（例: 1匹の犬のbbox→全ての犬） |

PVS（Promptable Visual Segmentation）は「1プロンプト＝1物体」。PCS は「概念に一致する全インスタンス」を返す点で根本的に異なる。SAM 3 は両タスクを統合的に扱う。

## 本質的な曖昧性

語彙が「視覚的に groundable な任意の単純名詞句」であるため、タスクは本質的に曖昧:
- **polysemy**（「mouse」= device か animal か）
- **主観的記述**（「cozy」「large」）
- **groundできない/文脈依存の句**（「brand identity」）
- **境界曖昧性**（「mirror」は枠を含むか）、遮蔽・ボケ。

対策として SAM 3 は ①SA-Co/Gold で**3人**のアノテーター注釈＋複数正解を許す評価、②データパイプライン/ガイドラインで曖昧性を最小化、③モデル内の ambiguity module を採る。

## 制約と拡張

- 概念は**単純な名詞句**に限定。1〜2属性を超える multi-attribute クエリや長い指示表現・推論を要するクエリは対象外。
- **MLLM併用**で複雑クエリに対応可能（"SAM 3 Agent": MLLMが NP クエリを提案し SAM 3 を vision tool として反復呼び出し）。ReasonSeg / OmniLabel 等で zero-shot SOTA。

## 評価指標

主指標 **cgF1 = 100 × pmF1 × IL_MCC**（localization の pmF1 と classification の IL_MCC を統合、信頼度0.5で閾値）。動画では pHOTA も使用。詳細は [[entities/SA-Co]]。

## 関連

- [[sources/SAM 3]] — PCS を定式化した論文
- [[entities/SAM 3]] — PCS を解くモデル
- [[entities/SAM 2]] — PVS のみを扱う前身
- [[entities/SA-Co]] — PCS 用のデータセット・ベンチマーク
- [[concepts/インスタンスセグメンテーション]] — PCS が包含する下位タスク
- [[concepts/データエンジン]] — PCS 学習データの構築
