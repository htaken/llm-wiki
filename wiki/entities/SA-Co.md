---
title: SA-Co
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [データセット, ベンチマーク, オープン語彙, セグメンテーション, 動画, データエンジン, Meta]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [Segment Anything with Concepts dataset, SA-Co benchmark, SA-Co/HQ, SA-Co/SYN]
---

# SA-Co

**Segment Anything with Concepts** データセット・ベンチマーク。[[entities/SAM 3]] の学習と評価のために [[concepts/データエンジン]] で構築された、オープン語彙の概念セグメンテーション用大規模リソース。原論文は [[sources/SAM 3]]。既存ベンチマーク比 **>50× の概念数**（>100× とする箇所もある）。

## 学習データ

| サブセット | 規模 | 説明 |
|---|---|---|
| **SA-Co/HQ** | 5.2M画像 / 4M ユニーク NP / 52Mマスク | データエンジン Phase 1-4 で集めた高品質画像データ。**最大の高品質オープン語彙セグメンテーションデータ** |
| **SA-Co/SYN** | 38M NP / 1.4Bマスク | 成熟したデータエンジン（Phase 3）が人手なしでラベル付けした合成データ |
| **SA-Co/EXT** | 15外部データ | 既存のインスタンスマスク注釈データに、オントロジーパイプラインで hard negative を付与 |
| **SA-Co/VIDEO** | 52.5K動画 / 24.8K NP / 134K video-NP対 / 467Kマスクレット | 動画データ。平均84.1フレーム @ 6fps |

## 評価ベンチマーク

- 規模: **207K ユニーク名詞句**、121K 画像・動画、3M+ media-phrase対（hard negative ラベル付きでオープン語彙認識を試す）。
- 分割:
  - **SA-Co/Gold**: 7ドメイン、各 image-NP 対を **3人**が注釈（人間性能の測定に使用）。
  - **SA-Co/Silver**: 10ドメイン、1注釈/対。
  - **SA-Co/Bronze** / **SA-Co/Bio**: 既存9データセット（既存マスク or ボックスを SAM 2 にプロンプトして生成）。
  - **SA-Co/VEval**: 動画用3ドメイン（SA-V / YT-Temporal-1B / SmartGlasses）、1注釈/video-NP対。

## SA-Co オントロジー

- **22.4M ノード**のオントロジー（Wikidata 由来、17トップレベルカテゴリ・72サブカテゴリ）。
- 長尾・細粒度概念の採掘、hard negative の生成、ドメイン拡張に使用。

## 評価指標

主指標は **cgF1（classification-gated F1）= 100 × pmF1 × IL_MCC**:
- **pmF1**（positive micro F1）: localization の質。少なくとも1つのGTマスクを持つ正例で評価。
- **IL_MCC**（image-level Matthews Correlation Coefficient, [−1,1]）: classification（「物体は存在するか」）をマスク品質と無関係に画像レベルで評価。
- 信頼度0.5未満の予測を除外し、downstream 利用を模したキャリブレーションを強制。
- 動画では **pHOTA** も使用。曖昧性対応として SA-Co/Gold は3注釈で oracle 評価（最良スコアを採用）。

## 役割・知見

- SA-Co/EXT 単体でも既存最良モデル（OWLv2, DINO-X）並み。SYN を足して +8.8 cgF1、さらに HQ で +14.6 cgF1（[[sources/SAM 3]] Tab. 9c）。
- SYN と HQ は同様のスケーリング則を示し、**合成データのみで人手なしのドメイン適応**が可能であることを示した。

## 関連

- [[sources/SAM 3]] — 原論文
- [[entities/SAM 3]] — このデータで学習・評価されるモデル
- [[concepts/データエンジン]] — SA-Co を生成した仕組み
- [[entities/SAM 2]] — Bronze/Bio のマスク生成に使用
