---
title: SAM 2
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [モデル, セグメンテーション, 動画, 物体追跡, 対話的セグメンテーション, 基盤モデル, Meta]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [Segment Anything Model 2, SAM2]
---

# SAM 2

Meta（Ravi et al., 2024）の **Segment Anything Model 2**。初代 SAM（Kirillov et al., 2023）の **Promptable Visual Segmentation（PVS）** を動画に拡張し、点/ボックス/マスクのプロンプトで**1物体**を画像・動画にわたってセグメント・追跡する。[[entities/SAM 3]] の直接の前身であり、SAM 3 はそのトラッカーと PVS 能力を継承する。本Wikiでは主に [[sources/SAM 3]] の文脈から記述する。

## SAM 系譜における位置づけ

| モデル | タスク | プロンプト | 対象 |
|---|---|---|---|
| SAM (2023) | PVS | 点/ボックス/マスク（テキストは未成熟） | 画像、1物体/プロンプト |
| **SAM 2 (2024)** | PVS | 点/ボックス/マスク（任意フレームで refine 可） | 画像・**動画**、1物体/プロンプト |
| [[entities/SAM 3]] (2025) | PVS ＋ **[[concepts/Promptable Concept Segmentation\|PCS]]** | ＋名詞句・画像exemplar | 概念に一致する**全インスタンス**、ID保持 |

PVS は「1プロンプト＝1物体」。SAM 3 が導入した PCS は「概念に一致する全インスタンス」を返す点で根本的に異なる。

## アーキテクチャ要素（SAM 3 が継承する部分）

- MAE事前学習の **Hiera**（Ryali et al., 2023）vision encoder（強い localization と効率）。windowed＋global attention。
- prompt encoder、mask decoder（two-way transformer）、**memory encoder**、**memory bank**（過去フレーム・条件フレームの appearance を符号化）。
- ストリーミング方式でフレームを逐次取り込み、曖昧性対応に各物体3マスク＋信頼度を予測し最良を選択。

SAM 3 はこれらをトラッカーとして取り込み、バックボーンを PE に置き換え、検出器と共有する形に再構成した。なお SAM 3 のトラッカー学習（ステージ4）はバックボーン凍結で「SAM 2 流」に行われる。

## SAM 3 における性能比較（[[sources/SAM 3]]）

- **VOS**: SAM 3 が SAM 2.1 L を全般的に上回り、MOSEv2 で 47.9→60.3（+6.5 以上）。
- データエンジン Phase 1 では SAM 2 が初期マスク提案モデルとして使われた。SA-Co/Bronze・Bio のマスクも一部 SAM 2 で生成。

## 関連

- [[sources/SAM 3]] — SAM 2 を前身とし拡張した論文
- [[entities/SAM 3]] — 後継モデル
- [[entities/Perception Encoder]] — SAM 3 が Hiera を置き換えたバックボーン
- [[concepts/Promptable Concept Segmentation]] — SAM 3 が新たに加えたタスク（SAM 2 は PVS のみ）
- [[concepts/インスタンスセグメンテーション]] — 関連する視覚タスク
