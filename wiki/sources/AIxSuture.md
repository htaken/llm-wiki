---
title: "AIxSuture: Vision-Based Assessment of Open Suturing Skills"
type: source
created: 2026-04-11
updated: 2026-04-11
tags: [外科技術評価, 開放手術, 縫合, 深層学習, データセット, ベンチマーク]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
---

# AIxSuture: Vision-Based Assessment of Open Suturing Skills

## 書誌情報

- **著者**: Hanna Hoffmann, Isabel Funke, Philipp Peters, Danush Kumar Venkatesh, Jan Egger, Dominik Rivoir, Rainer Röhrig, Frank Hölzle, Sebastian Bodenstedt, Marie-Christin Willemer, Stefanie Speidel, Behrus Puladi
- **所属**: NCT/UCC Dresden, RWTH Aachen, CeTI (TU Dresden) ほか
- **出版**: International Journal of Computer Assisted Radiology and Surgery, 2024年3月
- **DOI**: https://doi.org/10.1007/s11548-024-03093-3
- **データセット**: https://zenodo.org/record/7940583
- **コード**: https://gitlab.com/nct_tso_public/aixsuture

## 要約

開放手術（open surgery）の縫合技術を動画から自動的に評価する初のエンドツーエンド手法を提示した論文。[[entities/AIxSuture データセット]]（314本の縫合訓練動画）を用いて、[[entities/Temporal Segment Network]]（TSN）ベースの2つのモデル（[[entities/I3D]] バックボーンと [[entities/Video Swin Transformer]] バックボーン）をベンチマークした。動画を[[entities/OSATS]]のGlobal Rating Score（GRS）に基づく3段階のスキルレベル（novice / intermediate / proficient）に分類するタスクで、最良モデル（Video Swin Tiny）はF1スコア72%、精度75%を達成し、人間の評価者と同等の性能を示した。

## キーポイント

### 背景と動機

- 低侵襲手術（MIS）ではカメラ映像が容易に取得できるため機械学習ベースの技術評価が進んでいるが、開放手術では映像取得が難しく研究が乏しい
- 従来の開放手術技術評価は手作業の特徴抽出（器具追跡、力・トルク計測等）に依存しており、追加のセンサやデータ収集が必要だった
- 動画ベースの手法は追加ハードウェア不要で臨床への導入が容易

### データセット

- 314本の縫合訓練動画（各約5分、30fps、GoPro Hero 5で鳥瞰撮影）
- VR訓練の効果を調査する研究から収集（訓練前後の動画）
- 3名の独立した評価者がOSATS（8カテゴリ）で評価、評価者間の平均Pearson相関係数 > 0.8
- GRSスコア（8〜40点）に基づき3クラスに分類:
  - Novice: GRS < 16
  - Intermediate: 16 ≤ GRS < 24
  - Proficient: GRS ≥ 24
- データ分割: 70%訓練 / 15%検証 / 15%テスト（同一学生の訓練前後動画は同じ分割内に配置）

### 手法

- **TSN（Temporal Segment Network）**: 動画をセグメントに分割し、各セグメントからスニペットを抽出してバックボーンで評価、コンセンサス層で統合
- **バックボーン1 — I3D**: Inceptionベースの3D CNN。時間方向の情報を畳み込みで処理
- **バックボーン2 — Video Swin Transformer**: ViTの拡張。時空間のスライディングウィンドウで長距離依存関係を捕捉
- 両バックボーンはKinetics400で事前学習済み
- 前処理: 5fpsでフレーム抽出、270×480にリサイズ

### 結果

| モデル | テストF1 | テスト精度 |
|--------|----------|-----------|
| I3D (64snippets, 12seg) | 0.692 ± 0.029 | 0.746 ± 0.063 |
| Video Swin Tiny (64snippets, 12seg) | 0.716 ± 0.043 | 0.732 ± 0.033 |
| Video Swin Small (best) | 0.631 ± 0.059 | 0.659 ± 0.066 |
| Video Swin Big (best) | 0.636 ± 0.032 | 0.652 ± 0.038 |

- NoviceとProficientクラスは分類が容易、Intermediateクラスが最も困難（全モデル・全評価者共通）
- 短いスニペット長の方が動作の詳細を捉え、性能が向上する傾向
- Video Swin Tinyが最も高いF1スコアを達成（クラス不均衡への頑健性も良好）
- 人間の評価者（マクロ平均F1: 0.706〜0.798）と同等の性能

### 知見と考察

- 3クラス分類は2クラス（良/不良）より難しいが、より有用なフィードバックを提供できる
- 誤分類はクラス境界（GRS=16, 24付近）で多く発生し、評価者間の不一致とも相関
- 学習率スケジューラ等の最適化は意図的に行わず、ベースラインとしての結果を提示
- データセットの制限: 訓練前後の設計上、intermediate・expert（GRS > 32）のデータが少ない

## 関連する概念・エンティティ

- [[concepts/外科技術自動評価]]
- [[entities/AIxSuture データセット]]
- [[entities/OSATS]]
- [[entities/Temporal Segment Network]]
- [[entities/I3D]]
- [[entities/Video Swin Transformer]]
