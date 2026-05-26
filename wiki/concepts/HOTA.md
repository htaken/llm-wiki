---
title: HOTA
type: concept
created: 2026-05-26
updated: 2026-05-26
tags: [トラッキング評価, 指標, マルチオブジェクトトラッキング, キーポイント]
sources: [2605.22200v1.md]
aliases: [HOTA, Higher Order Tracking Accuracy]
---

# HOTA (Higher Order Tracking Accuracy)

マルチオブジェクトトラッキング（MOT）を評価する高次指標（Luiten et al., 2020）。物体の**検出（detection）**・**局所化（localization）**・**トラックへの正しい関連付け（association）**の3要素を統合・バランスして1つのスコアにまとめる。

## 定義

各局所化閾値 $\alpha$ における $\mathrm{HOTA}_\alpha$ は、検出精度 $\mathrm{DetA}_\alpha$ と関連精度 $\mathrm{AssA}_\alpha$ の幾何平均として計算される。閾値 $\alpha$ は予測と正解が一致と見なされる最小類似度を定める。最終スコアは複数閾値での積分（実装上は離散和）で局所化精度も取り込む:

$$
\mathrm{HOTA} = \int_0^1 \mathrm{HOTA}_\alpha\, d\alpha \approx \frac{1}{19} \sum_{\alpha \in \{0, 0.05, \dots, 0.95, 1\}} \mathrm{HOTA}_\alpha
$$

## OSSチャレンジでの利用

[[sources/OSS Challenge]] 2025 の **Task 3（キーポイントトラッキング）** の評価指標として採用された。

- 元のHOTAはバウンディングボックス追跡用で、基底の類似度に **IoU** を用いる
- Task 3はキーポイント追跡のため、類似度を **ユークリッド距離** に置き換えて改変
- ソースコードは公開され、開発期間中に参加者へ提供された

Task 3の最高スコアは Jmees の **HOTA=0.20** と全体に低水準。オクルージョン・フレーム外・高速動作・小さい針の追跡困難が原因で、HOTA指標が開放手術動画の特性に最適調整されていなかった可能性も指摘された。この低性能は、運動ベースのスキル解析（[[concepts/外科技術自動評価]]のプロセス指向アプローチ）の前提条件となるトラッキング精度がまだ不十分であることを示す。

## 関連ページ

- [[sources/OSS Challenge]]
- [[concepts/外科技術自動評価]]
- [[concepts/手検出・ローカライゼーション]]
