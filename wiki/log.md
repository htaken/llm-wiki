---
title: Log
type: log
updated: 2026-05-26
---

# 操作ログ

## [2026-05-26] update | OSS Challenge チーム別成否分析

クエリ「各チームのうまくいった点・うまくいかなかった点」への回答を、`wiki/sources/OSS Challenge.md` に「チーム別 成否分析」セクションとして追記（主要結果と考察の間）。論文Discussionに基づき全チーム（ベースライン含む）を ✅/❌ で整理し、全体を貫く4つの教訓を付記。

## [2026-05-26] ingest | OSS: Open Suturing Skills Challenge 2024-2025

`raw/2605.22200v1.md`（Hoffmann et al., NCT Dresden / RWTH Aachen ほか）を取り込み。開放手術縫合スキルの動画ベース自動評価を競う初の専用チャレンジ（MICCAI 2024/2025 EndoVisサブチャレンジ）の総括論文。既存の[[sources/AIxSuture]]の直接の後続研究にあたる。3タスク（GRS 4クラス分類／OSATS 8カテゴリ予測／キーポイントトラッキング）、X3D-Mベースライン、9チーム17モデルの比較が要点。汎用動画モデルがトラッキング系を上回ること、product-bias仮説、OSATS予測の難しさ、トラッキングの困難さといった知見を既存の外科技術自動評価・AIxSuture・OSATSページに統合した。

作成したページ:
- `wiki/sources/OSS Challenge.md` — ソース要約（チャレンジ設計、評価指標、データセット拡張、ベースライン、全参加チーム手法、2024/2025の結果、product-bias考察、結論）
- `wiki/entities/X3D.md` — ベースラインの効率的3D CNN（X3D-M、Kinetics-400事前学習、両年で最高性能）
- `wiki/entities/Surgformer.md` — TimeSFormer拡張の外科動画Transformer（OSS 2024 Syangcw）
- `wiki/concepts/HOTA.md` — 検出/局所化/関連付けを統合するMOT指標（Task 3でユークリッド距離版）

更新したページ:
- `wiki/entities/AIxSuture データセット.md` — OSSチャレンジでの拡張節（expert追加収録、データセット版テーブル、2025追加、Task 3キーポイント注釈、3vs4クラスの差異）
- `wiki/entities/OSATS.md` — 8カテゴリの列挙、GRSベース3クラス（AIxSuture）vs 4クラス（OSS, expert新設）の対比、OSATS予測の難しさとICC値、GRSをaliasに追加
- `wiki/concepts/外科技術自動評価.md` — OSSベンチマーク知見（動画モデルvsトラッキング、product-bias仮説、product/process、Task 3トラッキング困難）を追記
- `wiki/sources/AIxSuture.md` — 後続研究としてOSS Challengeをリンク
- `wiki/index.md` — ソース1・エンティティ2・コンセプト1を追加

## [2026-05-26] ingest | SAM 3: Segment Anything with Concepts

`raw/585895112_1502482260871702_2839727966936571770_n.md`（Carion et al., Meta Superintelligence Labs）を取り込み。コンセプトプロンプト（名詞句・画像exemplar）で画像・動画中の概念に一致する全インスタンスを検出・セグメント・追跡する統合モデル SAM 3 の原論文。新タスク PCS の定式化、PEバックボーン共有のDETR検出器＋SAM2トラッカー、presence head、AIアノテーターを用いたデータエンジン、SA-Coデータセット・ベンチマークが要点。Meta繋がりの既存 Sapiens2（PEを比較ベースラインに含む）、既存のインスタンスセグメンテーション概念と接続した。ユーザー確認により DETR・SAM 2 も独立エンティティ化（最も網羅的な範囲）。

作成したページ:
- `wiki/sources/SAM 3.md` — ソース要約（PCSタスク、アーキ、データエンジン4フェーズ、SA-Co、主要結果、アブレーション、限界）
- `wiki/entities/SAM 3.md` — モデル本体（約850M、検出器/presence token/トラッカー、4ステージ学習、性能）
- `wiki/entities/SA-Co.md` — データセット＋ベンチマーク（HQ/SYN/EXT/VIDEO、Gold/Silver/Bronze/Bio/VEval、cgF1指標、オントロジー）
- `wiki/entities/Perception Encoder.md` — 共有バックボーン（PE、エンコーダ比較表）
- `wiki/entities/DETR.md` — 検出器基盤（object query集合予測、MDETR、SAM 3採用の変種）
- `wiki/entities/SAM 2.md` — 前身モデル（PVS、Hiera、メモリバンク、SAM系譜表）
- `wiki/concepts/Promptable Concept Segmentation.md` — PCSタスク定義、PVSとの対比、曖昧性、MLLM拡張
- `wiki/concepts/データエンジン.md` — model/AI-in-the-loop アノテーション、MV/EV verifier、4フェーズ、スループット

更新したページ:
- `wiki/entities/Sapiens2.md` — dense probing比較のPEをリンク化、関連にPerception Encoder追加
- `wiki/concepts/インスタンスセグメンテーション.md` — DETR系/SAM 3を代表手法・関連に追記
- `wiki/index.md` — ソース1・エンティティ5・コンセプト2を追加

## [2026-05-26] ingest | SAPIENS2: 人物中心視覚のための高解像度Transformerファミリー

`raw/2604.21681v1.md`（Khirodkar et al., Meta Reality Labs）を取り込み。人物中心視覚の高解像度Transformer基盤モデル Sapiens2 の原論文。GitHub リポジトリ（facebookresearch/sapiens2）も WebFetch で調査し、論文未記載の補足（追加の0.1Bモデル、human mattingタスク、Sapiens2ライセンス、Python≥3.12/PyTorch≥2.7・最小依存）を取得。人物中心視覚＝外科AI／手姿勢推定とは別の新領域だが、308点姿勢に手40点を含む点・Self-Attention（GQA/windowed/QK-Norm）で既存ページと接続した。

作成したページ:
- `wiki/sources/SAPIENS2.md` — ソース要約（3軸の貢献、Humans-1B、MAE+CL目的、アーキ、5タスク後段学習、全結果表、リポジトリ補足）
- `wiki/entities/Sapiens2.md` — モデルファミリー本体（4サイズ＋0.1B/4K、アーキ特徴、対応タスク、ライセンス、比較）
- `wiki/entities/Humans-1B データセット.md` — 約10億枚の人物画像コーパス（4Bから多段フィルタ）
- `wiki/concepts/自己教師あり学習.md` — MIM（MAE/BEiT）とCL（DINO系）の2系統、Sapiens2のハイブリッド統一目的、マスキング、4K階層型アテンション
- `wiki/concepts/人物中心視覚.md` — 人間対象タスク群、prior-free vs 事前知識注入型、スケール3軸の比較表

更新したページ:
- `wiki/concepts/Self-Attention.md` — 高解像度向け階層型アテンション、GQA/QK-Normの効率・安定化変種を追記、関連リンク追加
- `wiki/concepts/3D手姿勢推定.md` — 全身308点（手40点）を扱うSapiens2との関係を追記、関連リンク追加
- `wiki/index.md` — ソース1・エンティティ2・コンセプト2を追加

検出した矛盾（要確認）:
- 論文§5の5タスクは pose/seg/pointmap/normal/**albedo** だが、GitHubリポジトリのタスク一覧は pose/seg/normal/pointmap/**matting**。matting は論文未記載、albedo はリポジトリ概要のタスク一覧に未掲載。各ページに併記。

## [2026-05-26] ingest | MediaPipe ソリューション ガイド | Google AI Edge

`raw/MediaPipe ソリューション ガイド    Google AI Edge.md`（Google AI Edge 公式ドキュメント）を取り込み。MediaPipe Solutions スイートの概要カタログページ。元クリッピングではプラットフォーム対応表のチェックマークが欠落していたため、live ページ（ai.google.dev）を WebFetch で参照し対応表を復元。既存 Wiki の手姿勢推定領域で MediaPipe が「軽量な既存手検出ベースライン」として無リンク参照されていたため、エンティティ化して接続した。

作成したページ:
- `wiki/sources/MediaPipe ソリューション ガイド.md` — ソース要約（構成要素、全16ソリューションのプラットフォーム対応表、レガシー移行表）
- `wiki/entities/MediaPipe.md` — Google製オンデバイスMLスイート（Tasks/Model Maker/Studio、沿革、WiLoR比較での位置づけ）

更新したページ:
- `wiki/concepts/手検出・ローカライゼーション.md` — 無リンクだった「MediaPipe」を [[entities/MediaPipe]] にリンク化、関連リンク追加
- `wiki/sources/WiLoR.md` — 本文の MediaPipe 言及を [[entities/MediaPipe]] にリンク化
- `wiki/index.md` — ソース1・エンティティ1を追加

## [2026-05-26] ingest | WiLoR: End-to-end 3D Hand Localization and Reconstruction in-the-wild

`raw/2409.12259v2.md`（Potamias et al., Imperial College London / SJTU, CVPR 2025）を取り込み。手検出と3D手再構成を統合したフルスタック手法 WiLoR の原論文。既存の WiLoR/HaMeR/MANO/3D手姿勢推定 ページは AnyHand 論文経由の二次情報だったため、本ingestで一次ソースの詳細（検出パイプライン、WHIMデータセット、multi-scale refinement、4D結果）を肉付け。

作成したページ:
- `wiki/sources/WiLoR.md` — ソース要約（2段パイプライン、WHIM、検出/再構成アーキ、結果、アブレーション、限界）
- `wiki/entities/WHIM データセット.md` — 2M枚のin-the-wild手検出データセット（YouTube自動アノテーション、従来比100×）
- `wiki/concepts/手検出・ローカライゼーション.md` — FCN+PANet+anchor-freeのリアルタイム手検出タスク

更新したページ:
- `wiki/entities/WiLoR.md` — 一次ソースの詳細を全面追記、sources に 2409.12259v2.md を追加
- `wiki/concepts/3D手姿勢推定.md` — refinement詳細・検出統合と4Dコヒーレンスを追記、source追加
- `wiki/entities/HaMeR.md` — WiLoR論文でのベースライン比較（HaMeRを上回る）を追記、source追加
- `wiki/entities/MANO.md` — WHIMのMANOフィッティング（生体力学制約+PCA事前分布）を追記、source追加
- `wiki/index.md` — 新規3ページを追加、WiLoRの要約をフルスタックに更新

## [2026-05-26] ingest | AnyHand: A Large-Scale Synthetic Dataset for RGB(-D) Hand Pose Estimation

`raw/2603.25726v2.md`（Chen Si et al., UCSD/Lambda/Imperial/NTU）を取り込み。RGB(-D) 3D手姿勢推定のための大規模合成データセットAnyHandの論文。「データの質・量・多様性 > アーキテクチャの複雑さ」を主張し、HaMeR/WiLoRをアーキテクチャ固定のまま合成データで共訓練してSOTAを更新。コンピュータビジョン（手姿勢推定）という新領域を開設。

作成したページ:
- `wiki/sources/AnyHand.md` — ソース要約（生成パイプライン、結果、Zhao et al.比較、データ統計の不整合を記載）
- `wiki/entities/AnyHand データセット.md` — 合成RGB-Dデータセット（Single/Interact 2分岐）
- `wiki/entities/HaMeR.md` — ViTでMANO回帰する手メッシュ復元モデル（CVPR24）
- `wiki/entities/WiLoR.md` — refinement付き手姿勢推定モデル、AnyHandNet-Dの基盤（CVPR25）
- `wiki/entities/AnyHandNet-D.md` — WiLoR + 深度融合モジュールのRGB-Dモデル
- `wiki/entities/MANO.md` — 手のパラメトリックモデル
- `wiki/entities/SAPIEN.md` — レンダリング基盤のシミュレーション環境
- `wiki/concepts/3D手姿勢推定.md` — タスクの概念ページ（手法の系譜、ベンチマーク、指標）
- `wiki/concepts/合成データとsim-to-realギャップ.md` — 合成データのスケーリングと転移課題
- `wiki/concepts/RGB-D深度融合.md` — 双方向クロスアテンションによるモダリティ融合

更新したページ:
- `wiki/concepts/Self-Attention.md` — Cross-Attentionのマルチモーダル応用例としてAnyHandNet-Dを追記、関連リンク追加
- `wiki/index.md` — 新規ページを一覧に追加

検出した矛盾（要確認）:
- AnyHandの枚数が論文内で不整合（概要/Table1: Single 2.5M/Interact 4.1M ⇔ §3.2/Table7: Single 2.1M/Interact 4.2M）。各ページに併記して明示。

## [2026-05-18] update | AIxSuture が取得する動画情報の整理

raw論文を精査し、AIxSutureデータセットが実際に取得している動画情報（撮影セットアップ、メタデータ、video-only設計、前処理仕様）と、意図的に取得していない情報（センサー類・各種アノテーション）を整理して追記。

更新したページ:
- `wiki/sources/AIxSuture.md` — 「取得される動画情報の詳細」セクションを追加（撮影/メタデータ/非取得情報/前処理）
- `wiki/entities/AIxSuture データセット.md` — 「取得情報の範囲」「モデル入力時の前処理」セクションを追加、概要表にモダリティ行を追加

## [2026-05-11] ingest | Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能

`raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md`（Zenn記事、Turing Motors、2024-12-09）を取り込み。uvの依存関係まわりの機能（非PyPI index指定、environment markers、optional-dependencies + conflicts、dependency-groups、build isolation制御）を整理。Python/パッケージ管理の新規ドメインを開設。

作成したページ:
- `wiki/sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md` — ソース要約
- `wiki/entities/uv.md` — Astral製のPython管理ツール
- `wiki/entities/PyTorch.md` — 非標準index・アクセラレータ別wheelの代表例
- `wiki/entities/flash-attention.md` — build isolation無効化の代表例
- `wiki/entities/PyPI.md` — デフォルトのPythonパッケージindex
- `wiki/concepts/Environment Markers.md` — PEP 508のmarker式（sys_platform等）
- `wiki/concepts/Optional Dependencies.md` — extras + conflicts宣言（v0.5.3）
- `wiki/concepts/Dependency Groups.md` — 複数dev-dependencies（v0.4.27）
- `wiki/concepts/Build Isolation.md` — PEP 517、no-build-isolation-package、dependency-metadata

更新したページ:
- `wiki/index.md` — uv関連の新規ページを追加

## [2026-05-11] ingest | SQL基礎まとめ

`raw/sql-basic.md` を取り込み。SQL初学者向けの基礎ノート（エイリアス、制約、削除コマンド、INDEX、VIEW、CTE、トランザクション、数値関数、ウィンドウ関数）を体系化。既存Wikiは外科AI領域のみだったため、SQL/RDBという新領域のページ群を新規作成した。

作成したページ:
- `wiki/sources/SQL基礎まとめ.md` — ソース要約（全9トピックの目次付き）
- `wiki/concepts/SQL制約.md` — PRIMARY KEY / FOREIGN KEY / CHECK
- `wiki/concepts/INDEX.md` — B+Tree、O(log n)、読み書きトレードオフ
- `wiki/concepts/VIEW.md` — 保存SELECT、権限制御、CTEとの違い
- `wiki/concepts/CTE.md` — WITH句、段階分割、VIEWとの違い
- `wiki/concepts/トランザクション.md` — BEGIN/COMMIT/ROLLBACK、ACID特性
- `wiki/concepts/ウィンドウ関数.md` — OVER句、PARTITION BY、ROW_NUMBER、RANK
- `wiki/concepts/テーブルエイリアスとJOIN.md` — 別名記法、自己JOIN
- `wiki/concepts/SQLテーブル削除コマンド.md` — DROP / TRUNCATE / DELETE 比較

更新したページ:
- `wiki/index.md` — SQL関連ページを一覧に追加

## [2026-04-13] update | AIxSuture 手法詳細の充実

AIxSutureの手法に関する深掘り（TSNの仕組み、I3D vs Video Swinの違い、転移学習、Self-Attention）を基にWikiを充実。

作成したページ:
- `wiki/concepts/Self-Attention.md` — Attention機構の概念ページ（Q/K/V、Multi-Head、Cross-Attention含む）
- `wiki/concepts/転移学習.md` — 転移学習の概念ページ（Kinetics400→外科動画の文脈）

更新したページ:
- `wiki/entities/Temporal Segment Network.md` — 数値例、訓練/評価時の違い、コンセンサス層の詳細を追記
- `wiki/entities/I3D.md` — Inflation概念、重み初期化、特性を追記
- `wiki/entities/Video Swin Transformer.md` — シフトウィンドウ機構の詳細を追記
- `wiki/concepts/外科技術自動評価.md` — CNN vs Transformerのトレードオフを追記
- `wiki/index.md` — 新規ページを追加

## [2026-04-11] ingest | Automated measurement extraction for suture quality

Noraset et al. の縫合画像からの計測値自動抽出論文を取り込み。Mask R-CNNによるインスタンスセグメンテーション + 線形割当アルゴリズムで幾何学的計測値を抽出。

作成したページ:
- `wiki/sources/Automated measurement extraction for suture quality.md` — ソース要約
- `wiki/entities/Mask R-CNN.md` — インスタンスセグメンテーションフレームワーク
- `wiki/entities/Detectron2.md` — Meta AIのCV ライブラリ
- `wiki/entities/Simple Suture Datasets.md` — 縫合画像データセット
- `wiki/concepts/インスタンスセグメンテーション.md` — CVタスクの概念ページ
- `wiki/concepts/線形割当問題.md` — グルーピングアルゴリズムの基盤概念

更新したページ:
- `wiki/entities/OSATS.md` — 計測値ベース評価との関連を追記
- `wiki/concepts/外科技術自動評価.md` — 計測値抽出アプローチを追記
- `wiki/index.md` — 新規ページを一覧に追加

## [2026-04-11] ingest | AIxSuture: Vision-Based Assessment of Open Suturing Skills

Hoffmann et al. (2024) の論文を取り込み。開放手術の縫合技術を動画から自動評価する初のエンドツーエンド手法。

作成したページ:
- `wiki/sources/AIxSuture.md` — ソース要約
- `wiki/entities/AIxSuture データセット.md` — 314本の縫合訓練動画データセット
- `wiki/entities/OSATS.md` — 外科技術の客観的評価尺度
- `wiki/entities/Temporal Segment Network.md` — TSNフレームワーク
- `wiki/entities/Video Swin Transformer.md` — 動画Transformerモデル
- `wiki/entities/I3D.md` — 3D CNNモデル
- `wiki/concepts/外科技術自動評価.md` — 自動技術評価の概念ページ

## [2026-04-05] update | Wiki初期化

Wiki構造を作成。ディレクトリ、CLAUDE.md（スキーマ）、index.md、log.mdを配置。
