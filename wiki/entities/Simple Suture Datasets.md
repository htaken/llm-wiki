---
title: Simple Suture Datasets
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [データセット, 縫合, インスタンスセグメンテーション, 医学教育]
sources: [Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md]
aliases: [Simple Suture Dataset, 縫合データセット]
---

# Simple Suture Datasets

Noraset et al. が[[sources/Automated measurement extraction for suture quality]]で収集した、simple interrupted suture（単純結節縫合）の練習画像データセット。[[concepts/インスタンスセグメンテーション]]と物理計測のアノテーションを含む。

## データセット構成

| 項目 | Dataset 1 (Silk) | Dataset 2 (Nylon) |
|------|-------------------|-------------------|
| 糸の材質 | Silk（太い、安価） | Nylon（細い、医療用） |
| 参加者数 | 145名（Novice） | 35名（Novice 20 + Expert 15） |
| 総画像数 | 2,050 | 142 |
| セグメンテーション注釈画像 | 98 | 142 |
| 物理計測注釈 | なし | 142画像（参加者が各練習後に計測） |
| 収集方法 | 授業中ボランティア | 有給参加者 |

合計240画像にインスタンスセグメンテーション注釈を付与。4名の有給アノテーターがCVAT（Computer Vision Annotation Tool）を使用。

## アノテーション形式

1. **インスタンスセグメンテーション**: wound、knot、surface、leftoverの各インスタンスに対するピクセルマスクとバウンディングボックス
2. **物理計測**（Dataset 2のみ）: 参加者が各練習後にbite size（左右）、leftover length、stitch separationを物理的に計測

## データセットの特徴

- Dataset 1（Silk）: 初心者のみ、糸が太く視認しやすいがstitchが乱雑、画像あたりのstitch数が少ない
- Dataset 2（Nylon）: Expert含む、糸が細く視認困難だが、stitchが整然としており、切開線にマーカーラインあり
- 画像サイズは携帯電話の機種・撮影距離により可変、幅1024pxにリサイズして使用

## 公開先

- データセット: Google Drive
- ソースコード・学習済みモデル: [Code Ocean](https://codeocean.com/capsule/3182402/tree)

## 倫理審査

Siriraj Institutional Review Board, Faculty of Medicine Siriraj Hospital, Mahidol University の承認済み（Si 514/2021, Protocol No. 304/2564(IRB2)）。

## 関連ページ

- [[entities/AIxSuture データセット]] — 開放手術縫合の動画データセット（別タスク）
- [[entities/Mask R-CNN]]
- [[sources/Automated measurement extraction for suture quality]]
