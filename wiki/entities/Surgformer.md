---
title: Surgformer
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [動画認識, Transformer, 外科, フェーズ認識, モデル]
sources: [2605.22200v1.md]
aliases: [Surgformer, Surgical Transformer]
---

# Surgformer

外科動画解析のための時空間動画Transformer（Yang et al., MICCAI 2024）。[[concepts/Self-Attention]]ベースの TimeSFormer を拡張し、**階層的時間アテンション（Hierarchical Temporal Attention, HTA）** と **集約空間アテンション（Aggregated Spatial Attention, ASA）** を導入した。元来は**オンラインのフェーズ認識**（動画クリップ末尾フレームのフェーズラベル予測）向けに開発された。

## OSSチャレンジでの利用

[[sources/OSS Challenge]] 2024でチーム **Syangcw**（Yang Shu, Yihui Wang, Hao Chen）が Task 1/2 に採用した。

- TimeSFormer による Kinetics-400 事前学習重みを利用、残り層はランダム初期化
- 1 fpsにリサンプル、短辺360px、訓練時はランダムスケール/クロップで224×224入力
- ランダム開始フレームから4フレームおきに48フレーム（約3分相当）をサンプリングし、class tokenからスキルスコアを予測
- 推論時は6クリップをサンプルし、スコアの最頻値（mode）を最終予測に

結果は中位。低データ域がTransformerアーキにとって不利に働いた可能性が指摘されたが、2025でチーム Jmees がSwin3D動画Transformerで改善を示したことから、**Transformerパラダイム自体が不適なのではなく、アーキ選択・訓練戦略・実装詳細が重要**と結論づけられた。

## 関連ページ

- [[sources/OSS Challenge]]
- [[concepts/Self-Attention]]
- [[entities/Video Swin Transformer]]
- [[concepts/外科技術自動評価]]
