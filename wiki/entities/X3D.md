---
title: X3D
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [動画認識, 3D CNN, モデル, 行動認識]
sources: [2605.22200v1.md]
aliases: [X3D-M, X3D-M (Expand 3D)]
---

# X3D

効率的な動画認識のための3D CNNファミリー（Feichtenhofer, 2020）。2D画像分類ネットワークを時間・空間・幅・深さ等の複数の軸に沿って段階的に「拡張（expand）」することで、計算効率と精度のトレードオフを最適化したモデル群。X3D-XS/S/M/L など複数サイズが存在する。

## OSSチャレンジでの位置づけ

[[sources/OSS Challenge]]の**ベースラインモデル**のバックボーンとして **X3D-M** が採用された。

- Kinetics-400 で事前学習
- 重なりのある16フレームクリップ単位で特徴を計算
- クリップレベル特徴を平均プーリングで動画全体特徴に集約 → MLPヘッドでスキルスコアを回帰
- Huber損失でGRS（8〜40）を回帰する3モデルのアンサンブル。[[entities/Temporal Segment Network|segment-based sampling]]でクリップをランダム化

このベースラインは2024・2025の両エディションで**全参加チームを上回る最高性能**を示し、汎用的な時空間動画モデルが外科スキル評価において強力であることを実証した。[[concepts/外科技術自動評価]]における「汎用性＋丁寧なチューニング」の代表例。

## 関連モデルとの比較

[[entities/AIxSuture データセット]]のベンチマーク（[[sources/AIxSuture]]）では [[entities/I3D]] や [[entities/Video Swin Transformer]] が用いられたのに対し、OSSベースラインはX3D-Mを採用している。いずれもKinetics-400事前学習の動画モデルであり、[[concepts/転移学習]]が外科ドメインへ有効に転用できることを示す。

## 関連ページ

- [[sources/OSS Challenge]]
- [[entities/I3D]]
- [[entities/Video Swin Transformer]]
- [[entities/Temporal Segment Network]]
- [[concepts/外科技術自動評価]]
