---
title: WiLoR
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [手姿勢推定, 手検出, Transformer, ViT, MANO, モデル]
sources: [2409.12259v2.md, 2603.25726v2.md]
aliases: [WiLoR-in-the-Wild Localization and Reconstruction]
---

# WiLoR

**Wi**ld **Lo**calization and **R**econstruction。Potamias et al.（Imperial College London / Shanghai Jiao Tong、CVPR 2025、[[sources/WiLoR]]）による、in-the-wild での 3D 手のローカライズと再構成を行う**エンドツーエンドのフルスタック手法**。手検出と 3D 再構成を一つのパイプラインに統合した初の手法と位置づけられる。

## 全体構成（2 段パイプライン）

1. **リアルタイム手検出・ローカライゼーション**（[[concepts/手検出・ローカライゼーション]]）— 完全畳み込み、>130 FPS で複数手を検出
2. **高忠実度 3D 手再構成** — Transformer + refinement モジュールで MANO パラメータを推定

検出器が出力する手領域クロップを再構成モジュールに渡す。堅牢な検出により、時間モジュールなしで安定した 4D（時系列）再構成を実現する。

## 手検出モジュール

- DarkNet バックボーン + PANet ネック + 3 検出ヘッド、**anchor-free** 設計
- マルチタスク損失（BCE + 分布焦点損失 + CIoU + キーポイント L2）。関節キーポイント監督が精度を底上げ
- **Proposed-S**: 175 FPS / 7Mb、**Proposed-M**: 138 FPS / 25Mb。ContactHands 比 45× 高速・32× 小型、mAP 平均 +26%
- 訓練データは [[entities/WHIM データセット]]（2M 枚）。詳細は [[concepts/手検出・ローカライゼーション]]

## 3D 再構成モジュール

ViT バックボーン + **coarse-to-fine の multi-scale refinement モジュール**を持つ。

### ベース推定
- 入力: 手領域クロップ画像。出力: MANO ポーズ θ∈ℝ⁴⁸・形状 β∈ℝ¹⁰ とカメラ K_cam={t_cam, s_cam}
- **ViT-Large**（hidden 1280、[[entities/HaMeR]] と同じく ViTPose 事前学習）。画像パッチトークンに加え、学習可能な pose / shape / camera の 3 トークンを連結して ViT エンコーダに投入
- MLP で rough なポーズ θᶜ・形状 βᶜ とカメラを回帰（refinement の事前推定）

### Multi-Scale Pose Refinement Module（本論文の核心）
- ViT 出力の画像トークンを低解像度特徴マップ F₀ に reshape し、deconv で多解像度 F₀,…,Fₙ にアップサンプル
- rough 推定の**手メッシュ全体**（関節のみでなく）を、推定カメラで特徴マップに投影し、各頂点の画像整合特徴をバイリニア補間でサンプル（式6）
- 集約特徴から MLP でポーズ・形状の**残差 Δθ, Δβ** を回帰（式7）。低解像度 → 大域・構造的残差、高解像度 → 細部
- これにより、1 ショット回帰の弱点（位置ずれ・不正確なポーズ）を補正し画像整合性を改善
- 出力は **MANO パラメータ**（96 次元 = 15 関節 + 1 グローバル、6D 回転表現 + 10 形状）。頂点を直接回帰せず、説明可能で妥当なポーズを保証

### 損失（式8）
$\mathcal{L} = \mathcal{L}_{3D} + \mathcal{L}_{2D} + \mathcal{L}_{mano} + \mathcal{L}_{adv}$（3D 頂点・2D 関節・MANO パラメータ + 妥当性を担保する識別器の敵対的損失）

訓練データは 14 データセット計 **4.2M 枚**（HaMeR より 55% 多い。FreiHAND/HO3D/InterHand2.6M/ARCTIC/BEDLAM/Re:InterHand 等）。

ViT バックボーンは [[concepts/Self-Attention]] を中核とする Transformer。

## 性能（一次ソース）

- **FreiHAND**: PA-MPJPE 5.5 / PA-MPVPE 5.1 / F@5 0.825 / F@15 0.993（全指標 SOTA、HaMeR を上回る）
- **HO3D v2**: AUC_J 0.851 / PA-MPJPE 7.5 / AUC_v 0.846 / PA-MPVPE 7.7 / F@5 0.646 / F@15 0.983（SOTA）
- **4D / 時間的コヒーレンス**（HO3D）: MPFVE 4.43 / Jitter 5.92 / RTE 0.07（HaMeR 10.60/20.43/2.92 を大幅に改善）。時間モジュール不使用

### アブレーションの含意
- FastViT 置換・ViTPose 事前学習なし・refinement なし・single-scale refinement・小規模データのいずれも劣化 → **multi-scale refinement + 大規模データ + ViTPose 初期化**が性能の要

## 限界

極端な指ポーズ・混雑環境で失敗しうる。ボトムアップ戦略のため手同士の接触を 3D で十分捉えられない。カメラ空間推定のためシーン全体の 3D は不正確になりうる。著者は合成データによる多様なポーズ補完を将来課題に挙げる → [[sources/AnyHand]] がこの方向を実証。

## AnyHand との関係

[[sources/AnyHand]] の RGB-only 評価における代表ベースラインの一つ。[[entities/AnyHand データセット]] の 6.6M 合成サンプルを追加して共訓練した。

### 共訓練による改善
- **FreiHAND**: PA-MPJPE 5.5→5.39mm（1.9%）。全体で最良の結果
- **HO-3D v2**: PA-MPJPE 7.5→7.36mm（1.9%）。全体で最良
- **HO-Cap（ドメイン外）**: PA-MPJPE 5.02→4.69mm

WiLoR は元々の訓練コーパスが大きく refinement も持つため、AnyHand 追加による改善余地は HaMeR より小さい。

## AnyHandNet-D の基盤

RGB-D モデル [[entities/AnyHandNet-D]] は WiLoR の RGB-only パイプラインの上に軽量な深度融合モジュール（[[concepts/RGB-D深度融合]]）を追加して構築される。融合モジュールは modular に設計され、WiLoR のような ViT ベースアーキテクチャに最小限の変更で統合できる。

## 外科スキル評価への応用（ExpOS）

[[sources/ExpOS]]（Papo et al., Technion）は、WiLoR を**開放手術スキル評価の process チャンネルとして用いた初の事例**。[[entities/RoHans]] で手術室向けに refine した手検出器を WiLoR に統合し、各手21関節の3D軌跡を抽出して時間モデル（[[entities/MS-TCN++]]）に通す。これは [[concepts/プロセス vs 成果の信号分解]] が「誰も試していない」と特定した方向の実装にあたる。なお WiLoR 論文自身が懸念した手袋・特異視点・器具オクルージョンの困難に、ExpOS は RoHans の自己訓練でドメイン適応して対処している。

この 3D 化は突然出てきたものではなく、同 Laufer 研の2D前身 [[sources/手姿勢推定による開放手術トレーニングフィードバックの自動化|Bkheet et al. 2022]] が「**多視点2D姿勢で +1.23% → 3D姿勢なら上回りうる**」と予想し、hand orientation プロキシの2D制約を限界に挙げていた流れの帰結である。WiLoR はその予想に応える 3D バックエンドとして選ばれた。

## 関連

- [[sources/WiLoR]] — 原論文
- [[entities/WHIM データセット]] — 手検出器の訓練データ
- [[concepts/手検出・ローカライゼーション]] — 検出モジュールの概念
- [[entities/HaMeR]] — もう一方の代表ベースライン、同系統の先行 SOTA
- [[entities/AnyHandNet-D]] — WiLoR を拡張した RGB-D モデル
- [[sources/ExpOS]] — WiLoR を開放手術スキル評価に応用した初の事例
- [[entities/RoHans]] — ExpOS で前段に置く手術室向け手検出
- [[entities/MANO]] / [[concepts/3D手姿勢推定]]
