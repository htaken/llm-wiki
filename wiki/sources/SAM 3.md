---
title: "SAM 3: Segment Anything with Concepts"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [セグメンテーション, オープン語彙, 物体検出, 物体追跡, 動画, データエンジン, DETR, 基盤モデル, コンピュータビジョン, 深層学習, Meta]
sources: [585895112_1502482260871702_2839727966936571770_n.md]
aliases: [SAM3論文, Segment Anything with Concepts, SAM 3 paper]
---

# SAM 3: Segment Anything with Concepts

[[entities/SAM 3]] の原論文。**コンセプトプロンプト**（短い名詞句・画像exemplar・その組み合わせ）で画像・動画中の物体を検出・セグメント・追跡する統合モデルを提案。

## 書誌情報

- **著者**: Nicolas Carion, Laura Gustafson, Yuan-Ting Hu, Shoubhik Debnath, Ronghang Hu, Didac Suris, Chaitanya Ryali, Kalyan Vasudev Alwala, Haitham Khedr ほか（core contributor 多数、project lead: Piotr Dollár, Nikhila Ravi, Kate Saenko, Pengchuan Zhang, Christoph Feichtenhofer）
- **所属**: Meta Superintelligence Labs
- **デモ**: https://segment-anything.com
- **コード**: https://github.com/facebookresearch/sam3
- **Web**: https://ai.meta.com/sam3

## 要約

SAM 3 は **Promptable Concept Segmentation（[[concepts/Promptable Concept Segmentation]]、PCS）** という新タスクを定式化し、それを解く統合モデルである。PCS は「短い名詞句（NP）・画像exemplar・その組み合わせ」を入力とし、概念に一致する**全インスタンス**のマスクと固有IDを返す（動画では時間を越えてID保持）。従来の SAM/[[entities/SAM 2]] が扱った **Promptable Visual Segmentation（PVS、点/ボックス/マスクで1物体）** を、概念ベースの全インスタンス検出へ拡張した。

モデルは **[[entities/Perception Encoder]]（PE）バックボーンを共有する検出器（[[entities/DETR]]ベース）とトラッカー（SAM 2継承）** で構成される。認識（what）と位置特定（where）を分離する **presence head（presenceトークン）** を導入し、特に難しい負例（hard negative）で学習するときに検出精度を底上げする。

学習データは **human- and model-in-the-loop の[[concepts/データエンジン]]** で構築。AIアノテーター（NP生成・マスク提案・検証）に作業を委譲することで人手のみのパイプラインの **2倍超のスループット**を実現。高品質データ **SA-Co/HQ**（4Mユニーク NP、52Mマスク）と合成データ **SA-Co/SYN**（38M NP、1.4Bマスク）を生成し、PCS用ベンチマーク **[[entities/SA-Co]]**（207Kユニーク概念、120K画像＋1.7K動画、既存比 >50×）を公開した。

結果: LVIS zero-shot マスク AP **48.8**（従来最高 38.5）、SA-Co ベンチマークで既存手法の **2倍以上**の cgF1、PVS でも SAM 2 を上回る。H200 1枚で 100+物体の単一画像を **30ms** で処理。

## キーポイント

### PCS タスク（§2）
- 入力: 画像 or 短い動画（≤30秒）＋ コンセプトプロンプト。出力: 一致する全インスタンスのマスク・ID。
- 概念は**単純な名詞句**（名詞＋任意の修飾語）に限定。長い指示表現や推論を要するクエリは対象外（→ MLLM併用で対応、[[concepts/Promptable Concept Segmentation]] 参照）。
- 名詞句は全フレームにグローバル、画像exemplar（正/負のbbox）はフレーム単位で対話的に追加可能。
- 語彙は「視覚的にgroundableな任意の単純名詞句」で、本質的に曖昧（polysemy・主観的記述・境界曖昧性など）。SA-Co/Gold では **3人のアノテーター**で複数正解を許容する評価プロトコルを採用。

### モデルアーキテクチャ（§3, §C）
- 総パラメータ **約850M**: vision encoder 約450M ＋ text encoder 約300M（[[entities/Perception Encoder|PE]]）＋ 検出器・トラッカー 約100M。
- **検出器**: PEで画像・テキストを符号化 → exemplar encoder → **fusion encoder**（6ブロック、prompt tokensへcross-attention）→ **DETR風デコーダ**（200 object queries）。iterative box refinement / look-forward-twice / hybrid matching / DAC-DETR / Align loss を採用。mask head は MaskFormer 由来、semantic segmentation head も併設。
- **Presence token**: 「概念が画像に存在するか」を専任で予測。各 object query は `p(query一致 | 概念が存在)` のみ担当。最終スコア = presenceスコア × objectスコア。recognition と localization の分離が IL_MCC を底上げ。
- **トラッカー**: SAM 2 のエンコーダ・デコーダ＋メモリバンクを継承。検出器の出力とトラッカーの伝播マスクレットを IoU マッチングで統合。masklet detection score による時間的曖昧性解消、高信頼検出での re-prompt を行う。
- **学習4ステージ**: ①PE事前学習 → ②検出器事前学習 → ③検出器fine-tuning（presence post-training含む） → ④バックボーン凍結でトラッカー学習。

### データエンジン（§4, §D）
- 4フェーズ。Phase 1-3は画像、Phase 4は動画。各フェーズでAIの関与を増やし、人手を最難の失敗ケース（マスク修正）に集中させる。
- **Phase 1（人手検証）**: SAM 2＋既存OV検出器でマスク提案、人手で検証。4.3M image-NP対。
- **Phase 2（人手＋AI検証）**: Llama 3.2 をfine-tuneし MV（Mask Verification）/ EV（Exhaustivity Verification）の **AI verifier** 化。NP提案も Llama ベースに（hard negative も生成）。スループットほぼ2倍。+122M対。
- **Phase 3（スケール＋ドメイン拡張）**: 15ドメインへ拡大。22.4M ノードの SA-Co オントロジー（Wikidata 由来、17トップカテゴリ）で長尾・細粒度概念を採掘。+19.5M対。
- **Phase 4（動画）**: 成熟した画像SAM 3で動画特有の課題を収集。SA-Co/VIDEO = 52.5K動画・467Kマスクレット。

### データセット・指標（§5, §E）
- 学習: **SA-Co/HQ**（5.2M画像・4M NP、最大の高品質オープン語彙セグメンテーションデータ）/ **SA-Co/SYN**（合成、人手なし）/ **SA-Co/EXT**（15外部データに hard negative 付与）。動画 **SA-Co/VIDEO**（52.5K動画・24.8K NP）。
- ベンチマーク: **SA-Co**（207K NP、121K画像・動画、3M+ media-phrase対）。分割は Gold（3アノテーター）/ Silver / Bronze / Bio / VEval。
- 指標: **cgF1 = 100 × pmF1 × IL_MCC**（localizationの pmF1 と classificationの IL_MCC を統合）。信頼度0.5未満の予測を除外しキャリブレーションを強制。

### 主要結果（§6）
- **画像PCS（テキスト）**: LVIS zero-shot instance seg cgF1 で SOTA、SA-Co/Gold cgF1 54.0（人間性能の約74%）で最強ベースライン OWLv2* の2倍超。
- **exemplar**: 1 exemplar で T-Rex2 を COCO +18.3 / LVIS +10.3 / ODinW +20.5 上回る。対話的に exemplar を足すと3クリックでテキストのみ比 +21.6 cgF1。
- **動画PCS**: SA-Co/VEval で人間 pHOTA の80%超。GLEE等を大きく上回る。
- **PVS**: VOS で SAM 2 を全般的に上回り、MOSEv2 で +6.5。対話的画像セグメンテーション（SA-37）でも SAM 2 超え。
- **SAM 3 Agent**: MLLMが SAM 3 をツールとして使い複雑クエリを処理。ReasonSeg / OmniLabel / RefCOCO+ で zero-shot SOTA（Gemini 2.5 Pro併用が最高）。
- **物体カウント**: CountBench Acc 93.8%、PixMo-Count でも MLLM群に匹敵し、加えてマスクも出力。

### アブレーション・知見（§A）
- **presence head**: +1.5 cgF1、IL_MCC +0.05。
- **hard negatives**: IL_MCC 0.44→0.68 と大きく改善。
- **データ**: EXT に SYN を足して +8.8 cgF1、さらに HQ で +14.6。SYN と HQ は同様のスケーリング則を示し、**合成データでの自動ドメイン適応**（人手なし）が可能。
- **AI verifier**: EV verifier の presence スコアで +7.2、MV で +1.1。SAM 3 と人間の差の約半分を埋める。

### 限界（§B）
- 細粒度・ドメイン外概念（航空機種別、医療用語、サーマル画像など）への zero-shot 汎化が弱い（少量のfine-tuningや合成データで改善可）。
- 単純名詞句に制約（長い指示表現は MLLM併用が必要）。
- 動画推論コストが追跡物体数に線形（リアルタイム30FPSは複数GPUで並列化: 2×H200で10物体、8×H200で64物体）。

## 関連

- [[entities/SAM 3]] — 本論文が提案するモデル本体
- [[entities/SA-Co]] — 構築されたデータセット＋ベンチマーク
- [[entities/Perception Encoder]] — 共有バックボーン
- [[entities/DETR]] — 検出器アーキテクチャの基盤
- [[entities/SAM 2]] — 前身モデル（トラッカーを継承）
- [[concepts/Promptable Concept Segmentation]] — 提案タスク
- [[concepts/データエンジン]] — model/AI-in-the-loop アノテーション
- [[concepts/インスタンスセグメンテーション]] — SAM 3 が解く下流タスクの一つ
- [[entities/Sapiens2]] — 同じく Meta の視覚基盤モデル（人物中心、別系統）
