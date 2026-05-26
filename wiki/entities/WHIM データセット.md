---
title: WHIM データセット
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [手検出, データセット, in-the-wild, 自動アノテーション, MANO]
sources: [2409.12259v2.md]
aliases: [WHIM, Wild Hands dataset]
---

# WHIM データセット

[[sources/WiLoR]] が構築した、**200 万枚超の in-the-wild 手画像データセット**。多様なポーズ・照明・オクルージョン・肌色を含む。堅牢な手検出（[[concepts/手検出・ローカライゼーション]]）の訓練を目的とし、従来の in-the-wild マルチハンドデータセットの**約 100 倍規模**（Table 7）。

> WHIM は論文中で正式な頭字語展開はされておらず、"millions of in-the-wild hands" のデータセット名として導入される。

## 収集元

- 1,400 本超の YouTube 動画
- 内容: 手話、料理、日常活動、スポーツ、ゲーム
- 多様性: ego-centric / exo-centric 視点、モーションブラー、多様な手スケール、手同士・手物体インタラクション

## 自動アノテーションパイプライン

完全自動アノテーションで大規模化を達成（手動アノテーションの既存データセットと対照的）。

1. **人物検出**: VitPose + AlphaPose で全人物を検出、信頼度 >0.65 の bbox を選択
2. **手検出（アンサンブル）**: 人物 bbox をクロップし、MediaPipe + OpenPose + ContactHands の 3 検出器に入力。各検出器 $d_i$ の信頼度 $P(\mathbf{b}_i|d_i)$ で bbox 位置を重み付け平均（式1）:

   $$\hat{y} = \frac{\sum_i P(\mathbf{b}_i|d_i)\,\mathbf{b}_i}{\sum_i P(\mathbf{b}_i|d_i)}$$

3. **3D MANO フィッティング**: 推定 2D ランドマークから [[entities/MANO]] の形状 β・ポーズ θ を最適化
   - 再投影損失 $\mathcal{L}_{proj}$（弱透視投影、式2）
   - **生体力学制約** $\mathcal{L}_{BMC} = \mathcal{L}_{BL} + \mathcal{L}_{A}$（骨長 + 関節角を可動域に拘束、Spurr et al. [79]）— 自由度の高い手の不自然なポーズを抑制
   - **3D 事前分布**: ARCTIC データセットで訓練した PCA モデルの再構成誤差を事前損失とする（式4）

## アノテーション仕様（Table 7）

| 項目 | WHIM |
|---|---|
| 画像数 | 2M |
| アノテーション方式 | 自動（Auto） |
| Egocentric | ✓ |
| Third-Person | ✓ |
| 物体あり | ✓ |
| 実画像（Real） | ✓ |
| 3D アノテーション | ✓ |

従来データセット（OxfordHands 13K、ContactHands 21K、CocoHands 25K、Coco-Whole 200K 等）はいずれも手動アノテーション中心かつ小規模で、ego/3D の同時提供がなかった。

## 役割と効果

- WiLoR の手検出器の唯一の訓練データ。アブレーション（Table 2）では、訓練量を 0.25M/0.5M/1M に減らすと一貫して性能低下し、WHIM 訓練は OxfordHands 訓練より高い汎化を示す
- 検出器を [[entities/WiLoR]] パイプラインの上流として、in-the-wild マルチハンド再構成と安定した 4D トラッキングを可能にする

## 関連

- [[sources/WiLoR]] — このデータセットを提案した論文
- [[concepts/手検出・ローカライゼーション]] — このデータで訓練される検出タスク
- [[entities/WiLoR]] — WHIM で訓練された検出器を含むモデル
- [[entities/MANO]] — 3D アノテーション生成に用いるパラメトリックモデル
