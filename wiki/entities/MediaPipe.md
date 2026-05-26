---
title: MediaPipe
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [MediaPipe, オンデバイスML, エッジAI, Google, コンピュータビジョン, クロスプラットフォーム, ライブラリ]
sources: ["MediaPipe ソリューション ガイド    Google AI Edge.md", 2409.12259v2.md]
aliases: [MediaPipe Solutions, MediaPipe Tasks]
---

# MediaPipe

Google が提供する**オンデバイス AI/ML のためのソリューションスイート**（Google AI Edge の一部）。事前トレーニング済みモデルとクロスプラットフォーム API を束ね、Android / Web / Python / iOS のアプリに視覚・テキスト・音声・生成 AI 機能を即組み込めるようにする。オープンソースプロジェクト（[github.com/google/mediapipe](https://github.com/google/mediapipe)）として公開され、ソリューションコードのカスタマイズも可能。

## 構成要素

| 要素 | 役割 |
|---|---|
| **MediaPipe Tasks** | ソリューションをデプロイするクロスプラットフォーム API・ライブラリ。アプリ統合の中核 |
| **MediaPipe モデル** | 各ソリューション向けの事前トレーニング済み・即実行可能モデル |
| **MediaPipe Model Maker** | 自前データによるモデルのカスタマイズ（一種の[[concepts/転移学習]]）。一部ソリューションのみ対応 |
| **MediaPipe Studio** | ブラウザ上でソリューションを可視化・評価・ベンチマーク |

## 提供ソリューション（抜粋）

- **ビジョン**: オブジェクト検出、画像分類、画像セグメンテーション、インタラクティブセグメンテーション、**手のランドマーク検出**、ジェスチャー認識、画像エンベディング、顔検出、顔のランドマーク検出、**ポーズのランドマーク検出**、画像生成
- **テキスト**: テキスト分類、テキストエンベディング、言語検出
- **音声**: 音声分類
- **生成 AI**: LLM Inference API

プラットフォーム別の詳細な対応表は[[sources/MediaPipe ソリューション ガイド]]を参照。Model Maker でカスタマイズできるのは検出・分類・生成系の一部に限られる。

## 沿革（レガシーからの再編）

MediaPipe には旧来の「Legacy Solutions」があり、2023-03-01 に一部のサポートを終了。主要なものは新ソリューションへアップグレードされた:

- **Hands（手）** → 手のランドマーク検出
- **Pose（ポーズ）** → ポーズのランドマーク検出
- **Face Mesh / Iris** → 顔のランドマーク検出
- **Holistic（総合的）** → ホリスティックランドマーク検出
- **セルフィー/髪セグメンテーション** → 画像セグメンテーション

Objectron・KNIFT・AutoFlip 等はサポート終了（移行先なし、コードは現状提供）。

## 手姿勢推定研究での位置づけ

MediaPipe の手のランドマーク検出は、軽量・即デプロイ可能なオンデバイス手検出/ランドマークソリューションとして広く使われてきた。一方、研究領域の in-the-wild マルチハンド検出ベンチマークでは限界が指摘される:

- [[sources/WiLoR]] の手検出比較（Table 1, RTX 4090）では MediaPipe は **25Mb / 25 FPS**、mAP は COCO-WholeBody 3.72 / Oxford 1.80 / WHIM 12.01 と低く、複数手・難ポーズの検出に失敗しやすい
- 同論文の WiLoR Proposed-M（25Mb / 138 FPS、WHIM mAP 53.79）と比べ、**速度・精度ともに大きく劣る**

つまり MediaPipe は「手軽さ・マルチプラットフォーム・実用性」で優れる一方、堅牢な in-the-wild 検出精度では[[concepts/手検出・ローカライゼーション|専用研究手法]]に及ばない、という住み分けになっている。

## 関連

- [[sources/MediaPipe ソリューション ガイド]] — 本エンティティの一次ソース（全ソリューション一覧・対応表）
- [[concepts/手検出・ローカライゼーション]] — MediaPipe の手検出が軽量ベースラインとして参照される
- [[concepts/3D手姿勢推定]] — 手のランドマーク検出が関連する研究タスク
- [[sources/WiLoR]] / [[entities/WiLoR]] — MediaPipe の手検出をベンチマークした研究
- [[concepts/転移学習]] — Model Maker によるモデルカスタマイズの基盤
