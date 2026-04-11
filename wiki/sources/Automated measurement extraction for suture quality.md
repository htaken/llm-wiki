---
title: "Automated measurement extraction for assessing simple suture quality in medical education"
type: source
created: 2026-04-11
updated: 2026-04-11
tags: [縫合, 深層学習, インスタンスセグメンテーション, 医学教育, 計測抽出]
sources: [Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md]
---

# Automated measurement extraction for assessing simple suture quality in medical education

## 書誌情報

- **著者**: Thanapon Noraset, Prawej Mahawithitwong, Wethit Dumronggittigule, Pongthep Pisarnturakit, Cherdsak Iramaneerat, Chanean Ruansetakit, Irin Chaikangwan, Nattanit Poungjantaradej, Nutcha Yodrabum
- **所属**: Faculty of ICT / Faculty of Medicine Siriraj Hospital, Mahidol University, タイ
- **掲載誌**: Expert Systems With Applications
- **データセット**: [Simple Suture Datasets (Google Drive)](https://codeocean.com/capsule/3182402/tree)
- **ソースコード**: [Code Ocean](https://codeocean.com/capsule/3182402/tree)
- **MSC**: 68T45

## 要約

開放創の縫合練習における最終成果物の画像から、幾何学的計測値（bite size、stitch separation、stitch orientation、knot distance、leftover length）を自動抽出するシステムを提案した論文。深層学習によるパスフェイル判定にとどまっていた先行研究と異なり、細粒度の定量的フィードバックを特殊機器なしで提供できる点が主な貢献。

2段階アプローチを採用:
1. [[concepts/インスタンスセグメンテーション]]: [[entities/Mask R-CNN]]で画像から縫合コンポーネント（wound、knot、surface、leftover）を検出・セグメンテーション
2. GroupAndMeasureアルゴリズム: [[concepts/線形割当問題]]（Jonker-Volgenant法）でインスタンスをstitch単位にグルーピングし、計測値を抽出

2つの新規データセット（[[entities/Simple Suture Datasets]]）計240画像を収集し、インスタンスセグメンテーションと物理計測のアノテーションを付与。抽出された計測値は物理的計測値と高い相関（Pearson ρ > 0.8平均）を示した。

## キーポイント

### 背景と動機

- 縫合技術の評価は指導医の時間を要し、主観的になりやすい
- 先行研究では深層学習でパスフェイル判定が可能だが（Mansour et al., 2023; Nagaraj et al., 2023）、細粒度フィードバックが欠如
- 特殊機器を用いたシステム（WKS-2RII、Kil 2019）は高コストで教室規模での展開が困難
- Frischknecht et al. (2013) はコンピュータビジョンで simple continuous suture の計測を行ったが、創の手動トレースが必要だった

### 手法

- **入力**: 縫合練習最終成果物のトップビュー画像
- **ステップ1 — インスタンスセグメンテーション**: [[entities/Mask R-CNN]] + ResNet-50/101-FPN バックボーン。COCO事前学習重みからファインチューニング。[[entities/Detectron2]]ライブラリ使用
- **ステップ2 — GroupAndMeasureアルゴリズム**:
  - Surface-Knot ペアリング → Leftover-Leftover ペアリング → Stitch構成のための最終マッチング
  - 各ペアリングはバウンディングボックス間の距離とIoUに基づくコスト行列を用い、LapJV（[[concepts/線形割当問題]]）で解く
  - 各コンポーネントを直線近似し、端点間の距離・角度で計測値を算出

### 抽出される計測値

| メトリック | 説明 |
|-----------|------|
| Wound length | 創の上端と下端の距離 |
| Left/Right bite size | Surface端点と創線の交点間の距離 |
| Stitch separation | 隣接するstitchの創線交点間の距離 |
| Stitch orientation | Surface線と創線の角度 |
| Knot distance | Knot中心とstitch-wound交点の距離 |
| Leftover length | Knotから糸の切断端までの長さ |

### データセット

[[entities/Simple Suture Datasets]]として2つのデータセットを収集:

| 項目 | Dataset 1 (Silk) | Dataset 2 (Nylon) |
|------|-------------------|-------------------|
| 糸の材質 | Silk（太い） | Nylon（細い、医療用） |
| 参加者 | Novice 145名 | Novice 20名 + Expert 15名 |
| 総画像数 | 2,050 | 142 |
| セグメンテーション注釈 | 98画像 | 142画像 |
| 物理計測注釈 | なし | 142画像 |

### 主な結果

**インスタンスセグメンテーション**:
- COCO事前学習モデルが最良（ImageNet、LVISより有意に優位、p < 0.005）
- ResNet-50-FPN と ResNet-101-FPN で有意差なし → 小さいモデルで十分
- コンポーネント別: Knot > Surface > Leftover > Wound の順に性能が高い
- Dataset 1 の AP^m: 41.61、Dataset 2: 52.76（COCO(50)）

**計測値抽出**:
- Leftover length以外のMAPE: Dataset 1で12%未満、Dataset 2で9%未満
- 物理計測値との相関（Dataset 2、予測インスタンス使用）:

| メトリック | Pearson ρ | サンプル数 |
|-----------|-----------|-----------|
| Bite size | 0.845 | 1,166 |
| Left bite size | 0.851 | 1,166 |
| Right bite size | 0.738 | 1,166 |
| Leftover length (sum) | 0.642 | 1,130 |
| Stitch separation | 0.956 | 1,022 |

**単一モデルの汎用性**: 両データセットを結合して訓練した単一モデルでも、個別モデルと同等の性能

**推論速度**: 画像あたり450ms未満（RTX 2080 Ti）、30人クラスで即時フィードバック可能

### 制限と今後の課題

- グルーピングアルゴリズムがセグメンテーションモデルから独立しており、stitch構造の情報を活用していない
- Simple interrupted suture のみ対象、他の縫合パターン（vertical interrupted、simple continuous等）への拡張が課題
- Expert vs Novice の弁別力の検証が不十分
- Leftoverのセグメンテーション・計測精度の向上が必要

## 引用

> "providing pass-fail feedback could be improved. However, it has yet to be shown that detailed feedback can be automatically derived from an image of a suturing practice."

> "the extracted metrics from both labeled instances and predicted instances had significant correlation with the physically measured metrics (p-value < 0.001)."

## 関連する概念・エンティティ

- [[concepts/インスタンスセグメンテーション]]
- [[concepts/線形割当問題]]
- [[concepts/外科技術自動評価]]
- [[entities/Mask R-CNN]]
- [[entities/Detectron2]]
- [[entities/Simple Suture Datasets]]
- [[entities/OSATS]]
