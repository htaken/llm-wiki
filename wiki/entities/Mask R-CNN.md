---
title: Mask R-CNN
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [深層学習, インスタンスセグメンテーション, 物体検出, コンピュータビジョン]
sources: [Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md]
aliases: [Mask RCNN, マスクR-CNN]
---

# Mask R-CNN

He et al. (2017) によって提案された[[concepts/インスタンスセグメンテーション]]のフレームワーク。物体検出（バウンディングボックス + クラス分類）とピクセル単位のマスク予測を同時に行う。

## アーキテクチャ

- Faster R-CNNを拡張し、各Region of Interest (RoI) に対してマスク予測ブランチを追加
- バックボーンとしてFeature Pyramid Network (FPN) を使用し、マルチスケールの特徴を抽出
- RoIAlign により、従来のRoIPoolingのずれ（misalignment）を解消

## 縫合品質評価への応用

[[sources/Automated measurement extraction for suture quality]]では、Mask R-CNNを用いて縫合画像からwound、knot、surface、leftoverの各インスタンスをセグメンテーションした。

- バックボーン: ResNet-50-FPN および ResNet-101-FPN
- 事前学習: COCO データセットからの転移が最良（ImageNet、LVISより有意に優位）
- ResNet-50とResNet-101で有意差なし → 小さいモデルで十分
- [[entities/Detectron2]]ライブラリ (v0.6) で実装
- 推論速度: 画像あたり450ms未満

## 関連ページ

- [[concepts/インスタンスセグメンテーション]]
- [[entities/Detectron2]]
- [[sources/Automated measurement extraction for suture quality]]
