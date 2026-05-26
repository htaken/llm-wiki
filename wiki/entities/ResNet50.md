---
title: ResNet50
type: entity
created: 2026-05-26
updated: 2026-05-26
tags: [深層学習, CNN, 画像認識, アーキテクチャ, 特徴抽出器]
sources: [1-s2.0-S0039606025009316-main.md, jimaging-11-00266.md]
aliases: [ResNet-50, Residual Network 50, 残差ネットワーク, ResNet50V2]
---

# ResNet50

残差学習（residual learning）を用いた50層の畳み込みニューラルネットワーク。He et al. (2016, CVPR "Deep residual learning for image recognition") が提案したResNetファミリーの代表的なサイズ。ImageNet等の画像分類で広く使われ、転移学習における**空間特徴抽出器（spatial feature extractor）**の定番バックボーンでもある。

## 残差学習の要点

深いネットワークでは勾配消失により学習が困難になるが、ResNetは**スキップ接続（shortcut connection）**で入力をそのまま後段に足し込み、層に「残差 `F(x)`」だけを学習させる（出力 = `F(x) + x`）。これにより非常に深いネットワークでも安定して学習でき、恒等写像を容易に表現できる。50層版（ResNet50）はボトルネック構造（1×1 → 3×3 → 1×1 畳み込み）を採用する。

## 空間特徴抽出器としての利用

最終の分類層（全結合 + softmax）を取り除くと、ResNet50は画像を**高レベルの空間特徴ベクトル（2048次元）**に写像する関数として使える。動画解析では、各フレームをこの抽出器に通して時系列の特徴ベクトル列を得て、後段の時間モデル（[[concepts/LSTM]]等）に渡す構成が一般的である。

## [[sources/開放手術スキルの時空間特徴ML評価]] での使用

Alipour et al. (2026) は ResNet50 を [[entities/CNN-LSTMハイブリッドモデル]] の空間特徴抽出器として採用した。

### fine-tuning（[[concepts/転移学習]]）

ImageNet汎用特徴を直接使うのではなく、[[entities/AIxSuture データセット]]のフレーム部分集合で fine-tuning し、ドメイン固有の空間パターンを学習させた。

- **入力解像度**: 512×512×3（[[sources/AIxSuture]]原論文の270×480より高解像度）
- **カスタムヘッド**: 元の分類層を除去し、Global Average Pooling → 全結合2層に置換。L1-L2正則化・バッチ正規化・dropout を適用、出力はsoftmax（3クラス）
- **2フェーズ訓練**:
  1. バックボーン凍結 + ヘッドのみ学習（Adam、plateauで学習率減衰、early stopping）
  2. 最終層のみ解凍し小さい学習率でfine-tuning（初期層は凍結維持し、低レベルの事前学習表現を保持）

### 特徴抽出と本番利用

fine-tuning後、分類層を再び除去して特徴抽出器とし、各動画300フレームを通して **314 × 300 × 2048** の特徴テンソルを生成。**キャッシュディレクトリに保存**して訓練反復時の冗長な再抽出を回避した。

## 縫合品質の画像2値分類での性能（Ishchenko et al.）

[[sources/縫合品質分類における転移学習の有効性評価]]では、変種の **ResNet50V2**（pre-activation型の残差ユニットを用いるV2）が、ImageNet事前学習からの8アーキテクチャ比較で**最も安定した最有力モデル**だった。

- **IOVS内面**: F1 0.931・AUC-ROC **0.959（全8モデル・全タスクで最高）**、Score_adj 0.930で1位
- **IOVS外面**: Score_adj 0.915で1位（F1 0.932、AUC-ROC 0.946）
- **ILS**: F1 0.950（**precision 1.000**）、Score_adj 0.931で1位
- COOSのみDenseNet121に譲る（連続縫合のドメインシフトのため、本文参照）

ここではAlipour et al.の用法（特徴抽出器）と異なり、**カスタム分類ヘッドを載せたエンドツーエンドの2値分類器**として、安定性考慮の独自スコアで他アーキ（Xception・DenseNet121等）を上回った。同論文はResNet50V2・DenseNet121・Xceptionを「F1・安定性ともに上位の3モデル」と総括している。

## I3D・Video Swin との位置づけ

| | [[entities/ResNet50]] | [[entities/I3D]] | [[entities/Video Swin Transformer]] |
|---|---|---|---|
| 次元 | 2D（フレーム単位） | 3D（時空間畳み込み） | 時空間Transformer |
| 時間モデル化 | **外部のLSTM/アテンションに委譲** | 内部で完結 | 内部で完結 |
| 役割 | 空間特徴抽出器 | エンドツーエンド動画分類 | エンドツーエンド動画分類 |

ResNet50は時間方向を持たない2D CNNであり、フレームごとに独立して空間特徴を抽出する。時間的依存の捕捉は後段の[[concepts/LSTM]]とアテンションが担う。この分離が、3D CNN/動画Transformerに対するメモリ効率上の利点（と引き換えのフレーム単位処理コスト）を生む。

## 関連ページ

- [[entities/CNN-LSTMハイブリッドモデル]]
- [[entities/I3D]]
- [[entities/Video Swin Transformer]]
- [[concepts/LSTM]]
- [[concepts/転移学習]]
- [[concepts/外科技術自動評価]]
- [[concepts/GradCAM]]
- [[sources/開放手術スキルの時空間特徴ML評価]]
- [[sources/縫合品質分類における転移学習の有効性評価]]
