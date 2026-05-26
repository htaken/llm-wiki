---
title: "WiLoR: End-to-end 3D Hand Localization and Reconstruction in-the-wild"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, 手検出, Transformer, ViT, MANO, データセット, コンピュータビジョン, 深層学習]
sources: [2409.12259v2.md]
aliases: [WiLoR論文, WiLoR原論文]
---

# WiLoR: End-to-end 3D Hand Localization and Reconstruction in-the-wild

[[entities/WiLoR]] の原論文。

## 書誌情報

- **著者**: Rolandos Alexandros Potamias¹, Jinglei Zhang², Jiankang Deng¹, Stefanos Zafeiriou¹
- **所属**: ¹Imperial College London / ²Shanghai Jiao Tong University
- **arXiv**: 2409.12259v2（CVPR 2025）
- **コード・モデル・データセット**: プロジェクトページで公開

## 要約

3D 手姿勢推定（[[concepts/3D手姿勢推定]]）は近年大きく進展した一方で、**手検出パイプライン**には大きな空白があり、実世界のマルチハンド再構成システム構築の障害となっていた。現行の 3D 手姿勢推定は手領域のタイトクロップ上で動作するため、in-the-wild への汎化には堅牢な手検出器が不可欠だが、既存の手検出手法（MediaPipe、OpenPose、ContactHands、ViTDet 等）は複数手・難ポーズの検出に失敗するか、リアルタイム動作できなかった。

本論文は、in-the-wild でのマルチハンド再構成を効率的に行う **2 段構成のフルスタックパイプライン WiLoR** を提案する:

1. **リアルタイム完全畳み込み手検出・ローカライゼーション**（[[concepts/手検出・ローカライゼーション]]）— >130 FPS
2. **高忠実度な Transformer ベース 3D 手再構成**（[[entities/WiLoR]] の再構成モジュール）— refinement モジュールで画像整合性を改善

これを支えるため、200 万枚超の in-the-wild 手画像データセット **[[entities/WHIM データセット]]** を構築した。WiLoR は 2D/3D ベンチマークで精度・効率ともに既存手法を上回り、時間モジュールを一切使わずに単眼動画から滑らかな 3D 手トラッキングを実現する。

## キーポイント

### 1. WHIM データセット（手検出の新規ベンチマーク）
- 1,400 本超の YouTube 動画（手話・料理・日常活動・スポーツ・ゲーム、ego/exo 視点、モーションブラー、多様なスケール・インタラクション）から自動アノテーション
- アンサンブル検出パイプライン: VitPose + AlphaPose で人物検出（信頼度 >0.65）→ クロップ → MediaPipe + OpenPose + ContactHands で手検出、信頼度で重み付け平均（式1）
- 2D ランドマークから [[entities/MANO]] をフィッティング（再投影損失＋生体力学制約＋ARCTIC 由来 PCA 事前分布）
- 計 200 万枚、自動アノテーション、ego/third-person、物体・3D アノテーションあり。従来の in-the-wild マルチハンドデータセットの **100 倍規模**（Table 7）

### 2. リアルタイム手検出器
- DarkNet バックボーン + PANet（Path Aggregation Network）ネック + 3 検出ヘッド、anchor-free 設計
- マルチタスク損失（BCE + 分布焦点損失 DFL + CIoU + キーポイント L2）
- **Proposed-S**: 175 FPS / 7Mb、**Proposed-M**: 138 FPS / 25Mb
- 従来 SOTA の ContactHands 比で **45× 高速・32× 小型**、mAP 平均 +26%（Table 1）

### 3. 高忠実度 3D 再構成 + Multi-Scale Refinement
- ViT-Large バックボーン（ViTPose 事前学習）で MANO の rough 推定 → 多解像度特徴マップ上に手メッシュを投影し画像整合特徴をサンプル → ポーズ・形状残差 Δθ, Δβ を回帰（coarse-to-fine）
- 頂点を直接回帰せず **MANO パラメータを回帰**し、説明可能で妥当なポーズを保証
- FreiHAND（Table 3）・HO3D v2（Table 4）の両ベンチマークで全指標 SOTA

### 4. 4D / 時間的コヒーレンス
- 時間モジュールなしで、連続フレーム間の MPFVE/MPFJE/Jitter/RTE を大幅改善（Table 6）。HaMeR 比でジッタを数分の一に削減。堅牢な検出が安定した 4D 再構成の鍵

## 主要な実験結果

### 手検出（Table 1、RTX 4090）
| 手法 | Size(Mb)↓ | FPS↑ | COCO-Whole mAP↑ | Oxford mAP↑ | WHIM mAP↑ |
|---|---|---|---|---|---|
| MediaPipe | 25 | 25 | 3.72 | 1.80 | 12.01 |
| OpenPose | 141 | 29 | 9.06 | 4.41 | 34.25 |
| ContactHands | 819 | 3 | 16.67 | 36.41 | 49.44 |
| ViTDet | 1400 | 1 | 13.21 | 29.77 | 35.42 |
| **Proposed-S** | 7 | **175** | 18.56 | 38.16 | 46.50 |
| **Proposed-M** | 25 | 138 | **25.97** | **48.98** | **53.79** |

### 3D 再構成
- **FreiHAND**（Table 3）: PA-MPJPE **5.5**、PA-MPVPE **5.1**、F@5 **0.825**、F@15 **0.993**（HaMeR 6.0/5.7/0.785/0.990 を全指標で上回る）
- **HO3D v2**（Table 4）: AUC_J **0.851**、PA-MPJPE **7.5**、AUC_v **0.846**、PA-MPVPE **7.7**、F@5 **0.646**、F@15 **0.983**（HaMeR 0.846/7.7/0.841/7.9/0.635/0.980 を上回る）
- **4D / 時間的コヒーレンス**（Table 6、HO3D）: MPFVE 4.43 / MPFJE 0.762 / Jitter 5.92 / RTE 0.07（HaMeR は 10.60/1.768/20.43/2.92）

## アブレーション・追加知見

### 手検出（Table 2、OxfordHands/WHIM）
- バックボーン: DarkNet 以外（ResNet50/HRNet）は精度同等だが速度が大きく低下
- データ量: 0.25M/0.5M/1M と減らすと性能低下。WHIM 訓練は OxfordHands 訓練より良い
- データ拡張: cross-dataset 汎化で mAP +14%
- ランドマーク回帰損失: 検出精度を向上

### 3D 再構成（Table 5、FreiHAND）
- **FastViT** バックボーン置換 → 効率は上がるが性能大幅低下
- **ViTPose 事前学習なし**（スクラッチ） → 性能低下
- **refinement なし** / **single-scale refinement** → いずれも劣化（multi-scale refinement の有効性）
- **FreiHAND のみ** / **HaMeR のデータセット[63]のみ** で訓練 → フルの大規模データに劣る

## 訓練設定（補足資料）

- **検出器**: WHIM 2M、Adam、200 epochs（30 epochs 改善なしで早期終了）、lr 0.01→1e-6、2× RTX 4090・batch 256 で 3 週間。損失重み λ₀=0.5(分類)/λ₁=1.5(DFL)/λ₂=15(bbox)/λ₃=10(keypoints)、mosaic 拡張 p=0.7、回転 [-60°,60°]、スケール [0.5,1]
- **再構成**: ViT-Large（hidden 1280、ViTPose 事前学習）。出力は 96 ポーズパラメータ（15 関節 + 1 グローバル、6D 回転表現）+ 10 形状 + 3D カメラ並進。画像トークンを 16×12 に reshape し deconv で 2 回アップサンプル。1000 epochs、Adam、lr 1e-5、weight decay 1e-4。損失重み λ_3D=0.05/λ_2D=0.01/λ_pose=0.001/λ_shape=0.0005/λ_adv=0.0005
- **再構成の訓練データ**: 14 データセット計 **4.2M 枚**（従来 SOTA の HaMeR より 55% 多い）。FreiHAND, HO3D, MTC, RHD, InterHand2.6M, H2O3D, DEX YCB, COCO WholeBody, Halpe, MPII NZSL, BEDLAM, ARCTIC, Re:InterHand, Hot3D

## 限界（§9）

- 極端な指ポーズ、混雑環境の小さな手では検出・再構成に失敗しうる
- ボトムアップ戦略のため、手同士のインタラクション・接触を 3D で十分に捉えられない
- カメラ空間で推定するため、シーン全体の 3D に関しては不正確になりうる（3D メトリック基盤モデルとの統合で改善余地）

## AnyHand との関係

本論文の WiLoR は、後発の [[sources/AnyHand]] において [[entities/HaMeR]] と並ぶ代表的 RGB ベースラインとして採用され、合成データ共訓練で SOTA を更新された。また RGB-D モデル [[entities/AnyHandNet-D]] は WiLoR の RGB-only パイプラインを基盤とする。WiLoR 自身も限界節で「合成データセットによる多様なポーズの補完」を将来課題に挙げており、AnyHand はこの方向性を実証した形になる。

## 関連

- [[entities/WiLoR]] — 本論文が提案するモデル本体
- [[entities/WHIM データセット]] — 本論文が構築した手検出データセット
- [[concepts/手検出・ローカライゼーション]] — 検出パイプラインの概念
- [[concepts/3D手姿勢推定]] — 再構成タスクの概念
- [[entities/HaMeR]] — 比較対象かつ同系統の先行 SOTA
- [[entities/MANO]] / [[sources/AnyHand]] / [[entities/AnyHandNet-D]]
