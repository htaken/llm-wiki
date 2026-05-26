---
title: Index
type: index
updated: 2026-05-26
---

# Wiki Index

## ソース
- [[sources/AIxSuture]] — 開放手術の縫合技術を動画ベースで自動評価する初のエンドツーエンド手法。AIxSutureデータセットとTSN+I3D/Video Swinベンチマーク
- [[sources/Automated measurement extraction for suture quality]] — 縫合画像からの幾何学的計測値自動抽出システム（Mask R-CNN + 線形割当）
- [[sources/SQL基礎まとめ]] — SQLの基本構文と主要概念（エイリアス、制約、INDEX、VIEW、CTE、トランザクション、ウィンドウ関数）
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]] — uv v0.5.3までの依存関係まわりの便利機能（index指定、environment markers、optional-deps、dependency-groups、build isolation）
- [[sources/AnyHand]] — RGB(-D) 3D手姿勢推定のための大規模合成データセット。共訓練でHaMeR/WiLoRをSOTAに（UCSD他、arXiv 2603.25726v2）
- [[sources/WiLoR]] — 手検出と3D再構成を統合したフルスタック手法の原論文。WHIMデータセット＋multi-scale refinement（Imperial/SJTU、CVPR25、arXiv 2409.12259v2）
- [[sources/MediaPipe ソリューション ガイド]] — GoogleのオンデバイスML スイートMediaPipe Solutionsの公式概要（ソリューション一覧・対応表・レガシー移行）
- [[sources/SAPIENS2]] — 人物中心視覚の高解像度Transformer基盤モデル（0.4B〜5B、MAE+CLハイブリッド事前学習、1K/4K、Meta、arXiv 2604.21681v1）
- [[sources/SAM 3]] — コンセプトプロンプト（名詞句・画像exemplar）で全インスタンスを検出・セグメント・追跡する統合モデル。PCSタスク＋SA-Coデータエンジン（Meta Superintelligence Labs）

## エンティティ
- [[entities/AIxSuture データセット]] — 314本の開放手術縫合訓練動画データセット（OSATS評価付き）
- [[entities/Detectron2]] — Meta AI Researchの物体検出・セグメンテーションライブラリ
- [[entities/I3D]] — Inceptionベースの3D CNN動画認識モデル
- [[entities/Mask R-CNN]] — インスタンスセグメンテーションフレームワーク（He et al., 2017）
- [[entities/OSATS]] — 外科技術の客観的評価尺度（8カテゴリ、GRS 8〜40点）
- [[entities/Simple Suture Datasets]] — Simple interrupted suture画像データセット（silk/nylon、計240画像）
- [[entities/Temporal Segment Network]] — 動画を時間セグメントに分割して行動認識するフレームワーク（TSN）
- [[entities/Video Swin Transformer]] — 時空間シフトウィンドウ機構を持つ動画Transformer
- [[entities/uv]] — Astral製の高速Pythonパッケージ・プロジェクト管理ツール（Rust製）
- [[entities/PyTorch]] — 深層学習ライブラリ。非PyPI index指定の代表例として扱う
- [[entities/PyPI]] — Python公式パッケージリポジトリ。uvのデフォルトindex
- [[entities/flash-attention]] — メモリ効率の良いAttention実装。build isolation無効化の代表例
- [[entities/AnyHand データセット]] — 大規模合成RGB-D手データセット（単一手2.5M+手物体4.1M枚）
- [[entities/HaMeR]] — ViTでMANOを直接回帰する手メッシュ復元モデル（CVPR24）
- [[entities/WiLoR]] — 手検出＋3D再構成のフルスタックモデル。multi-scale refinementでRGB SOTA（CVPR25）
- [[entities/WHIM データセット]] — 2M枚のin-the-wild手検出データセット。YouTube動画から自動アノテーション（WiLoR）
- [[entities/AnyHandNet-D]] — WiLoRに深度融合モジュールを足したRGB-Dモデル
- [[entities/MANO]] — 手のパラメトリックモデル（形状β+ポーズ）。手姿勢推定の標準表現
- [[entities/SAPIEN]] — AnyHandのレンダリング基盤となるシミュレーション環境（レイトレーシング）
- [[entities/MediaPipe]] — Google製のオンデバイスAI/MLソリューションスイート（Tasks/Model Maker/Studio、4プラットフォーム対応）
- [[entities/Sapiens2]] — Meta製の人物中心視覚基盤モデルファミリー（0.4B〜5B、1K/4K、308点姿勢・29クラスseg・法線・pointmap・albedo）
- [[entities/Humans-1B データセット]] — Sapiens2事前学習用の約10億枚高品質人物画像（4Bから多段フィルタでキュレーション）
- [[entities/SAM 3]] — コンセプトプロンプトで全インスタンスを検出・セグメント・追跡する約850Mモデル（PEバックボーン＋DETR検出器＋SAM2トラッカー、Meta）
- [[entities/SA-Co]] — SAM 3のデータセット＋ベンチマーク（HQ/SYN/EXT/VIDEO、207Kユニーク概念、既存比>50×）
- [[entities/Perception Encoder]] — SAM 3の共有バックボーン。整合した画像・テキストエンコーダの視覚言語Transformer（PE、Meta）
- [[entities/DETR]] — object queryと二部マッチングで物体検出を集合予測化するTransformer。SAM 3検出器の基盤
- [[entities/SAM 2]] — 点/ボックス/マスクで1物体を画像・動画でセグメントするSAM 3の前身（PVS、Meta）

## コンセプト
- [[concepts/インスタンスセグメンテーション]] — 画像中の各オブジェクトを個別にセグメンテーションするタスク
- [[concepts/Self-Attention]] — Transformer の中核機構。系列内の全要素間の関連度を動的に計算して情報を集約する
- [[concepts/外科技術自動評価]] — 機械学習による外科手術スキルの客観的・自動的評価
- [[concepts/転移学習]] — ソースドメインで学習した特徴表現をターゲットドメインに再利用する手法
- [[concepts/線形割当問題]] — コスト最小の一対一マッチングを求める最適化問題
- [[concepts/SQL制約]] — PRIMARY KEY / FOREIGN KEY / CHECK によるDBレイヤでのデータ整合性保証
- [[concepts/INDEX]] — B+Tree等を用いた検索高速化機構と書き込みコストのトレードオフ
- [[concepts/VIEW]] — 保存されたSELECT文。複雑SQLの隠蔽と権限制御
- [[concepts/CTE]] — WITH句による一時的な名前付きテーブル。クエリの段階分割
- [[concepts/トランザクション]] — 複数SQLをひとまとまりとして扱う仕組みとACID特性
- [[concepts/ウィンドウ関数]] — 行を残したまま集約値を付与する関数（PARTITION BY / ROW_NUMBER / RANK）
- [[concepts/テーブルエイリアスとJOIN]] — テーブル別名の使い方と自己JOIN
- [[concepts/SQLテーブル削除コマンド]] — DROP / TRUNCATE / DELETE の違い
- [[concepts/Environment Markers]] — PEP 508の環境マーカ。OS/アーキテクチャ別に依存を切り替える
- [[concepts/Optional Dependencies]] — `[project.optional-dependencies]` によるextras。uv 0.5.3でconflicts宣言が可能に
- [[concepts/Dependency Groups]] — uv 0.4.27で導入された複数の開発用依存グループ
- [[concepts/Build Isolation]] — PEP 517の隔離ビルドと、`no-build-isolation-package` / `dependency-metadata` による制御
- [[concepts/3D手姿勢推定]] — RGB(-D)から手の3Dポーズ・形状を推定するタスク。MANO回帰とTransformerの系譜
- [[concepts/手検出・ローカライゼーション]] — 画像中の手のbbox・左右を検出するタスク。FCN+PANet+anchor-freeでリアルタイム化
- [[concepts/合成データとsim-to-realギャップ]] — 合成データによるスケーリングと実世界転移の課題
- [[concepts/RGB-D深度融合]] — RGBと深度を双方向クロスアテンションで統合し深度方向の曖昧性を解消
- [[concepts/自己教師あり学習]] — MIM（MAE）とCLの2系統、およびSapiens2のMAE+CLハイブリッド統一目的
- [[concepts/人物中心視覚]] — 人間を対象とする視覚タスク群と基盤モデルのスケール3軸
- [[concepts/Promptable Concept Segmentation]] — 名詞句・画像exemplarで全インスタンスを検出・セグメント・追跡するタスク（PCS、SAM 3）。PVSとの対比
- [[concepts/データエンジン]] — モデル・人間・AIアノテーターのループで注釈データを反復生成する仕組み（AI verifierでスループット2倍）
