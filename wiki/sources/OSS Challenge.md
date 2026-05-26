---
title: "OSS: Open Suturing Skills Vision-Based Assessment Challenge 2024-2025"
type: source
created: 2026-05-26
updated: 2026-05-26
tags: [外科技術評価, 開放手術, 縫合, チャレンジ, ベンチマーク, MICCAI, OSATS, キーポイントトラッキング, 深層学習]
sources: [2605.22200v1.md]
aliases: [OSS Challenge, Open Suturing Skills Challenge, OSS 2024-2025]
---

# OSS: Open Suturing Skills Vision-Based Assessment Challenge 2024-2025

## 書誌情報

- **著者**: Hanna Hoffmann, Setareh Bady, Claas de Boer, Max Kirchner, Isabel Funke, Stefanie Speidel, Behrus Hinrichs-Puladi ほか多数（参加チームを含む共著、計50名超）
- **主催機関**: TU Dresden (TUD)、National Center for Tumor Diseases (NCT) Dresden、University Hospital RWTH Aachen
- **開催**: MICCAI 2024（Marrakesh, Morocco）および MICCAI 2025（Daejeon, South Korea）、EndoVis チャレンジのサブチャレンジ
- **arXiv**: 2605.22200v1
- **データ**: https://www.synapse.org/Synapse:syn58905622
- **報告基準**: BIAS（Transparent reporting of biomedical image analysis challenges）ガイドラインに準拠

## 要約

開放手術（open surgery）の縫合スキルを**動画ベース**で自動評価する初の専用チャレンジ。[[sources/AIxSuture]] の研究グループ（NCT Dresden / RWTH Aachen）が、AIxSuture の延長としてMICCAI 2024・2025 の2年連続で開催した。[[entities/AIxSuture データセット]]を拡張したデータ（静的GoProによる開放縫合のドライラボ動画＋器具軌跡）を用い、以下の3タスクをベンチマークした:

1. **Task 1: GRS分類** — 動画を4段階のスキルレベル（beginner / intermediate / proficient / expert）に分類
2. **Task 2: OSATS予測** — [[entities/OSATS]]の8カテゴリ各々を予測（より細粒度）
3. **Task 3: キーポイントトラッキング**（2025のみ） — 両手・器具・針のキーポイントを追跡

参加チームは深層学習動画モデル・トラッキング駆動手法・ハイブリッドなど多様な解を提出した。**汎用的な時空間動画モデル（特に3D CNNベースライン）が一貫して最高性能**を示し、概念的に多様な手法も丁寧に実装すれば競争力を持った。細粒度のOSATS予測は依然困難だが訓練データ増加で大きく改善した。キーポイントトラッキングは頻繁なオクルージョン・フレーム外により困難で、運動ベースのスキル解析への応用は現状制約される。

## チャレンジ設計

- **ミッション**: [[entities/OSATS]]（8カテゴリ、各5段階リッカート尺度）に基づく外科スキル予測を進展させること。8カテゴリの合計が **GRS（Global Rating Score, 8〜40）** で全体性能の総合指標
- **2024**: 2タスク、賞金1,000 EUR（Huawei提供）を2タスクで均等配分。3つの提出ラウンド（①公式データのみ ②再提出 ③補足アノテーション可）
- **2025**: 3タスク（Task 3追加）、賞金450 EUR（6G-life Project提供）を3タスクで均等配分
- **提出形式**: 完全自動・Dockerコンテナ化。評価環境は最大4×NVIDIA RTX A5000（提出は単一GPUに制限）
- ホスティングは Synapse。主催機関メンバーも参加可だが受賞対象外

### データアクセスと評価方式

署名が紐づくのは**訓練データの取得**であって、テストデータは署名しても参加者には配布されない。

- **Train データ**（Synapse syn58905622 で配布される公開分）: 参加者がアクセスするには**チャレンジ規約への署名が必須**（accountability確保のため）。署名 → 訓練データのダウンロード可
- **Test データ**: 非公開。**主催チームのみが need-to-know でアクセス**。参加者は完全自動・コンテナ化した解を提出し、**主催側のマシンがテストデータ上で実行して採点**するクローズド評価。署名してもテストデータ自体は入手できない

> 原文（Section 2.1）: "participants were required to sign the challenge rules before gaining access to the data" / "Access to the test data was restricted to organizing team members on a need-to-know basis"

### 評価指標

- **Task 1, 2**: マクロ平均F1（精度・再現率を統合）と **期待コスト EC（Expected Cost）**。ECはクラスの順序性（beginner≪…≪expert）を反映し、線形重み $w_{ij}=|i-j|/(C-1)$ で平均絶対誤差的に振る舞う。最終ランクはF1ランクとECランクの平均（同点はEC優先）
- **Task 2**: 指標はOSATSカテゴリ毎に算出後、カテゴリ平均
- **Task 3**: [[concepts/HOTA]]（Higher Order Tracking Accuracy）。バウンディングボックスのIoUの代わりにユークリッド距離を類似度に用いるよう改変
- ランク安定性・有意差は**ブートストラップ（10,000回）** と **Wilcoxon符号順位検定**で評価

## データセット

[[entities/AIxSuture データセット]]（314本）を基盤に、各エディションで拡張（詳細はエンティティページの「OSSチャレンジでの拡張」節）。

| データセット版 | Train（公開） | Test（非公開） | 計 |
|---|---|---|---|
| AIxSuture | 314 | 0 | 314 |
| 2024 challenge | 329（うち15本はラベル欠落のexpert） | 50 | 379 |
| 2024 + experts | 329（フルラベル） | 50 | 379 |
| 2025 challenge | 349 | 59 | 408 |

- expert（GRS>32）動画が AIxSuture に少ないため、30名のexpert（5年以上経験の歯科外科レジデント）＋35名の学生の追加収録を実施。15本のexpert動画を訓練に、残り50本をテストに割当
- 技術的エラーで2024時点では追加15本のOSATSラベルが参加者に未提供 → チャレンジ後に「追加expertデータあり」版での再提出を許可（結果は両方報告）
- **Task 3**: 全体の部分集合にキーポイント注釈。訓練52本（1 fpm、ツール/手のセグメンテーションマスク付き）＋検証8本（1 fps）＋テスト16本（1 fps）、計1,816フレーム。各キーポイントに可視性フラグ（visible / hidden / out-of-frame）。針が最も頻繁に隠れ、手は最もフレーム外/隠れが多い（全体でhidden約26.5%・out-of-frame約11.5%）

### 評価者間一致度（IRA）

ICC(A, k=3) で算出（[[entities/OSATS]]参照）。**GRSのICCは0.92（train）/0.94（test）と高い**。OSATSカテゴリ別では knowledge of specific procedure が最高（0.91）、respect for tissue が最低（0.79）。GRS（集約）よりカテゴリ別の一致度が低く、Task 2のラベルノイズの一因。

## ベースライン

NCT提供。Funke et al. の確立手法に基づく:
- **[[entities/X3D]]-M**（Kinetics-400事前学習の3D CNN）で重なりのある16フレームクリップの特徴を抽出 → 平均プーリングで動画全体特徴に集約 → MLPヘッドでスキルスコア回帰
- 5 fpsでフレーム抽出・ダウンサンプル・センタークロップ。Huber損失で GRS（8〜40）を回帰する3モデルのアンサンブル。[[entities/Temporal Segment Network|segment-based sampling]]でクリップをランダム化
- Task 1は予測GRSをスコア範囲でハードコード分類。Task 2はカテゴリ毎に別アンサンブルを訓練
- **2024・2025ともベースラインが全提出を上回り**、ロバスト性を示した

## 参加チームと手法

### 2024（6チーム、4チームが公式期間＋Perk/Scalpelが事後提出）

| チーム           | アプローチ概要                                                                                                  |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| **SK**        | 動画末尾16枚（1fps）から**縫合数カウント**を代理指標に。ConvNeXt-Base（OpenCLIP/LAION→ImageNet）でGRS回帰。Task 2はGRSを各OSATSカテゴリに重み配分 |
| **Jmees**     | Mask2Formerで器具先端をセグメント→トラッキング→1D CNN+GRU+multi-head attentionで特徴抽出→LightGBM回帰。SurgToolLoc 2023の転用モデル     |
| **Algoritmi** | YOLOv5（手話用事前学習）で手追跡→特徴をPCA→MLP分類。Task 1のみ                                                                |
| **Scalpel**   | YOLOv11（RoHan技法でドメイン適応）特徴＋大域統計（idle time, 平均速度）＋縫合検出器→multi-head attention／LightGBM                      |
| **Perk**      | 手・器具トラッキング（YOLOv8、自前注釈）＋ワークフロー認識（ResNet50+TeCNO TCN）→記述的特徴（縫合数・結び数・1針あたり時間）→浅いMLモデルのアンサンブル               |
| **Syangcw**   | [[entities/Surgformer]]（TimeSFormer拡張、階層的時間アテンション）。Kinetics-400事前学習のend-to-end動画モデル                      |

### 2025（6チーム、7提出・1撤回）

- **SK**: 前年から方針転換、VideoMAE（Kinetics-400）で**動画冒頭**クリップから評価 → 不調
- **Saeid**: R(2+1)D-18 + GRM（Generative Reward Machine）でハイパラ最適化を自動化
- **MediSC_OyeSS**: 動画末尾16枚、ConvNeXt-base（Task1）/ MViTv2-S（Task2）。Task3はRTMDet+HRNet/CSPNeXt
- **Algoritmi**: Task1=InceptionV3（RGB+Sobelエッジの4ch）、Task2=YOLOv5 ROI→ResNet50→LSTM、Task3=SAM2+XGBoost+UNet
- **Jmees**: Swin3D動画Transformer＋補助セグメンテーションヘッド。Task3=ConvNeXt heatmap検出器（RGB+光流+前景マスク6ch、flow warping）
- **MoriLabNU (Mori)**: Task3のみ。Mask R-CNN→RTMPose-M（SimCC）→器具ランドマーク→OKS-IoUトラッキングの4段パイプライン

## 主要結果

### Task 1: GRS分類

- **どの提出もベースラインを超えられなかった**（2024 baseline F1=0.65/EC=0.11、2025 baseline F1=0.65/EC=0.12）
- 2024公式: SK が最高（F1=0.55）。事後のPerkが全体最高F1=0.62
- **追加expertデータ投入後**: SK が F1=0.75 / EC=0.07 でベースラインも上回る最高性能。Perk は F1=0.69
- 2025: Saeid が提出組で最高（F1=0.62）、MediSC（0.47）、Jmees（0.41）が続く

### Task 2: OSATS予測

- Task 1より全チームでF1が大きく低下（多出力・5段階化・カテゴリ別IRA低下のため）
- どの提出もベースラインに及ばず。2024 baseline F1=0.39（追加データで0.44）、2025 baseline F1=0.47
- **追加expertデータで Perk が F1=0.49 とSK・ベースラインを上回る**（プロセス指向特徴が細粒度評価で価値を持つ示唆）
- 2025: Algoritmi・MediSC・Jmees が僅差で1位タイ → EC同点規則でJmeesが1位、Algoritmi/MediSCを2位に

### Task 3: トラッキング（2025のみ）

- Jmees が最高 HOTA=0.20、MediSC（0.16）、Algoritmi（0.15）、Mori（0.01）
- **全体に低スコア**。オクルージョン・高速動作・フレーム外・小さい針が困難。テストセットが小さく統計的検出力も限定的（Algoritmi vs MediSC は p=0.3 で有意差なし）

## チーム別 成否分析

論文の考察（Discussion）に基づく、各チームのうまくいった点（✅）・うまくいかなかった点（❌）の整理。

### ベースライン（[[entities/X3D]] 3D CNN）
- ✅ **汎用・低労力で頑健**。ハンドエンジニアリングなしで両年・両タスクとも全提出を上回る。特にOSATSで強く、時空間特徴が幅広い品質指標を捉える。ECも安定
- ❌ 目立った失敗なし。product-bias仮説では成果（外観）のショートカット利用が懸念されるが、3D CNNの外観バイアスはアーキ固有でなく訓練データ由来との研究があり、空間＋時間の両手がかりを学べていると解釈される

### Team SK ― 年ごとに明暗が分かれた象徴例
**2024（縫合数カウント）**
- ✅ 動画末尾の完成縫合数がGRSと強く相関するという正しい着眼。極めてシンプルながら参加チーム最高。追加expertデータで不釣り合いに大きく改善（F1=0.75でベースライン超え）
- ❌ 元データではECのみベースラインと並びF1は劣る。本質的に最終成果依存（product-bias）

**2025（VideoMAE・動画冒頭）**
- ❌ 勝ちパターンを放棄。①成果情報の乏しい序盤クリップ、②自己教師あり表現を非識別的内容に適用、③softmaxベースの不適切な損失 の三重苦で最下位。「序盤に切り替えたら崩れた」事実がproduct-bias仮説を補強

### Team Perk ― プロセス指向の成功例（2024）
- ✅ モーション特徴に**ワークフロー指標**（縫合数・結び数・1針あたり時間）を統合。さらに自前注釈で専用トラッキングを学習し信頼できる運動信号を獲得。Task 1で事後最高（F1=0.62→追加データで0.69）。とりわけTask 2/OSATSで追加データ後 F1=0.49 とSK・ベースラインを抜く
- ❌ 多大な追加注釈コスト。粗いGRS分類ではプロセス特徴はSKの成果特徴ほど追加データの恩恵を受けず、追加データ後にTask 1でSKに逆転される

### Team Scalpel ― Perkとの差が示唆的（2024）
- ✅ 自前注釈トラッキング（off-the-shelfより良質）＋検出モデルの中間特徴を利用（生座標より豊か）。Jmees・Algoritmiより上位
- ❌ 明示的なワークフロー文脈を欠く（フェーズ分割・縫合数・1針効率なし）。集約モーション統計のみで時間特徴が粗く、Perkに明確に劣る中位

### Team Jmees ― 失敗から立て直した例
**2024（Mask2Formerトラッキング＋プロキシ）**
- ❌ トラッキングパイプラインの上にプロキシ予測を積んだため、トラッキング誤差とマルチタスク代理予測の複雑さが複合。SurgToolLoc転用の汎用セグメンテーション＋専用注釈不足で品質不明。expertクラス予測ゼロ・intermediate真陽性ゼロ。Task 2最下位

**2025（Swin3D動画Transformer）**
- ✅ トラッキング系を捨て動画Transformer＋補助セグメンテーションヘッドに転換し大幅改善。Task 1で3位、Task 2は実質1位（EC同点規則）、Task 3も最高HOTA=0.20。「Transformerが不適なのではなく実装・訓練戦略が重要」を示す好例

### Team Algoritmi ― 複雑さが裏目
**2024（YOLOv5手追跡＋MLP）**
- ❌ 手話用の汎用事前学習＋専用注釈不足で弱い。唯一、追加データでも結果が変わらなかったチーム。Task 1最下位

**2025（InceptionV3 / ResNet-LSTM / SAM2）**
- ❌ Task 1: 動画末尾に着目したのに、RGB+Sobelエッジ＋旧式InceptionV3で不要な複雑さの割に利得が伴わず5位
- ✅ Task 2: ResNet-LSTMへ適応し、MediSC・Jmeesと僅差の上位

### Team Syangcw（2024・[[entities/Surgformer]]）
- ✅ トラッキング系（Jmees・Algoritmi）よりはTask 1で良好
- ❌ 低データ域がTransformerに不利（空間的帰納バイアスが弱い）。中〜下位

### Team Saeid（2025・R(2+1)D+GRM）
- ✅ R(2+1)Dが空間帰納バイアスを保ちつつ時間次元を効率分解。GRMによる体系的ハイパラ最適化が限られたデータで容量を最大化 → 提出組でTask 1最高（F1=0.62）
- ❌ 多出力OSATSには不適（複数スコア同時最適化の困難）でTask 2低迷（F1=0.19）。Task 3は完全に失敗

### Team MediSC（2025・ConvNeXt/MViTv2）
- ✅ 識別的な空間特徴に集中（SKの2024成功戦略に類似）＋動画末尾＋背景除去。Task 1で4位、Task 2は2位タイ
- ❌ ベースラインとの差は依然大きい

### Team Mori（2025・Task 3専用）
- ❌ HOTA=0.01で最下位。Mask R-CNN→RTMPose→器具ランドマーク→OKS-IoUの4段パイプラインが複雑で、オクルージョン・フレーム外の多い開放手術動画で破綻

### 全体を貫く教訓
1. シンプルでも正しい信号を捉えれば勝てる（SK 2024の縫合数）が、信号の選択を誤ると崩れる（SK 2025の序盤）
2. トラッキングは「自前注釈＋ワークフロー文脈」がある時だけ報われる（Perk ◎ / Scalpel △ / Jmees・Algoritmi ✗）
3. 複雑さは利得を伴って初めて正当化される（Algoritmi・Moriの多段構成、Jmees 2024の積み重ねは裏目）
4. アーキの良し悪しより実装・訓練戦略・データキュレーション（Jmeesの2024→2025の立て直しが象徴）

## 考察・知見（[[concepts/外科技術自動評価]]に反映）

- **汎用性 + 丁寧なチューニング > 専門的だが最適化不足の手法**。低データ域では方法論の洗練が必ずしも性能向上を保証しない
- **product-bias 仮説**: GRSスキルレベルは最終成果（縫合の出来）に偏って採点されている可能性。SKの縫合数カウントやベースラインの成功はこれを部分的に捉えたためとも解釈できる。ただし**未検証**で、熟練したプロセスと熟練した成果は通常結びついている
- 2025でSKが**動画冒頭**に切り替えて不調になった点は、（成果情報の乏しい序盤では性能が出ない＝）product-bias仮説を弱く支持
- **トラッキング依存手法は不利**（Jmees, Algoritmi）。自前の専用注釈で学習したPerk/Scalpelは比較的良好 → トラッキング品質と注釈の重要性
- 2024→2025でアーキは**トラッキング/代理ベース → 時空間動画モデル**へシフト（2024で3D CNNが優位だった影響）
- **formative assessment（行動レベルの形成的フィードバック）にはプロセス指向手法が不可欠**だが、各動画セグメントの細粒度スキル注釈という大きな実務的課題が残る

## 結論

2エディション・9チーム・17モデルで自動外科スキル評価の包括ベンチマークを構築。GRS分類はend-to-end 3D CNNが頑健、OSATS予測は時間・プロセス指向特徴が有意義（データ増で改善）だが依然未解決、キーポイントトラッキングは下流の運動ベース解析の前提条件でありながら最も困難。**「予測しやすい指標（GRS）は訓練にとって情報が少なく、最も有用な指標（OSATS）が最も予測困難」**という自動スキル評価の根本的緊張を浮き彫りにした。臨床的価値の実現には、より大規模で細粒度な注釈付きデータと、信頼できるキーポイントトラッキングが必要。

## 関連する概念・エンティティ

- [[sources/AIxSuture]] — 本チャレンジの基盤となる先行研究
- [[entities/AIxSuture データセット]] — 拡張元データセット
- [[entities/OSATS]] — 評価尺度（GRS含む）
- [[concepts/外科技術自動評価]]
- [[entities/X3D]] — ベースライン3D CNN
- [[entities/Surgformer]] — 2024 Syangcwの動画Transformer
- [[concepts/HOTA]] — Task 3トラッキング評価指標
- [[entities/Temporal Segment Network]] — ベースラインのサンプリング戦略
- [[concepts/手検出・ローカライゼーション]] — Task 3の手キーポイント検出と関連
- [[concepts/転移学習]] — Kinetics-400/ImageNet/COCO事前学習が広く利用
