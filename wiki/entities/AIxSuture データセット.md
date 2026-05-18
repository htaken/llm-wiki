---
title: AIxSuture データセット
type: entity
created: 2026-04-11
updated: 2026-05-18
tags: [データセット, 外科技術評価, 開放手術, 縫合]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [AIxSuture, AIxSuture dataset]
---

# AIxSuture データセット

開放手術の縫合訓練を記録した動画データセット。[[concepts/外科技術自動評価]]のための初の大規模開放手術動画コーパスとして公開されている。

## 概要

| 項目 | 内容 |
|------|------|
| 動画数 | 314本 |
| 動画長 | 各約5分 |
| フレームレート | 30fps |
| 総データ量 | 約100GB |
| カメラ | GoPro Hero 5（鳥瞰固定、カメラ移動なし） |
| モダリティ | RGB動画のみ（センサー・深度・音声なし） |
| 収集場所 | University Hospital RWTH Aachen |
| 公開先 | https://zenodo.org/record/7940583 |

## データ収集

VR HMD（ヘッドマウントディスプレイ）訓練の効果を調査する研究の一環として収集された。医学生・歯学生がシミュレーション環境で開放手術の縫合を実施し、各参加者について訓練前・訓練後の2本の動画が撮影された。

## 取得情報の範囲

本データセットは "video-only" を設計上の特徴とし、追加センサー類は意図的に含めていない。これは[[concepts/外科技術自動評価]]における motion-based 手法（器具追跡・力/トルク・キネマティクス等）との明確な対比点であり、追加ハードウェア不要であることが臨床導入容易性の根拠となっている。

含まれるもの:
- RGB動画ファイル
- 学生ID・動画ID・訓練前後フラグ（Excelスプレッドシートで管理）
- 3評価者によるOSATS 8カテゴリのスコアおよびGRS

含まれないもの:
- 器具トラッキング・ハンドキーポイント等のアノテーション
- 力・トルク・触覚センサー
- ロボットキネマティクス、アイトラッキング
- フェーズ/動作セグメンテーション等の時間アノテーション

## モデル入力時の前処理

論文ベンチマークでは以下の前処理が用いられている:
- 30 fps → **5 fps にダウンサンプル**してフレーム抽出
- 解像度を **270×480 ピクセル**にリサイズ
- リサイズ以外のハンドクラフト特徴抽出は行わない

## アノテーション

- 3名の独立した評価者が[[entities/OSATS]]（8カテゴリ）で評価
- 評価者間の平均Pearson相関係数 > 0.8（優れた一致度）
- Global Rating Score（GRS）: 8〜40点の範囲
- 3クラスに分類:
  - **Novice**: GRS < 16
  - **Intermediate**: 16 ≤ GRS < 24
  - **Proficient**: GRS ≥ 24

## データ分割

- 訓練70% / 検証15% / テスト15%
- 同一学生の訓練前後動画は同じ分割に配置（データリーク防止）
- Novice・Proficient各30〜40%、Intermediate 20〜30%（やや不均衡）

## ベンチマーク結果

[[sources/AIxSuture]]で報告されたベンチマークでは、[[entities/Temporal Segment Network]] + [[entities/Video Swin Transformer]]（Tiny）が最良のF1スコア72%、精度75%を達成した。

## 制限事項

- 訓練前後の設計上、intermediate・expert（GRS > 32）レベルのデータが少ない
- より均質な分布を得るには追加収録が必要
