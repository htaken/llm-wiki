---
title: Sapiens2
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [人物中心視覚, 基盤モデル, Vision Transformer, Meta, 姿勢推定, セグメンテーション, 法線推定]
sources: [2604.21681v1.md]
aliases: [SAPIENS2, Sapiens 2, Sapiens-2]
---

# Sapiens2

Meta Reality Labs が開発した、**人物中心視覚（[[concepts/人物中心視覚]]）のための高解像度 Vision Transformer 基盤モデルファミリー**。前世代 Sapiens（Khirodkar et al., ECCV 2024）の後継で、**0.4B〜5B パラメータ**の複数サイズを持つ。10億枚の人物画像（[[entities/Humans-1B データセット]]）で事前学習され、姿勢推定・身体部位セグメンテーション・法線・pointmap・albedo など複数の人物タスクで SOTA を達成する。原論文は [[sources/SAPIENS2]]。

## 位置づけ

「**あらゆる人物タスク・あらゆる人物画像で動作し、最高の出力忠実度を保つ**」モデルを構築するというビジョンを、前世代から **タスク・画像・忠実度**の3軸で拡張したもの。人物固有の事前知識（キーポイント誘導マスク等）を一切注入せず、「データそのもの」だけで人物意味を学ぶ **inductive-prior-free** な方針を取る（HAP・SOLIDER・LiftedCL 等の事前知識注入型と対照的）。

## モデル構成（1K 解像度）

| モデル | 親（v1） | #Params | FLOPs | hidden | layers | heads |
|---|---|---|---|---|---|---|
| Sapiens2-0.4B | Sapiens-0.3B | 0.398B | 1.260T | 1024 | 24 | 16 |
| Sapiens2-0.8B | Sapiens-0.6B | 0.818B | 2.592T | 1280 | 32 | 16 |
| Sapiens2-1B | Sapiens-1B | 1.462B | 4.715T | 1536 | 40 | 24 |
| Sapiens2-5B | （新規） | 5.071B | 15.722T | 2432 | 56 | 32 |

- 小型3モデルは v1 にアーキ改修を施したもの。**5B は深さ・幅ともに拡張した新規モデル**で、約 15 TFLOPs と報告される中で最大級の FLOPs を持つ ViT。
- **Sapiens2-1B-4K**: 4K 入力の階層型バリアント。セグメンテーション・法線で fine-tune され、出力 2K。
- 公式リポジトリは追加で **Sapiens2-0.1B（0.114B）** も提供（論文 Table 1 には未掲載）。

## アーキテクチャ上の特徴

- **GQA**（中深度ブロック）+ **MHSA**（前後ブロック）、**SwiGLU FFN**
- **QK-Norm**（長スケジュール安定化）、**RMSNorm**（LayerNorm 代替、パラメータ効率）
- **4K 向け階層型アテンション**: windowed self-attention（局所）→ [CLS]-guided pooling →  global attention（大域）。MAE スタイルのスパース事前学習と両立（局所段後にマスクトークンを drop し情報漏洩を防ぐ）。
- **pixel-shuffle デコーダ**で sub-pixel 推論。デコーダ出力解像度はベース 1K（v1 の 0.5K から増）、4K バックボーンで 2K。

これらの機構の基礎は [[concepts/Self-Attention]] を参照。

## 事前学習

**MAE（マスク再構成）+ コントラスティブ学習のハイブリッド**目的 `L = L_MAE + λ·L_CL` でスクラッチ学習（詳細は [[concepts/自己教師あり学習]]）。MAE が低レベル詳細（テクスチャ）を、CL が人物意味を担う。データは [[entities/Humans-1B データセット]]。

## 対応タスク（後段学習）

バックボーンは固定し軽量ヘッドのみ学習する。論文の5タスク:
- **姿勢推定**: 308 キーポイント全身（顔 243 + 手 40 + 体幹/下半身）
- **身体部位セグメンテーション**: 29 クラス
- **Pointmap（深度）**: 画素ごとの 3D XYZ
- **法線推定**: 画素ごとの単位法線
- **Albedo 推定**: 画素ごとの diffuse albedo（relighting 向け）

公式リポジトリでは加えて **human matting** が挙げられる（論文未記載、[[sources/SAPIENS2#GitHub リポジトリの補足情報|要確認]]）。

## ライセンス・利用

独自の "Sapiens2 License"。Python ≥3.12 / PyTorch ≥2.7。torch + safetensors の最小依存でバックボーン推論が可能（facebookresearch/sapiens2）。

## 他モデルとの比較

dense probing（凍結バックボーン）で **[[entities/Perception Encoder|PE]]・DINOv2・DINOv3・Sapiens(v1)** と比較し、同規模で上回る。Sapiens2-5B は DINOv3-7B を含む全ベースラインを全タスクで凌駕。姿勢では[[concepts/3D手姿勢推定|手]]を含む 308 点の全身推定で whole-body 姿勢推定器（ViTPose+/DWPose/RTMW）を上回る。

## 関連

- [[sources/SAPIENS2]] — 原論文
- [[entities/Humans-1B データセット]] — 事前学習コーパス
- [[concepts/人物中心視覚]] / [[concepts/自己教師あり学習]] / [[concepts/Self-Attention]]
- [[concepts/3D手姿勢推定]] — 308 キーポイントに含まれる手姿勢との接点
- [[entities/Perception Encoder]] — dense probing の比較対象。Meta の別系統の視覚言語バックボーン（[[entities/SAM 3]] が採用）
