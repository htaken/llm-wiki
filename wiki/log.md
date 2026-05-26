---
title: Log
type: log
updated: 2026-05-26
---

# 操作ログ

## [2026-05-26] ingest | 先行研究調査 Tier 1 4本（Atazadah / Cui / Kiyasseh / Fischer）

deep-research 報告（`~/Downloads/deep-research-report.md`）を踏まえ取得した Tier 1 4本を取り込み。ExpOS 後に残した4本柱（#3 product-bias 実証分解・#4 OSATS カテゴリ別分解・#2 product-only 上界への増分・公開再現）を各論文に照らし再評価。

- **`raw/ivag048.md`（Atazadah et al. 2026, ICVTS）** — 鳥瞰 [[entities/MediaPipe]] palm 軌跡のキネマティクスが**経験年数予測で OSATS・手術時間を上回る**。**主張 #2 への最大の新脅威**だが、対象が経験年数（成果スコアでない）・baseline が時間/OSATS（product-only 画像でない）・palm のみ（微細運動を捨てる）・非公開、の4差で #2 は narrow に生存。palm の限界記述が 3D 関節化の動機に。
- **`raw/s41746-024-01143-3.md`（Cui et al. 2024, npj Digital Medicine）** — 縫合を6 [[entities/EASE]] サブスキルに分解し GAT で関係をモデル化。**主張 #4 の最近接**だが process のサブスキル分解で product を分けず（EASE は product ノードを持たない）・VR ロボット。#4 は clean に生存。
- **`raw/s41746-023-00766-2.md`（Kiyasseh et al. 2023, npj Digital Medicine）** — SAIS の過小/過大評価バイアス（人口統計サブコホート間 NPV/PPV 格差）を実証、TWIX で緩和。**主張 #3 防御に必読**: 人口統計バイアス≠product-bias で #3 生存、かつ交絡コントロール＋均衡再訓練のショートカット検証法を成果信号へ転用でき #3 を方法論ごと強化。
- **`raw/2601.15918v1.md`（Fischer et al. 2026, IJCARS）** — training-free top-down マルチビュー3D手姿勢＋68k フレーム公開ベンチマーク。単眼の OOD 脆弱性を指摘しマルチビューを推奨（難所トライアド=照明/オクルージョン/手袋を整理）。feasibility は有利な部分集合（鳥瞰・単一術者）で成立、「公開ベンチマーク構築」柱に追い風。

**重心の移動**: publishable core を Stage 0（#3+#4、公開データ・手姿勢非依存）に置く／process チャンネル（3D手）は貢献でなく道具／完了時間を product-vs-process の主問いに据える。

作成したページ:
- `wiki/sources/AI手追跡による心臓胸部外科スキルの客観的評価.md`（Atazadah 2026）
- `wiki/sources/縫合サブスキル間の関係性を捉えた自動評価.md`（Cui 2024）
- `wiki/sources/人間の視覚的説明によるAIスキル評価のバイアス緩和.md`（Kiyasseh 2023）
- `wiki/sources/外科3D手姿勢推定のマルチビューパイプラインとベンチマーク.md`（Fischer 2026）
- `wiki/entities/EASE.md` — 縫合サブスキル尺度（OSATS との対比＝#4 の根拠）
- `wiki/concepts/アルゴリズムバイアス.md` — 過小/過大評価バイアスと product-bias の区別、ショートカット検証法

更新したページ:
- `wiki/concepts/プロセス vs 成果の信号分解.md` — 「Tier 1 先行研究4本による4本柱の再評価」節を追加（#3 強化・#4 clean 生存・#2 最も危険・公開ベンチマーク追い風・feasibility 更新・重心移動）、sources 4本追加、関連ページ更新
- `wiki/concepts/3D手姿勢推定.md` — 「外科ドメインの feasibility と単眼 vs マルチビュー」節（Fischer の難所トライアド・top-down レシピ・全身モデルの弱さ・biomech 逆効果、Atazadah palm の限界）を追加
- `wiki/index.md` — ソース4・エンティティ1（EASE）・コンセプト1（アルゴリズムバイアス）を追加

未反映（ユーザー確認待ち）: `research-plan/` の README・01 への重心移動の反映。

## [2026-05-26] ingest | Using Hand Pose Estimation To Automate Open Surgery Training Feedback

`raw/2211.07021v2.md`（Bkheet, D'Angelo, Goldbraikh, Laufer / Technion・Mayo Clinic, arXiv 2211.07021）を取り込み。**[[sources/ExpOS]] の2D手姿勢版の直接の前身**（同 Laufer 研、Goldbraikh は [[entities/Open Surgery Simulation データセット]] の著者でもある）。[[entities/YOLO|YOLO-X]] で手・器具を検出 → Simple Baseline で2D姿勢推定 → [[entities/MS-TCN++]] でジェスチャー/ツールをマルチタスク同時セグメンテーション（[[entities/I3D]] 多視点融合で **88.35% SOTA**、kinematic センサ 82.40% を凌駕）。さらにドメインエキスパートの助言を operationalize した **6つの[[concepts/外科スキルプロキシ]]**（手の回内/回外・親指-人差し指距離・指-組織距離・手速度・ジェスチャー所要時間）で novice vs expert を有意弁別し、**per-gesture の actionable feedback** を自動生成。

**研究計画への含意**: 「手姿勢→process チャンネル→解釈可能な actionable feedback」という発想が **2026年の ExpOS ではなく 2022年の本論文に遡れる**ことを確定。[[concepts/プロセス vs 成果の信号分解]] の差別化軸（手姿勢の新規使用ではなく product/process 実証分解・OSATSカテゴリ別寄与・product-only 上界への増分価値）をさらに補強。本論文の「多視点2D姿勢で +1.23% → 3D なら上回りうる」「hand orientation は2Dゆえ単一視点に制約」という記述が、後続 ExpOS が [[entities/WiLoR]] で3D化した**動機の種**であることも判明。ユーザー選択により標準粒度で取り込み、research-plan/ にも反映。

作成したページ:
- `wiki/sources/手姿勢推定による開放手術トレーニングフィードバックの自動化.md` — ソース要約（モジュラーパイプライン・データセット・セグメンテーション結果表・6プロキシ・限界・不整合）
- `wiki/concepts/外科スキルプロキシ.md` — Surgical Skill Proxy の定義・6プロキシの式と臨床的根拠・ExpOS/Kil との関係・研究計画含意
- `wiki/entities/Open Surgery Simulation データセット.md` — Goldbraikh et al. の開放手術シミュレーションデータ（100動画/25臨床医、kinematic付き、OSS Challengeと別物）

更新したページ:
- `wiki/concepts/外科技術自動評価.md` — 「2D手姿勢＋スキルプロキシアプローチ（Bkheet et al.）」節を追加（ExpOS節の直前に配置し系譜を明示）
- `wiki/concepts/プロセス vs 成果の信号分解.md` — product↔process地図にBkheet行を追加、手姿勢→process 系譜の起点として追記
- `wiki/concepts/3D手姿勢推定.md` — 2D多視点→3D化の動機（+1.23%・hand orientation の2D制約）を追記
- `wiki/entities/MS-TCN++.md` — マルチタスク・ジェスチャー/ツールセグメンテーションでの利用（ExpOS の特徴抽出器転用の前段）を追記
- `wiki/entities/YOLO.md` — YOLOX-S による手2＋器具4検出を追記
- `wiki/entities/WiLoR.md` — ExpOS の3D化が Bkheet の予想の帰結である旨を追記
- `wiki/index.md` — ソース1・エンティティ1・コンセプト1を追加

リポジトリ外への持ち出し用（research-plan/、ユーザー選択により01のみ更新）:
- `research-plan/01-related-work.md` — product↔process地図にBkheet 2022を追加、「継ぎ目の現況」（手姿勢→process→feedback 系譜が2022年に遡れる旨）・「一次ソース一覧」を更新

検出した不整合（各ページに併記）:
- abstract/contributions は「6プロキシ」だが §3.4 は5つしか列挙せず（Thumb-Index Distance の2文脈使用で6の可能性、本文未明示）
- 結論本文の frontal 姿勢 81.81% ⇔ Table 2 の frontal keypoints 81.22%

## [2026-05-26] ingest | Assessment of Open Surgery Suturing Skill: Image-based Metrics Using Computer Vision

`raw/1-s2.0-S1931720424001636-main.md`（Kil, Eidt, Singapogu, Groff / Clemson, *J Surg Ed* 2024）を取り込み。縫合シミュレータの**膜下カメラ**で針・糸運動を撮影し、CV（OpenCV/C++→MATLAB）で**画像ベースの幾何指標**を抽出。外科の格言「follow the curvature of the needle」を operationalize した**新規4指標**（Needle Tip Path Length / Tip Area / Swept Area / Sway Length）を定義。研修医7・指導医5の12名で、9指標中6指標が attending vs resident を有意弁別（Wilcoxon、針運動指標 > 時間・成果指標）。同グループの力・運動版（Kil et al. *Front Med* 2022）の画像ベース姉妹論文。深層学習を使わない純・process アプローチで、Wiki内で**最も明快な「過程信号だけで熟練度を弁別」実証**。ユーザー選択により概念1ページ追加の粒度で取り込み、research-plan/ にも反映。

作成したページ:
- `wiki/sources/開放手術縫合スキルの画像ベース計測.md` — ソース要約（シミュレータ・2段CVアルゴリズム・9指標・研究デザイン・結果・depth効果・指標間関係・研究計画への含意）
- `wiki/concepts/針運動ベースのプロセス計測.md` — 4指標の定義・式・前処理（Butterworth+weeding）・相補性の思考実験・process/product文脈

更新したページ:
- `wiki/concepts/外科技術自動評価.md` — 「針運動ベースのプロセス計測アプローチ（Kil et al.）」節を追加、モーションベース例にリンク、sources/関連に追加
- `wiki/concepts/プロセス vs 成果の信号分解.md` — product↔process地図に行追加、「intermediate仮説」を別角度から裏付ける純・process実証として追記、関連に追加
- `wiki/index.md` — ソース1・コンセプト1を追加

リポジトリ外への持ち出し用（research-plan/）:
- `research-plan/01-related-work.md` — product↔process地図にKil 2024を追加（純・process実証、attending vs resident弁別、HW依存の留保、process指標の操作的定義）

## [2026-05-26] ingest | ExpOS: Explainable Open-Surgery Skills Assessment Using 3D Hand Reconstruction

`raw/2605.23653v1.md`（Papo, Smoller, Laufer / Technion, arXiv 2605.23653）を取り込み。[[entities/RoHans]]→[[entities/WiLoR]] で各手21関節の3D軌跡を抽出し、[[entities/MS-TCN++]] バックボーン＋多頭[[concepts/時間アテンションプーリング]]＋グローバル運動統計を融合MLPで回帰、開放手術3タスク（縫合/結紮/筋膜閉鎖、研修医221動画）のスキルを評価。[[concepts/SHAP]]（特徴帰属）と時間アテンション（時間局在）の二層解釈性。[[concepts/順序回帰|SORD損失]]採用。Fascial Closure r=0.778, R²=0.74。

**最重要の含意**: ExpOS は [[concepts/プロセス vs 成果の信号分解]] と `research-plan/` が「未採掘の継ぎ目」と特定していた方向（現代的3D手再構成を process チャンネルに使う）を先取り。新規性主張 #1（3D手の初適用）・#5（弱教師あり時間アテンションで feedback）は**取られた**。#3（product-bias 実証分解）・#4（OSATSカテゴリ別分解）・#2残余（product-only上界への増分価値）・公開データ再現は**生存**。研究計画を「動くか」から「成果から独立に効くか」へ repositioning。

作成したページ:
- `wiki/sources/ExpOS.md` — ソース要約（パイプライン・特徴・フレームワーク・二層解釈性・結果・研究計画への含意）
- `wiki/entities/RoHans.md` — 手術室向け頑健手検出（同著者、YOLO自己訓練）
- `wiki/entities/MS-TCN++.md` — 多段拡張時間畳み込みネット（特徴抽出器として転用）
- `wiki/entities/YOLO.md` — one-stageリアルタイム物体検出（器具・手検出のワークホース）
- `wiki/concepts/SHAP.md` — Shapley値ベースの事後特徴帰属（GradCAMと対比）
- `wiki/concepts/順序回帰.md` — 順序ラベル学習とSORD損失

更新したページ:
- `wiki/concepts/プロセス vs 成果の信号分解.md` — 「ExpOSによる占有」節を追加、product↔process地図に追記、新規性主張の repositioning
- `wiki/concepts/外科技術自動評価.md` — 「3D手キネマティクス＋解釈性アプローチ（ExpOS）」節を追加
- `wiki/concepts/時間アテンションプーリング.md` — 多頭アテンションプーリング変種・[CLS]アナロジーを追記
- `wiki/concepts/3D手姿勢推定.md` — 下流応用（外科スキル評価）を追記
- `wiki/entities/WiLoR.md` — 外科スキル評価への応用（ExpOS）を追記
- `wiki/index.md` — 新規ページを一覧に追加

リポジトリ外への持ち出し用（research-plan/、ExpОSを反映して改訂）:
- `research-plan/README.md` — 冒頭に重要更新、テーゼ・最大リスクを repositioning
- `research-plan/01-related-work.md` — 地図にExpOS追加、「継ぎ目の現況」へ改訂
- `research-plan/03-prior-art-prompt.md` — 既把握文献にExpOS（最重要の脅威）を追加

## [2026-05-26] query | 開放縫合スキル評価の手法的余地（壁打ち→研究方針）

クエリ「OSS Challengeで多くの手法が試された中、新規に開拓する余地のある手法を壁打ちで考えたい」を受け、外科スキル評価5ソース（[[sources/AIxSuture]]・[[sources/OSS Challenge]]・[[sources/Automated measurement extraction for suture quality]]・[[sources/縫合品質分類における転移学習の有効性評価]]・[[sources/開放手術スキルの時空間特徴ML評価]]）と手姿勢/セグメンテーション系ツール群（[[entities/WiLoR]]・[[entities/HaMeR]]・[[sources/AnyHand]]・[[entities/SAM 3]]・[[entities/Sapiens2]]・[[entities/MediaPipe]]）を横断的に分析。既存研究が product 軸（静止画→高精度）と holistic-video 軸（生動画→ベンチマーク勝者）を採掘済みで、explicit な3D手キネマティクスを process チャンネルとして使う余地が未開拓であると特定。Ishchenko による product-bias のほぼ実証を踏まえ、GRSで戦わず process-OSATS/形成的FB/intermediate弁別を狙う方針に。手姿勢非依存で公開データのみで回る Stage 0（時間位置スタディ＋OSATSカテゴリ別分解）から着手する判断。

作成したページ:
- `wiki/concepts/プロセス vs 成果の信号分解.md` — 5ソース横断の合成的考察（product↔process地図、product-bias格上げ、process狙いどころ、3D手キネマティクスの継ぎ目、Stage 0要点）

更新したページ:
- `wiki/index.md` — 新規コンセプトを一覧に追加

リポジトリ外への持ち出し用（コードリポジトリへ移送予定、wikiリンク非依存の自己完結md）:
- `research-plan/README.md` — 全体像・テーゼ・ロードマップ
- `research-plan/01-related-work.md` — 5論文の product↔process 整理＋ツール群
- `research-plan/02-stage0-experiments.md` — Stage 0a/0b/0c＋手姿勢プローブ＋方法論ガードレール＋判定基準

## [2026-05-26] ingest | 縫合品質分類における転移学習の有効性評価（Ishchenko et al. 2025）

`raw/jimaging-11-00266.md`（Ishchenko et al., V.K. Gusak Institute / Lomonosov MSU, *J. Imaging* 2025, 11, 266）を取り込み。**縫合結果の静止画像**から品質を**2値分類**する画像（成果）ベースの手法で、8つのImageNet事前学習CNN（ResNet50V2・DenseNet121・Xception・EfficientNetB0・MobileNetV3Large・VGG16/19・InceptionV3）を5-fold交差検証で系統比較。F1の群間差は全タスク非有意のため、安定性を考慮した独自スコア Score_adj で順位付け。IOVS/ILSはF1>0.90、最難のCOOSは0.79（ImageNetからのドメインシフト）。[[concepts/GradCAM]]でステッチ・結び目・組織縁への注目を確認。[[sources/Automated measurement extraction for suture quality]]（計測値抽出）と同じ画像ベースだがエンドツーエンド分類である点が対照的。

作成したページ:
- `wiki/sources/縫合品質分類における転移学習の有効性評価.md` — ソース要約（データセット・2段階fine-tuning・Score_adj・4タスク結果表・COOSドメインシフト・限界）
- `wiki/concepts/GradCAM.md` — 勾配ベースの事後解釈性手法。アテンションベース解釈性との対比

更新したページ:
- `wiki/concepts/外科技術自動評価.md` — アプローチ分類に「画像（成果）ベース」を追加、Ishchenko et al.の2値分類アプローチ節を追記
- `wiki/concepts/転移学習.md` — 8アーキ系統比較とCOOSのドメインシフト節を追記
- `wiki/entities/ResNet50.md` — ResNet50V2の画像2値分類での最有力性能（IOVS内面AUC-ROC 0.959等）を追記
- `wiki/index.md` — 新規ソース・GradCAMコンセプトを一覧に追加

## [2026-05-26] ingest | 開放手術スキルの時空間特徴ML評価（Alipour et al. 2026）

`raw/1-s2.0-S0039606025009316-main.md`（Alipour et al., UCLA CORELAB, *Surgery* 2026）を取り込み。[[entities/AIxSuture データセット]]に**CNN-LSTMハイブリッド**（fine-tuned [[entities/ResNet50]] + 双方向[[concepts/LSTM]] + ソフトアテンション）を適用し、3クラス分類でマクロF1 0.82を達成。比較対象のI3D・Swin各種の数値は[[sources/AIxSuture]]原論文の報告値そのものであり、AIxSuture公開ベンチマークに対する改善主張である点を明記。ユーザー選択により最大粒度（モデル本体・時間アテンションを独立ページ化）で取り込んだ。

作成したページ:
- `wiki/sources/開放手術スキルの時空間特徴ML評価.md` — ソース要約（手法2系統=ResNet50 fine-tuning/CNN-LSTM分類、結果、比較表、アテンション解析、限界、データ不整合）
- `wiki/entities/ResNet50.md` — 残差学習50層CNN、空間特徴抽出器、2フェーズfine-tuning、I3D/Swinとの対比
- `wiki/entities/CNN-LSTMハイブリッドモデル.md` — モデル本体（パイプライン図解、構成要素、訓練、性能、長短）
- `wiki/concepts/LSTM.md` — ゲート機構、CNN/Self-Attentionとの対比、BiLSTM、本研究での3採用理由
- `wiki/concepts/時間アテンションプーリング.md` — 単一ヘッドソフトアテンションによる系列集約、Self-Attentionとの違い、解釈性

更新したページ:
- `wiki/concepts/外科技術自動評価.md` — CNN-LSTMハイブリッドアプローチ節（3アーキ系統の対比表、チューニング差の留保、OSS教訓との整合）を追記
- `wiki/entities/AIxSuture データセット.md` — Alipour et al.の結果（n=119/79/116、マクロF1 0.82、前処理差）をベンチマーク節に追記
- `wiki/entities/I3D.md` / `wiki/entities/Video Swin Transformer.md` — 比較ベースラインとしての利用節を追記
- `wiki/concepts/Self-Attention.md` — 軽量な親戚としての時間アテンションプーリングを追記、関連リンク追加
- `wiki/concepts/転移学習.md` — ImageNet→外科フレームのResNet50転移、2フェーズ戦略を追記
- `wiki/sources/AIxSuture.md` — 別グループの後続利用としてリンク
- `wiki/index.md` — ソース1・エンティティ2・コンセプト2を追加

検出した不整合（各ページに併記）:
- abstractのマクロF1 80.1% vs 表の82.04%（5-fold平均 vs 結合モデルの可能性）
- abstractのクラス別「accuracy」（90.1/65.7/86.3%）vs 表のクラス別F1（91.26/62.86/92.00%）は別指標
- 利益相反欄「P.D.」が著者リストに該当者なし（表記揺れと推定）

## [2026-05-26] update | OSS Challenge コード公開状況

クエリ「元となるtrain.pyなどのスクリプトはあったか」を受け、GitLab API（nct_tso_public/aixsuture）でリポジトリ構成を調査。`wiki/sources/OSS Challenge.md` に「コード公開状況」節を追記。ベースラインの祖先である AIxSuture リポジトリの全スクリプト（train.py/test.py/preprocessing.py/models.py=I3D・Video Swin 等）、ただし公開バックボーンはI3D/Video SwinでありOSSベースラインのX3D-Mそのものではない点、チャレンジ側の評価スクリプト・改変HOTA・各チームコードの公開を記録。

## [2026-05-26] update | AIxSuture 配布先・ファイル構成

クエリ「追加されたファイルの特定」を受け、Zenodo（records/7940583）とSynapse公開REST APIを調査。`wiki/entities/AIxSuture データセット.md` に「配布先・ファイル構成」節を追記。Zenodoの確定ファイル一覧（OSATS.xlsx・Packages01-11・LICENCE・README、計102.1GB、CC BY-NC-ND 4.0）と、Synapse構造（プロジェクト syn54123724、論文記載の syn58905622 は実は「Train」フォルダ、Data/Results wiki、評価者A/B/C・A/D/Eの痕跡、Test非公開）を記録。個別ファイル名はAPI認証・署名ゲートのため未確認である旨も明記。

## [2026-05-26] update | OSS Challenge データアクセス方式

クエリへの回答を受け、`wiki/sources/OSS Challenge.md` のチャレンジ設計に「データアクセスと評価方式」節を追記。規約署名は訓練データ取得に紐づき、テストデータは署名しても配布されず主催側マシンでクローズド評価される点を原文引用付きで明記。

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
