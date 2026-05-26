---
title: HaMeR
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, Transformer, ViT, MANO, モデル]
sources: [2409.12259v2.md, 2603.25726v2.md]
aliases: [Reconstructing Hands in 3D with Transformers]
---

# HaMeR

**Ha**nd **Me**sh **R**ecovery。Pavlakos et al.（CVPR 2024）による、単一 RGB 画像から 3D 手メッシュを復元する Transformer ベースの手法。論文「Reconstructing hands in 3D with transformers」[50]。

## 特徴

- **ミニマリストな foundation 風設計**: ViT バックボーン（ViTPose [69] 由来）を fine-tune し、単一 RGB 画像から [[entities/MANO]] のポーズ・形状・カメラポーズを**直接回帰**
- 約 2.7M 枚の混合コーパスで訓練
- 「相対的に単純なアーキテクチャでも、多様で大規模なデータで訓練すれば高性能」という思想を実証した代表例

ViT バックボーンは [[concepts/Self-Attention]] を中核とする Transformer。同系統の手法に [[entities/WiLoR]]、Hamba（グラフ誘導 Mamba バックボーン）がある。

## WiLoR 論文での位置づけ

後発の [[sources/WiLoR]]（CVPR25）は HaMeR を主要ベースラインとしてベンチマークし、全指標で上回る（FreiHAND PA-MPJPE 6.0→5.5、HO3D v2 PA-MPVPE 7.9→7.7 等）。特に 4D / 時間的コヒーレンス（HO3D）で HaMeR のジッタ（MPFJE 1.768、Jitter 20.43）を大きく改善（0.762 / 5.92）。WiLoR は HaMeR の「1 ショット MANO 回帰は位置ずれ・不正確なポーズを招く」点を multi-scale refinement で補正したと位置づける。なお WiLoR の ViT バックボーンの ViTPose 事前学習は HaMeR と共通の系統。

## AnyHand との関係

[[sources/AnyHand]] の RGB-only 評価における 2 つの代表ベースラインの一つ（もう一方は [[entities/WiLoR]]）。アーキテクチャ・訓練ハイパラを公式設定のまま固定し、訓練コーパスに [[entities/AnyHand データセット]] の 6.6M 合成サンプルを追加して共訓練した。

### 共訓練による改善
- **FreiHAND**: PA-MPJPE 6.0→5.54mm（7.6%）、PA-MPVPE 5.7→5.24mm（約8.1%）。トップ群と同等のティアに到達
- **HO-3D v2**: PA-MPJPE 7.7→7.47mm（3.0%）
- **HO-Cap（ドメイン外）**: PA-MPJPE 4.94→4.66mm。元々 HO-Cap で WiLoR より弱かったが、AnyHand 共訓練後は WiLoR w/ AnyHand（4.69mm）を逆転

HaMeR は WiLoR より訓練データが小さいため、AnyHand 追加による改善幅が WiLoR より大きい傾向がある。AnyHand のアブレーション実験はすべて HaMeR を固定バックボーンとして実施されている。

## 関連

- [[entities/WiLoR]] — もう一方の代表ベースライン、AnyHandNet-D の基盤
- [[entities/MANO]] — 回帰対象の手パラメトリックモデル
- [[concepts/3D手姿勢推定]]
