---
title: "SAPIENS2: 人物中心視覚のための高解像度Transformerファミリー"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [人物中心視覚, 基盤モデル, Vision Transformer, 自己教師あり学習, MAE, コントラスティブ学習, 姿勢推定, セグメンテーション, コンピュータビジョン, 深層学習, Meta]
sources: [2604.21681v1.md]
aliases: [Sapiens2論文, Sapiens 2]
---

# SAPIENS2: 人物中心視覚のための高解像度Transformerファミリー

[[entities/Sapiens2]] の原論文。

## 書誌情報

- **著者**: Rawal Khirodkar, He Wen, Julieta Martinez, Yuan Dong, Su Zhaoen, Shunsuke Saito
- **所属**: Meta Reality Labs
- **arXiv**: 2604.21681v1
- **コード・モデル**: https://github.com/facebookresearch/sapiens2

## 要約

[[entities/Sapiens2]] は、**人物中心視覚（[[concepts/人物中心視覚]]）** に特化した高解像度 Transformer の **モデルファミリー**（0.4B〜5B パラメータ）である。前世代 Sapiens（Khirodkar et al., 2024）を、**タスク・画像・忠実度**の3軸すべてで拡張する。ネイティブ 1K 解像度に加え、**4K をサポートする階層型バリアント**を持つ。

中核の貢献は **事前学習目的の統一**にある。低レベルな詳細（密予測向け）と高レベルな意味（ゼロショット/少ラベル向け）を同時に学ぶため、**マスク画像再構成（[[concepts/自己教師あり学習|MAE]]）と自己蒸留コントラスティブ目的を結合**する。これにより、密予測の画素忠実度を保ちつつ意味的に整理された汎用表現を獲得する（[[concepts/自己教師あり学習]]）。

Sapiens2 は前世代に対し、姿勢（+4 mAP）、身体部位セグメンテーション（+24.3 mIoU）、法線推定（角度誤差 45.6% 削減）で SOTA を更新し、さらに **pointmap（画素ごとの XYZ）・albedo 推定**という新タスクに拡張した。

## 3つの軸での貢献

### 1. Any human task（事前学習目的の統一）
- 前世代 Sapiens は MAE（Masked Image Modeling, [[concepts/自己教師あり学習|MIM]]）中心。MIM は信号・空間詳細を保つが圧縮主体で、意味の表現には中〜高程度の教師が必要。
- コントラスティブ学習（CL）は意味を注入するが、グローバル不変性目的は密予測（細かい空間詳細・測光忠実度）で劣る。
- iBOT / DINOv2 / v-JEPA 等のハイブリッドは差を縮めたが、高解像度で**表現ドリフト**（強い不変性が teacher/student を真の観測から乖離させ、色など人物密タスクに不可欠な手掛かりを損なう）が残る。
- Sapiens2 は**再構成目的（画素空間にアンカー）+ コントラスティブ目的（意味的に整理）**を結合し、ゼロショット/few-shot/全教師の各レジームと幅広い人物タスクに転移する表現を学ぶ。

### 2. Any human image（データ軸）
- **[[entities/Humans-1B データセット]]**: web 規模の約4B 画像から多段フィルタで人物中心コンテンツを抽出し、約 **10億枚**の高品質人物画像を整備（後述）。
- 事前学習ではタスクラベルや人物固有の事前知識を一切注入しない（**唯一の制約は「目立つ人物が少なくとも1人写っていること」**）。
- 後段の教師信号を前世代比 **10×**（タスクあたり約 100万ラベル規模）にスケール、合成アセットの幾何・測光品質も向上。

### 3. Highest fidelity（忠実度軸）
- 標準 1K バックボーンに加え、**4K バックボーン**を導入（タスクヘッドは 2K 解像度にデコード）。
- 4K を可能にする**階層型設計**（[[concepts/自己教師あり学習#4K 向け階層型アテンション|windowed attention]]）。
- 効率・安定性アップグレード: RMSNorm（LayerNorm 代替）、grouped-query attention（GQA）、QK-Norm、pixel-shuffle デコーダ（[[concepts/Self-Attention]] 参照）。

## キーポイント

### Humans-1B データセット（§3.1）
約4B 画像のプールから、多段フィルタで人物中心コンテンツを抽出:
- bounding box 検出 → head-pose 推定 → 美的・realism スコアリング → CLIP 特徴 → text-overlay 検出
- realism / 品質チェックに不合格な画像を除去
- 短辺で **≥384px** の人物を少なくとも1人含む画像を保持（複数人可）
- perceptual hashing + deep-feature 近傍剪定で重複除去、視覚埋め込みのクラスタリング + selective sampling でポーズ・視点・遮蔽・服装・シーン・照明のバランス調整
- 閾値・バランス上限は小規模な人手監査で較正 → 約 **1B 枚**

### 自己教師あり事前学習（§3.2）
ジョイント目的 `L = L_MAE + λ·L_CL`（詳細は [[concepts/自己教師あり学習]]）:
- **MAE**: 各ビューにマスク（マスク率 r）。エンコーダは可視トークンのみ処理、デコーダが全パッチを再構成、マスクトークン上で MSE。
- **CL**: DINOv3 ベースの student–teacher。teacher は student の EMA（非学習）。[CLS] 埋め込みを K logits に射影し、global↔global / global↔local ペアで teacher→student クロスエントロピー。
- **マルチビュー**: global 2 + local 4 crop。**global ビューには color augmentation を使わない**（MAE 再構成目的のため）。
- **マスキング**: blockwise/patchwise 混合（blockwise 確率 0.4）、**75% マスク率**、patch 16。1024×768（64×48=3072 patch）で約 2304 patch をマスク。
- 損失重み: MAE 1.0, CLS 0.4, KoLeo 0.04。teacher EMA 0.992。学習 5×10⁵ iter。

### モデルアーキテクチャ（§4, Table 1）
- 中深度ブロックは GQA、前後ブロックは標準 MHSA。FFN は SwiGLU。QK-Norm + RMSNorm で長スケジュール安定化。
- **4K 階層型アテンション**: 先頭 K 層が windowed self-attention（局所構造）→ [CLS]-guided pooling で空間ストライド √ω だけダウンサンプル → 後続 L 層が global attention。局所段の後にトークンマスキングを適用。

| モデル | 親モデル | #Params | FLOPs | hidden | layers | heads |
|---|---|---|---|---|---|---|
| Sapiens2-0.4B | Sapiens-0.3B | 0.398B | 1.260T | 1024 | 24 | 16 |
| Sapiens2-0.8B | Sapiens-0.6B | 0.818B | 2.592T | 1280 | 32 | 16 |
| Sapiens2-1B | Sapiens-1B | 1.462B | 4.715T | 1536 | 40 | 24 |
| Sapiens2-5B | — | 5.071B | 15.722T | 2432 | 56 | 32 |

Sapiens2-5B は 1K 解像度で約 15 TFLOPs、報告されている中で最大級の FLOPs を持つ ViT。

### 後段学習: 5タスク（§5）
バックボーンは固定し、軽量なタスク固有ヘッドのみ学習:
1. **姿勢推定**: top-down、**308 キーポイント**全身骨格（顔 243 + 手 40 + 体幹・下半身）。capture-studio に加え in-the-wild 100K 枚を新規アノテーション。heatmap MSE + OHEM。
2. **身体部位セグメンテーション**: **29 クラス**（前世代 28 に eyeglasses 追加）。in-the-wild 20K 枚追加。重み付き CE + Dice。
3. **Pointmap（深度）**: 画素ごとの 3D 点 P(u)∈ℝ³（カメラ系）。焦点正規化 pointmap + スカラーヘッド。合成教師。L2 + 勾配損失。
4. **法線推定**: 画素ごとの単位法線。PixelShuffle デコーダ。cosine + L2 + 勾配損失。
5. **Albedo 推定**: 画素ごとの diffuse albedo [0,1]³（relighting 向け）。合成教師。L2 + 勾配 + 空間 RGB 平均整合。

## 主要な実験結果（§6）

### 事前学習汎化: dense probing（Table 2）
バックボーン凍結 + 軽量デコーダを統一ハイパラで学習し、PE・DINOv2・DINOv3・Sapiens と比較。
- ベースライン中 **DINOv3 が姿勢・幾何で最強**（CL 目的とスケール）。Sapiens(v1) は MAE 由来で意味理解は限定的だが albedo 向けの低レベル手掛かりを保持。
- Sapiens2 は同規模で全ベースラインを上回り、**Sapiens2-5B は全タスクで全ベースラインを凌駕**（DINOv3-7B も含む）。

### タスク別 SOTA 比較
- **姿勢（Table 3, 11K test）**: Sapiens2-5B が **82.3 mAP / 85.3 mAR**。Sapiens2-0.8B が小パラメータながら大モデルを上回る。
- **セグメンテーション（Table 4, 5K test）**: Sapiens2-5B **82.5 mIoU（+24.3）**。Sapiens2-1B は同一 1K 入力でも Sapiens-1B を mIoU +27.9% 上回る（in-the-wild 教師 + 出力解像度 0.5K→1K）。
- **Pointmap（Table 5, 10K test）**: UniDepth/DUSt3R/VGGT/MoGe を全サイズで上回る。
- **法線（Table 6, 4K GT）**: Sapiens2-0.4B でも平均角度誤差 **8.63°**。5B は 6.73°。Marigold/DSINE/Sapiens/DAViD を上回る。
- **Albedo（Table 7, 10K test）**: Sapiens2-5B が MAE 0.012、PSNR 32.6 dB。feedforward で diffusion 系より高速。

### 実装（§6.1）
PyTorch + HF-Accelerate、A100 GPU、bfloat16 + FSDP、fused AdamW（warmup → cosine decay）。1024×768（1K）と 4096×3072（4K）でスクラッチ事前学習。Sapiens–0.3B/0.6B/1B にアーキ改修を施し Sapiens2–0.4B/0.8B/1B を生成。

## GitHub リポジトリの補足情報

公式リポジトリ（facebookresearch/sapiens2）には論文に明記されない実装上の事実がある:
- **Sapiens2-0.1B（0.114B）** が追加で提供される（論文 Table 1 には未掲載）。
- 提供タスクとして **human matting（α マット/前景抽出）** が挙げられている。
- ライセンスは独自の "Sapiens2 License"。Python ≥3.12 / PyTorch ≥2.7、torch + safetensors の最小依存でバックボーン推論が可能。

> **要確認（矛盾）**: リポジトリのタスク一覧は pose / segmentation / normal / pointmap / **matting** の5つを挙げるのに対し、論文（§5）の5タスクは pose / segmentation / pointmap / normal / **albedo**。matting は論文本文に記載がなく、albedo はリポジトリ概要のタスク一覧に現れない。一覧の編集時点差か、公開対象の差異の可能性。

## 関連

- [[entities/Sapiens2]] — 本論文が提案するモデルファミリー本体
- [[entities/Humans-1B データセット]] — 事前学習に用いた10億枚の人物画像コーパス
- [[concepts/人物中心視覚]] — 対象ドメイン
- [[concepts/自己教師あり学習]] — MAE + CL のハイブリッド事前学習
- [[concepts/Self-Attention]] — GQA / windowed attention / QK-Norm 等の機構
- [[concepts/3D手姿勢推定]] — 308 キーポイントに含まれる手（40点）との接点
