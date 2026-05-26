---
title: "AnyHand: A Large-Scale Synthetic Dataset for RGB(-D) Hand Pose Estimation"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, 合成データ, RGB-D, コンピュータビジョン, データセット, 深層学習]
sources: [2603.25726v2.md]
aliases: [AnyHand論文, AnyHand]
---

# AnyHand: A Large-Scale Synthetic Dataset for RGB(-D) Hand Pose Estimation

## 書誌情報

- **著者**: Chen Si\*¹, Yulin Liu\*¹, Bo Ai¹, Jianwen Xie², Rolandos Alexandros Potamias³, Chuanxia Zheng⁴, Hao Su¹（\*は同等貢献）
- **所属**: ¹University of California, San Diego / ²Lambda, Inc / ³Imperial College London / ⁴Nanyang Technological University
- **arXiv**: 2603.25726v2
- **プロジェクトページ**: https://chen-si-cs.github.io/projects/AnyHand

## 要約

単一画像からの**3D手姿勢推定**（[[concepts/3D手姿勢推定]]）において、性能と頑健性は訓練データの量・多様性に強く依存する。しかし実世界収集データはカバレッジが限られ、既存の合成データセットは「オクルージョン・腕の文脈・整合した深度」を大規模に同時提供できていなかった。

本論文は、この隘路を埋める大規模合成 RGB-D データセット **[[entities/AnyHand データセット]]** を提案する。単一手 2.5M 枚＋手-物体インタラクション 4.1M 枚（計 6.6M 枚）の RGB-D 画像を、シミュレーションから得た完璧な幾何アノテーション付きで提供する。

主張の核心は **「データの質・量・多様性こそが律速要因であり、アーキテクチャの複雑化より効く」** という点。既存 SOTA の [[entities/HaMeR]] と [[entities/WiLoR]] を、アーキテクチャ・訓練設定を一切変えずに AnyHand で共訓練（co-training）するだけで、複数ベンチマークで一貫した改善を達成した。

## キーポイント

### 1. AnyHand データセット
- 2 分岐構成: **AnyHand-Single**（純粋な手、多様なポーズ）と **AnyHand-Interact**（手-物体インタラクション、物体由来の重いオクルージョン）
- [[entities/SAPIEN]] のレイトレーシングレンダラで生成。リアルなシェーディング・影・スペキュラを再現
- 整合した深度マップ、前景マスク、2D bbox、カメラ内部/外部パラメータ、3D 手ポーズ・形状を全サンプルに格納
- 生成パイプラインも公開

### 2. AnyHandNet-D（RGB-D モデル）
- [[entities/WiLoR]] の RGB-only パイプラインに**軽量な深度融合モジュール**を追加した [[entities/AnyHandNet-D]]
- RGB と深度を並列トークン列に埋め込み、双方向 RGB-Depth クロスアテンションで融合（[[concepts/RGB-D深度融合]]）
- 既存 RGB-D 手法（IPNet、Keypoint-Fusion）を上回る

### 3. 主要な実験結果
- **FreiHAND**: HaMeR の PA-MPJPE が 6.0→5.54mm（7.6%改善）、WiLoR が 5.5→5.39mm（1.9%改善）
- **HO-3D v2**: HaMeR 7.7→7.47mm（3.0%）、WiLoR 7.5→7.36mm（1.9%）
- **HO-Cap（ドメイン外、fine-tuning なし）**: HaMeR w/ AnyHand が PA-MPJPE 4.66mm で WiLoR w/ AnyHand（4.69mm）を逆転。元々 HaMeR は HO-Cap で WiLoR より弱かったため、「訓練データ分布がアーキテクチャ差を上回りうる」ことを示す
- **RGB-D HO-3D**: AnyHandNet-D が STA-MPJPE 1.09cm（Keypoint-Fusion の 1.87cm から約41.7%削減）。MoGe-2 推定深度を使うと GT 深度より良い（1.06cm）

## 合成データ生成パイプラインの構成要素

| 要素 | 内容 | 出典 |
|---|---|---|
| 手形状 | 47,438 個の MANO β を FreiHAND + InterHand2.6M の経験分布からサンプル | [[entities/MANO]] |
| 手ポーズ | DPoser-Hand 拡散事前分布からオンザフライでサンプル（多峰性ポーズ分布を捕捉） | DPoser-Hand [40] |
| 手テクスチャ | Handy で 10,240 種の高周波スキンパターン生成＋色変換で肌色を拡張 | Handy [51] |
| 前腕テクスチャ | SMPLitex の 254 種の人体テクスチャ | SMPLitex [4] |
| 背景 | MIT Indoor Scenes 536 枚 + HDRI 734 枚 = 1,270 種 | [54] |
| ライティング | シーンごとに 1〜5 灯をランダム、背景の色調と相関 | — |
| カメラ | FOV 30°〜40°、手-カメラ距離 平均 0.6/0.7/1.0m（std 0.1m）、1シーン2視点 | — |
| 物体 | GraspXL 由来の 500k 超のテクスチャ付き物体（Objaverse） | GraspXL [72] |
| 深度合成 | 前景は SAPIEN の metric depth、背景は MoGe-2 推定深度をカメラ空間で融合 | MoGe-2 [63] |

## アブレーション・追加知見

- **両分岐が必要**: Single / Interact どちらを落としても性能低下。ターゲットが両者を含む場合は両方で共訓練が最良
- **腕テクスチャは有効**: 幾何だけでなくリアルな腕の見えが文脈手掛かりとなり汎化を改善
- **拡散ポーズ > 補間ポーズ**: DPoser-Hand の拡散事前分布を実データ補間ポーズに替えると一貫して悪化
- **混合比**: AnyHand 単独（100%）は不十分で元レシピより悪化。混合（25/50/75%）は全て 0% を上回るが、最適比率は未確定
- **スケーリング**: 約 2〜4M サンプルで収穫逓減。ただしドメイン外（HO-Cap）では合成データ増量がより継続的に効く
- **欠損深度への頑健性**: GT 深度を MoGe-2 推定深度で置換しても劣化せず、むしろ改善（GT の HO-3D 深度は量子化・欠損が多いため）

## 関連先行研究との比較

- **Zhao et al. [75]（sim-to-real 解析）**: ベンチマーク一致の合成対応物（SynFrei/SynDex、計約362K枚）で要因分解する「制御された解析」が目的。AnyHand は RGB-D で 6.6M 枚規模の「スケーラブルな訓練リソース」が目的。AnyHand はシミュレーションネイティブにレンダリング（腕メッシュを MANO 手首に装着）するのに対し、Zhao et al. は実画像の腕/物体を貼り付ける合成的構成で境界アーチファクトが生じうる
- 詳細は [[concepts/合成データとsim-to-realギャップ]] を参照

## データ統計の不整合（要確認）

論文内で AnyHand の枚数に不整合がある:
- 概要・Table 1: AnyHand-Single **2.5M**、AnyHand-Interact **4.1M**（計 6.6M）
- §3.2 統計・Table 7: AnyHand-Single 1.05M シーン/**2.1M 画像**、AnyHand-Interact 2.1M シーン/**4.2M 画像**

「6.6M synthetic samples」という記述（§4.1）は 2.5+4.1 と整合する。本Wikiでは概要側の 2.5M/4.1M を主表記とし、統計セクションの数値を併記する。
