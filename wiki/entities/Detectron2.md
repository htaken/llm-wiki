---
title: Detectron2
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [深層学習, ライブラリ, 物体検出, インスタンスセグメンテーション]
sources: [Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md]
aliases: []
---

# Detectron2

Meta AI Research（旧Facebook AI Research）が開発した物体検出・セグメンテーションのためのオープンソースライブラリ。PyTorchベース。

- **リポジトリ**: https://github.com/facebookresearch/detectron2
- **開発**: Wu et al. (2019)

## 概要

[[entities/Mask R-CNN]]をはじめとする各種物体検出・[[concepts/インスタンスセグメンテーション]]モデルの訓練・推論を統一的なインターフェースで提供する。COCO、LVIS等の標準データセットで事前学習済みモデルを提供しており、ファインチューニングのベースとして広く利用される。

## 縫合品質評価での利用

[[sources/Automated measurement extraction for suture quality]]ではDetectron2 v0.6を使用し、COCO事前学習済みMask R-CNN（ResNet-50-FPN / ResNet-101-FPN）を縫合データセットでファインチューニングした。Scale jitterによるデータ拡張、ステップ減衰学習率、CIoU正則化を採用。

## 関連ページ

- [[entities/Mask R-CNN]]
- [[concepts/インスタンスセグメンテーション]]
- [[sources/Automated measurement extraction for suture quality]]
