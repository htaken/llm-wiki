---
title: "Integration of spatiotemporal features into machine learning assessment of open surgical skills"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [外科技術評価, 開放手術, 縫合, 深層学習, CNN-LSTM, AIxSuture]
sources: [1-s2.0-S0039606025009316-main.md]
aliases: [Alipour et al. 2026, 時空間特徴の統合による開放手術スキル評価, CNN-LSTM open surgical skill assessment]
---

# Integration of spatiotemporal features into machine learning assessment of open surgical skills

## 書誌情報

- **著者**: Armin Alipour, Jeffrey Balian, Kevin Tabibian, Oh Jin Kwon, Nguyen Le, Areti Tillou, Peyman Benharash
- **所属**: Cardiovascular Outcomes Research Laboratories (CORELAB), David Geffen School of Medicine at UCLA; Division of Trauma and Acute Care Surgery; Division of Cardiac Surgery（いずれもUCLA）
- **出版**: *Surgery*（Elsevier）。Academic Surgical Congress で発表
- **査読受理**: 2025年12月24日 / オンライン公開: 2026年1月28日
- **ライセンス**: © 2026 The Author(s)、CC BY-NC-ND 4.0（オープンアクセス）
- **データセット**: [[entities/AIxSuture データセット]]（Hoffmann et al. 2024, [[sources/AIxSuture]]）

## 要約

[[entities/AIxSuture データセット]]（314本の開放手術縫合動画）を用いて、開放手術の縫合スキルを動画から3段階（novice / intermediate / proficient）に自動分類する新しい**ハイブリッドCNN-LSTMモデル**（[[entities/CNN-LSTMハイブリッドモデル]]）を提案した論文。fine-tuningした[[entities/ResNet50]]を空間特徴抽出器とし、双方向[[concepts/LSTM]]＋ソフトアテンション（[[concepts/時間アテンションプーリング]]）で時間特徴を統合する。マクロ平均F1 **0.82** を達成し、[[sources/AIxSuture]]原論文が報告した[[entities/I3D]]（0.69）・[[entities/Video Swin Transformer]]各種（0.63〜0.72）のベンチマークを全スキルレベルで上回った。特に最も難しい intermediate クラスで約10ポイントの改善を示した。

## キーポイント

### 背景と動機

- 開放手術のスキル評価は従来 [[entities/OSATS]] 等の直接観察に依存し、時間がかかり評価者間でばらつき、微細な技術的誤りの検出が難しい
- 機械学習による自動評価は低侵襲・ロボット手術で進む一方、開放手術は録画プロトコルの不統一・標準データセットの欠如で研究が乏しい（[[concepts/外科技術自動評価]]）
- モーショングローブや計測器具による代理指標は実手術への汎化が乏しい。動画ベースは追加センサ不要でスケーラブル
- **仮説**: 時空間特徴で訓練した深層学習モデルが、専門家評価者に匹敵する精度でスキルレベルを分類できる

### データセット

- [[entities/AIxSuture データセット]]を使用。314本（医学生・歯学生、各約5分、30fps、GoPro Hero 5、鳥瞰）
- GRS（[[entities/OSATS]]、8〜40点）に基づく3クラス: **novice (n=119, GRS<16) / intermediate (n=79, 16≤GRS<24) / proficient (n=116, GRS≥24)**
- 3名の独立評価者が8カテゴリで評価

### 手法: 空間特徴抽出器（ResNet50のfine-tuning）

[[concepts/転移学習]]ベース。ImageNet汎用特徴を直接使うのではなく、フレームの部分集合で[[entities/ResNet50]]をfine-tuningし、ドメイン固有の空間パターンを学習させる。

- **分割**: 全体の20%をheld-outテストに確保。残り80%を train 87.5% / val 12.5%（原データセット比 70:10）に層化分割
- **データジェネレータ**: 512×512にリサイズ → 拡張（水平反転・明度/コントラスト・回転[-15°,15°]・アフィン: シフト[-0.1,0.1]・スケール[0.9,1.1]・回転[-10°,10°]）→ ResNet50専用前処理 → one-hotラベルでバッチ化
  - `I_final = Preprocess(T_Augment ∘ Resize(I))`
- **アーキテクチャ**: ResNet50の分類層を除去し、Global Average Pooling → 全結合2層のカスタムヘッドに置換。L1-L2正則化・バッチ正規化・dropout で過学習抑制。出力はsoftmax（3クラス）
- **2フェーズ訓練**:
  1. ResNet50バックボーンを凍結し、ヘッドのみAdamで学習。検証plateauで学習率減衰、early stopping
  2. 最終層のみ解凍（初期層は凍結維持）し、小さい学習率でfine-tuning。同じスケジューラ/early stopping
- **学習率スケジューラ**: plateau時 `η ← η · 0.5`（patience=2エポック、η_min=1e-6）

### 手法: 分類モデル（CNN-LSTM）

[[entities/CNN-LSTMハイブリッドモデル]]の詳細はエンティティページ参照。要点:

- **時間サンプリング**: 各動画を5分（300秒）に標準化し、**1 fps（30フレームごと）で均一サンプリング → 1動画あたり300フレーム固定、ウィンドウ重複なし**
- fine-tuned ResNet50（分類層除去）で各フレームから空間特徴を抽出し、**キャッシュディレクトリに保存**して反復抽出を回避
  - 特徴テンソル: **314 × 300 × 2048**（動画 × フレーム × ResNet50特徴次元）
- **双方向LSTM**（[[concepts/LSTM]]）で時間依存を捕捉。選定理由: ①拡張時間系列の分析が本質的に必要、②長系列の選択的記憶で効率的/非効率的ワークフローを弁別、③双方向で全体文脈を捕捉
- **単一ヘッドのソフトアテンション**（[[concepts/時間アテンションプーリング]]）で重要な瞬間に動的に重み付け: `e_t = tanh(x_tᵀW + b_t)`, `α_t = softmax(e_t)`, `output = Σ α_t · x_t`
- 全結合層 → softmaxで3クラス確率

### 手法: 訓練戦略

- 80%訓練データに対し**5-fold交差検証**。各fold: 約64%（4 fold）train / 16%（1 fold）val → 5モデル
- **グリッドサーチ + ベイズ最適化**で4次元探索: 学習率 1e-6〜1e-3、dropout 0.1〜0.5、バッチサイズ 8〜32、BiLSTMユニット 64〜512
- 適応学習率、early stopping

### 結果

- **5-fold CV ROC**: AUC 0.94〜0.96、平均 **0.95 ± 0.009**（高い安定性）
- 最終モデルは train+val を結合して再訓練
- **マクロ平均precision 0.82**
- **クラス別F1**: Novice **0.91**, Intermediate **0.63**, Proficient **0.92**, マクロ平均 **0.82**
- **クラス別精度（abstract）**: novice 90.1%, intermediate 65.7%, proficient 86.3%
- **推論時間**: 約 **10.2 ± 0.4 秒/動画**
- **混同行列**: 誤分類は隣接スキルレベル間に集中し、novice↔proficientの混同はテスト全体でわずか2件 → スキル進行の**順序性（ordinal）を捉えている**

#### モデル比較（マクロF1・クラス別F1）

| モデル | Novice | Intermediate | Proficient | マクロ平均 |
|---|---|---|---|---|
| **本モデル** | **0.9126** | **0.6286** | **0.9200** | **0.8204** |
| [[entities/I3D]] | 0.8571 | 0.4030 | 0.7523 | 0.6917 |
| [[entities/Video Swin Transformer]] Tiny | 0.8373 | 0.5378 | 0.7723 | 0.7157 |
| Video Swin Small | 0.7907 | 0.3713 | 0.7317 | 0.6313 |
| Video Swin Big | 0.8357 | 0.3724 | 0.6986 | 0.6356 |

> **重要な接続**: この比較表のI3D・Swin各種の数値は、[[sources/AIxSuture]]原論文が報告したベンチマーク値とほぼ一致する（I3D 0.692, Swin Tiny 0.716, Swin Small 0.631, Swin Big 0.636）。本論文は自前で再実装するのではなく **AIxSuture公開ベンチマークに対する改善**を主張している。intermediate クラスの改善（0.63 vs I3D 0.40 / Swin 0.37〜0.54）が最大で、fine-tuning戦略 + LSTM+アテンションの時空間処理に帰している。

### 考察

- **解釈性（アテンション解析）**: 時間方向のアテンション重みを可視化すると、スキルレベルを弁別する明確なシグネチャが現れた
  - noviceでは針把持パターン・初期ツール位置といった基本的な器具操作に高いアテンション（Hoffmann et al. の知見と整合）
  - 初期の針位置決め・縫合遷移点は全レベルで高いアテンションを受け、弁別的特徴として機能
  - 移動の微小な効率性・先読み位置決め・ワークフロー連続性など、人間の casual な観察では捉えにくい熟練マーカーを捕捉
- **臨床的含意**: グローバルな成績指標ではなく、瞬間ごとの分析に基づく個別化・客観的フィードバックの可能性。「針さばきを改善せよ」ではなく、技術が逸脱した正確な瞬間を提示できる
- **信頼性**: 5-fold CVの一致（AUC ±0.009）は、人間評価者の評価者間ばらつきを超える一貫性を示唆。コンピテンシーベース教育に適合

### 限界

- **計算コスト**: 3D CNN・動画Transformerよりメモリ効率は良いが、ResNet50によるフレーム単位処理＋高次元特徴生成で大きな計算資源を要求。小規模施設ではGPU基盤が制約に
- **リアルタイム性**: LSTMの逐次処理 + フレーム単位ResNet50 + 各timestepのアテンション計算で、リアルタイム評価が困難
- **汎化性**: AIxSutureは標準化されたシミュレーション環境（一様なカメラ角度・照明、全員手袋着用）。多様な臨床環境・術中設定（臓器背景・出血・複数の手・可変フレーミング）での検証が今後必要

### 結論・今後

fine-tuned ResNet50 + LSTM + アテンションの統合により、開放手術スキルを高い予測力・信頼性で分類。今後は ①多様な録画環境での検証、②術中設定への適応（タスク無関係な動きの分離）、③モデル圧縮によるリアルタイム化、④マイルストーンベースのコンピテンシー枠組みとの統合、が課題。

## データの不整合・要確認

- **abstractのマクロF1 80.1% vs 表の82.04%**: abstractは「mean F1 score of 80.1%」とするが、結果本文・比較表は最終モデルのマクロ平均F1 = 0.8204。前者は5-fold平均、後者は結合モデルの値である可能性が高いが、論文に明示はない
- **abstractのクラス別「accuracy」（90.1/65.7/86.3%）vs 表のクラス別F1（91.26/62.86/92.00%）**: 別指標（精度/recall系 vs F1）。混同しないこと
- 利益相反欄に「P.D. received proctor fees from Atricure」とあるが、P.D.は著者リストに該当者がいない（著者頭文字: A.A./J.B./K.T./O.J.K./N.L./A.T./P.B.）。論文側の表記揺れと思われる

## 関連する概念・エンティティ

- [[sources/AIxSuture]]（同一データセットの原論文。本研究が比較対象とするベンチマークの出所）
- [[sources/OSS Challenge]]（同データセットの後続チャレンジ）
- [[entities/CNN-LSTMハイブリッドモデル]]
- [[entities/ResNet50]]
- [[entities/AIxSuture データセット]]
- [[entities/OSATS]]
- [[entities/I3D]]
- [[entities/Video Swin Transformer]]
- [[concepts/LSTM]]
- [[concepts/時間アテンションプーリング]]
- [[concepts/Self-Attention]]
- [[concepts/転移学習]]
- [[concepts/外科技術自動評価]]
