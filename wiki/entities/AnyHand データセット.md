---
title: AnyHand データセット
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [データセット, 合成データ, RGB-D, 手姿勢推定]
sources: [2603.25726v2.md]
aliases: [AnyHand-Single, AnyHand-Interact]
---

# AnyHand データセット

3D 手姿勢推定（[[concepts/3D手姿勢推定]]）のための**大規模合成 RGB-D データセット**。Chen Si らが提案（論文: [[sources/AnyHand]]）。リアルなテクスチャと豊富なアノテーションを持つ単一手シーンと手-物体インタラクションシーンで構成される。合成データのため**ground-truth ラベルが構成上「完璧」**で、実データに付きものの注釈ノイズを回避できるのが強み。

## 2 つの分岐

| 分岐 | 焦点 | シーン数 | 画像数 |
|---|---|---|---|
| **AnyHand-Single** | 純粋な手、極めて多様なポーズ | 1.05M | 2.1M（概要表記 2.5M） |
| **AnyHand-Interact** | 手-物体インタラクション、物体由来の重いオクルージョン | 2.1M | 4.2M（概要表記 4.1M） |

> 枚数は論文内に不整合あり。概要/Table 1 は 2.5M / 4.1M（計 6.6M）、§3.2/Table 7 は 2.1M / 4.2M。詳細は [[sources/AnyHand]] の「データ統計の不整合」を参照。

## 既存合成データセットとの比較（Table 1）

AnyHand は規模・リアリズム・モダリティの全てで最も包括的。HDR の屋内/屋外背景、動的ライティング、整合した深度、腕・物体の構成を併せ持つ。

| データセット | 規模 | 背景 | ライティング | 深度 | 腕 | 物体 |
|---|---|---|---|---|---|---|
| RHD [76] | 44K | static | manual | ○ | × | × |
| ObMan [20] | 154K | static | manual | ○ | × | ○ |
| Re:InterHand [44] | 1.5M | HDR-屋内 | dynamic | × | ○ | × |
| RenderIH [29] | 1M | HDR-屋内/屋外 | dynamic | × | × | × |
| **AnyHand-Single** | 2.5M | HDR-屋内/屋外 | dynamic | ○ | ○ | × |
| **AnyHand-Interact** | 4.1M | HDR-屋内/屋外 | dynamic | ○ | ○ | ○ |

要点: 深度・腕の文脈・手-物体オクルージョンを**大規模に同時提供**したのが新規性。

## 生成パイプライン構成

[[entities/SAPIEN]] のレイトレーシングレンダラで生成。主要素:

- **手形状**: 47,438 個の MANO β を FreiHAND + InterHand2.6M の経験分布からサンプル（[[entities/MANO]]）
- **手ポーズ**: DPoser-Hand 拡散事前分布からオンザフライ。多峰性の実ポーズ分布を捕捉し不自然な関節を回避
- **手テクスチャ**: Handy で 10,240 種、色変換で肌色拡張
- **前腕テクスチャ**: SMPLitex の 254 種。前腕メッシュを MANO 手首フレームに装着して 3D でレンダリング（2D 合成の境界アーチファクトを回避）
- **背景**: MIT Indoor Scenes 536 + HDRI 734 = 1,270 種
- **ライティング**: 1〜5 灯、背景の色調と相関させ前景-背景の一貫性を維持
- **カメラ**: FOV 30°〜40°、距離 平均 0.6/0.7/1.0m、1 シーンにつき 2 視点をレンダリング
- **Interact 分岐**: GraspXL の 10M 超の物理シミュレーション把持シーケンスと 500k 超の Objaverse 物体を利用

## 深度マップ

前景（手・前腕）は SAPIEN から正確な metric depth をレンダリングし、背景パッチは MoGe-2 で dense metric depth を推定。両者をカメラ空間で融合して合成深度画像を得る。カメラ内部パラメータの差や背景深度推定ノイズのため「完璧な GT」ではないが、訓練・評価に有用な近似。前景マスクも格納し、損失や深度利用を有効領域に限定可能。

## 格納アノテーション

全サンプルで RGB / 深度 / 前景マスク / 2D bbox / カメラ内部・外部パラメータ / 3D 手ポーズ・形状（MANO）を保存。教師あり学習・評価の両方に使用可能。

## 利用法と効果

既存実データに対する**ドロップイン共訓練ソース**として機能する。[[entities/HaMeR]]・[[entities/WiLoR]] の元コーパスに 6.6M サンプルを追加するだけで FreiHAND / HO-3D / HO-Cap で一貫改善（[[sources/AnyHand]] 参照）。AnyHand テスト集合自体もベンチマークとして提供される（4 スプリット: Single/Interact × EnvMap/Indoor）。

## 関連

- [[sources/AnyHand]] — 出典論文
- [[concepts/合成データとsim-to-realギャップ]] — 設計思想の背景
- [[entities/AnyHandNet-D]] — このデータセットで共訓練される RGB-D モデル
