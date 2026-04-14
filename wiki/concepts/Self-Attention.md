---
title: Self-Attention
type: concept
created: 2026-04-13
updated: 2026-04-13
tags: [深層学習, Transformer, Attention機構, ニューラルネットワーク]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md]
aliases: [自己注意機構, Scaled Dot-Product Attention]
---

# Self-Attention

入力系列の各要素が、同じ系列内の他の全要素との関連度を動的に計算し、情報を加重集約する機構。Vaswani et al. (2017) の "Attention Is All You Need" で提案されたTransformerアーキテクチャの中核をなす。

畳み込み（CNN）が固定サイズのカーネルで近傍のみを参照するのに対し、Self-Attentionは系列の任意の位置から直接情報を引ける点が本質的な違いである。

## Query, Key, Value

入力系列 X（N×d）から3つの射影行列を通じてベクトルを生成する:

- **Query (Q = X × W_Q)**: 「何を探しているか」— 各要素が他の要素に対して発する問い合わせ
- **Key (K = X × W_K)**: 「自分は何を持っているか」— 各要素がQueryに対して提示する照合情報
- **Value (V = X × W_V)**: 「実際に渡す情報」— Attentionの重みで加重和される実体

## 計算の流れ

`Attention(Q, K, V) = softmax(QK^T / √d_k) × V`

1. **類似度計算 (`QK^T`)**: 各要素のQuery（何を探しているか）と全要素のKey（何を持っているか）の内積を取り、N×Nの類似度行列を得る。内積が大きいほど、その要素ペアの関連が強いことを意味する。
2. **スケーリング (`/ √d_k`)**: d_k（Keyの次元数）の平方根で割る。次元数が大きいと内積の値も大きくなり、softmaxの出力が極端な分布（ほぼone-hot）になって勾配が消失する。スケーリングにより安定した学習を保つ。
3. **正規化 (`softmax`)**: 類似度行列の各行にsoftmaxを適用し、合計1.0の注目度の重みに変換する。どの要素にどれだけ注目するかの確率分布を得る。
4. **加重和 (`× V`)**: 注目度の重みでValueを加重平均し、文脈を反映した新しい表現を生成する。各要素は、関連の強い他の要素の情報を多く取り込んだベクトルに変換される。

## Multi-Head Attention

単一のAttentionではなく、複数の「ヘッド」で並列にAttentionを計算する。各ヘッドは独立したW_Q, W_K, W_Vを持ち、異なる観点からの関係性（例: 時間的な流れ、空間的関係、動作の速度変化など）を同時に捕捉する。各ヘッドの出力を結合し、線形変換で元の次元に戻す。

## Self-Attention vs Cross-Attention

Self-AttentionとCross-Attentionの違いはQ, K, Vの出所にある。計算式自体は同一である:

| 種類 | Q の出所 | K, V の出所 | 用途 |
|------|----------|-------------|------|
| Self-Attention | 入力A | 入力A | 系列内の要素間関係の学習 |
| Cross-Attention | 入力A | 入力B | 異なる情報源間の照合 |

Cross-Attentionは「入力Aの各要素が、入力Bのどの要素から情報を引くか」を計算する。機械翻訳（訳文→原文の参照）、画像生成（ノイズ画像→テキストプロンプトの参照）等で使用される。

Transformerの典型的なEncoder-Decoder構造では:
- **Encoder**: Self-Attentionで入力系列の内部関係を理解
- **Decoder**: Masked Self-Attentionで生成済み系列の内部関係を理解 + Cross-AttentionでEncoderの出力を参照

## 計算量と効率化

標準的なSelf-Attentionは全要素間で類似度を計算するため、計算量はO(N²)となる。動画のように系列長が大きい入力では計算が膨大になる。[[entities/Video Swin Transformer]]のシフトウィンドウ機構は、Attentionを局所ウィンドウ内に制限しつつウィンドウをシフトすることで、O(N)の計算量でグローバルな情報伝播を実現する効率化手法である。

## 関連ページ

- [[entities/Video Swin Transformer]]
- [[entities/I3D]]
- [[concepts/転移学習]]
- [[concepts/外科技術自動評価]]
- [[sources/AIxSuture]]
