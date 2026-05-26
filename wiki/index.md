---
title: Index
type: index
updated: 2026-05-26
---

# Wiki Index

## ソース
- [[sources/AIxSuture]] — 開放手術の縫合技術を動画ベースで自動評価する初のエンドツーエンド手法。AIxSutureデータセットとTSN+I3D/Video Swinベンチマーク
- [[sources/OSS Challenge]] — 開放手術縫合スキルの動画ベース評価の初の専用チャレンジ（MICCAI 2024-2025）。GRS分類・OSATS予測・キーポイントトラッキングの3タスク
- [[sources/Automated measurement extraction for suture quality]] — 縫合画像からの幾何学的計測値自動抽出システム（Mask R-CNN + 線形割当）
- [[sources/SQL基礎まとめ]] — SQLの基本構文と主要概念（エイリアス、制約、INDEX、VIEW、CTE、トランザクション、ウィンドウ関数）
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]] — uv v0.5.3までの依存関係まわりの便利機能（index指定、environment markers、optional-deps、dependency-groups、build isolation）
- [[sources/AnyHand]] — RGB(-D) 3D手姿勢推定のための大規模合成データセット。共訓練でHaMeR/WiLoRをSOTAに（UCSD他、arXiv 2603.25726v2）
- [[sources/WiLoR]] — 手検出と3D再構成を統合したフルスタック手法の原論文。WHIMデータセット＋multi-scale refinement（Imperial/SJTU、CVPR25、arXiv 2409.12259v2）
- [[sources/MediaPipe ソリューション ガイド]] — GoogleのオンデバイスML スイートMediaPipe Solutionsの公式概要（ソリューション一覧・対応表・レガシー移行）
- [[sources/SAPIENS2]] — 人物中心視覚の高解像度Transformer基盤モデル（0.4B〜5B、MAE+CLハイブリッド事前学習、1K/4K、Meta、arXiv 2604.21681v1）
- [[sources/SAM 3]] — コンセプトプロンプト（名詞句・画像exemplar）で全インスタンスを検出・セグメント・追跡する統合モデル。PCSタスク＋SA-Coデータエンジン（Meta Superintelligence Labs）
- [[sources/開放手術スキルの時空間特徴ML評価]] — AIxSutureデータセットにCNN-LSTMハイブリッド（fine-tuned ResNet50 + BiLSTM + アテンション）を適用し、マクロF1 0.82でI3D/Swinベンチマークを上回る（UCLA, Alipour et al. 2026）
- [[sources/縫合品質分類における転移学習の有効性評価]] — 縫合結果画像から品質を2値分類。8つのImageNet事前学習CNNを5-fold CV比較、安定性考慮スコア+GradCAM。F1>0.90（IOVS/ILS）（Ishchenko et al., J. Imaging 2025）
- [[sources/ExpOS]] — WiLoR 3D手再構成＋MS-TCN++＋多頭アテンション＋SHAPで開放手術スキルを解釈可能に回帰評価。r=0.778（筋膜閉鎖）。研究計画の「未採掘の継ぎ目」を占有した最重要先行研究（Papo et al. Technion, arXiv 2605.23653）
- [[sources/開放手術縫合スキルの画像ベース計測]] — シミュレータ膜下カメラの針運動から手作り幾何指標を抽出する純・processアプローチ。新規4指標で研修医 vs 指導医を弁別。「follow the curvature of the needle」をoperationalize（Kil et al. Clemson, J Surg Ed 2024）
- [[sources/手姿勢推定による開放手術トレーニングフィードバックの自動化]] — 2D手姿勢＋スキルプロキシで開放手術技量を評価。ジェスチャーセグメンテーションSOTA 88.35%、per-gestureのactionable feedback。ExpOSの2D前身（Bkheet et al. Technion/Laufer研, arXiv 2211.07021）
- [[sources/AI手追跡による心臓胸部外科スキルの客観的評価]] — 鳥瞰MediaPipe palm軌跡のキネマティクス（velocity/pathlength/jerk）が経験年数予測でOSATS・手術時間を上回る。主張#2への最大の新脅威だが経験年数対象・非公開・palmのみ（Atazadah et al. Leiden/Amsterdam, ICVTS 2026, ivag048）
- [[sources/縫合サブスキル間の関係性を捉えた自動評価]] — 縫合を6 EASE サブスキルに分解しGATで関係をモデル化、video+kinematics融合で同時評価。主張#4の最近接だがprocessのサブスキル分解でproductは分けず・VRロボット（Cui et al. USC, npj Digital Medicine 2024）
- [[sources/人間の視覚的説明によるAIスキル評価のバイアス緩和]] — SAISの過小/過大評価バイアス（人口統計サブコホート間NPV/PPV格差）を実証しTWIXで緩和。主張#3防御に必読（人口統計バイアス≠product-bias）＋ショートカット検証法（Kiyasseh et al. Caltech/USC, npj Digital Medicine 2023）
- [[sources/外科3D手姿勢推定のマルチビューパイプラインとベンチマーク]] — training-freeなtop-downマルチビュー3D手姿勢パイプライン＋68k フレーム外科ベンチマーク。単眼の難所トライアドを整理しマルチビューを推奨。feasibilityと公開ベンチマーク柱（Fischer et al. Balgrist/UZH/ETH, IJCARS 2026, arXiv 2601.15918）

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
- [[entities/X3D]] — 2D CNNを多軸で段階拡張した効率的3D CNN。OSSチャレンジのベースライン（X3D-M）
- [[entities/Surgformer]] — TimeSFormer拡張の外科動画Transformer（HTA+ASA）。OSS 2024 Syangcwが採用
- [[entities/ResNet50]] — 残差学習の50層2D CNN。空間特徴抽出器の定番。Alipour et al.でAIxSutureにfine-tuning
- [[entities/CNN-LSTMハイブリッドモデル]] — ResNet50 + 双方向LSTM + アテンションで空間と時間を分離する開放手術スキル分類モデル（マクロF1 0.82）
- [[entities/MS-TCN++]] — 多段拡張時間畳み込みのアクションセグメンテーションネット。ExpOSの時間バックボーン（特徴抽出器）（Li et al. 2020）
- [[entities/RoHans]] — 手術室向けの頑健な手検出。YOLO検出器をpseudo-label自己訓練でrefine。ExpOSでWiLoRの前段（Papo et al. 2025、同Laufer研）
- [[entities/YOLO]] — one-stageリアルタイム物体検出。外科映像の器具・手検出のワークホース（Ultralytics）
- [[entities/Open Surgery Simulation データセット]] — Goldbraikh et al.の開放手術シミュレーション動画＋kinematicデータ（100動画/25臨床医）。Bkheet et al.が2D手姿勢を追加注釈。OSS Challengeとは別物
- [[entities/EASE]] — 縫合をneedle handling/driving/withdrawalの6サブスキルに分解する評価尺度。全項目がprocess側でproductノードを持たない（OSATSとの決定的差）

## コンセプト
- [[concepts/インスタンスセグメンテーション]] — 画像中の各オブジェクトを個別にセグメンテーションするタスク
- [[concepts/Self-Attention]] — Transformer の中核機構。系列内の全要素間の関連度を動的に計算して情報を集約する
- [[concepts/外科技術自動評価]] — 機械学習による外科手術スキルの客観的・自動的評価
- [[concepts/転移学習]] — ソースドメインで学習した特徴表現をターゲットドメインに再利用する手法
- [[concepts/GradCAM]] — 学習済みCNNに事後付与する勾配ベースの解釈性手法。判断根拠の画像領域をヒートマップで可視化
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
- [[concepts/HOTA]] — 検出・局所化・関連付けを統合するMOT評価指標。OSSチャレンジTask 3でユークリッド距離版を採用
- [[concepts/LSTM]] — ゲート機構で長距離時間依存を学習するRNN。双方向LSTMで前後文脈を統合（外科動画の時間モデル化）
- [[concepts/時間アテンションプーリング]] — 系列を重要度重み付き加重和で1ベクトルに集約する軽量ソフトアテンション。解釈性も提供
- [[concepts/プロセス vs 成果の信号分解]] — 開放縫合スキル評価を product（成果）/process（過程）信号に分解する分析フレーム。product-bias の実証分解、ExpOSによる3D手キネマティクス方向の占有と研究計画の repositioning（研究方針）
- [[concepts/SHAP]] — Shapley値ベースの事後特徴帰属。ExpOSのグローバル特徴解釈に利用。GradCAMと対の関係
- [[concepts/順序回帰]] — 順序ラベル（スキルレベル）の学習。SORD損失で近いクラスへの誤りを軽く罰する（ExpOS採用）
- [[concepts/針運動ベースのプロセス計測]] — 縫合中の針運動から計算する解釈可能な幾何指標（Tip Path Length/Tip Area/Swept Area/Sway Length）。「follow the curvature of the needle」を定量化した純・process信号
- [[concepts/外科スキルプロキシ]] — 動画の器具＋手姿勢から計算でき実行者に説明できる解釈可能なmetric。Bkheetの6プロキシ（手の回内/指距離/手-組織距離/手速度等）でnovice vs expertを弁別しactionable feedback。ExpOSの学習ベース後継へ
- [[concepts/アルゴリズムバイアス]] — AI外科スキル評価の過小/過大評価バイアス（人口統計サブコホート間NPV/PPV格差）。product-biasとの区別とショートカット検証法（Kiyasseh 2023）
