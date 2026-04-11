---
title: Temporal Segment Network
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [深層学習, 動画認識, アーキテクチャ]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [TSN]
---

# Temporal Segment Network (TSN)

動画からの行動認識のためのフレームワーク。Wang et al. (2019) によって提案された。

## 仕組み

1. 入力動画を均等にN個の**セグメント**に分割
2. 各セグメントからランダムな位置で**スニペット**（連続フレーム群）を抽出
3. 各スニペットをバックボーンネットワーク（CNN等）で独立に評価
4. **コンセンサス層**で全スニペットの結果を平均し、動画全体の予測を生成

この設計により、動画全体の時間的構造を効率的に捕捉しつつ、GPU メモリの制約を回避できる。

## AIxSuture での使用

[[sources/AIxSuture]]では、TSNをベースアーキテクチャとして以下の2つのバックボーンと組み合わせてベンチマークが行われた:
- [[entities/I3D]]
- [[entities/Video Swin Transformer]]

スニペット長64フレーム・12セグメントの構成が最良結果を示した。短いスニペット長の方が動作の詳細を捉え、スキル評価に有利であることが示唆された。

## 関連ページ

- [[concepts/外科技術自動評価]]
- [[sources/AIxSuture]]
