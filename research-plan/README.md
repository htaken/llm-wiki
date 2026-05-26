# 開放手術スキル評価：プロセス信号の探索 — 研究計画

開放縫合（open suturing）動画からのスキル自動評価について、**まだ採掘されていない手法的余地**を特定し、最初の検証（Stage 0）を実行するための計画。コードリポジトリへ持ち込めるよう、wiki（Obsidian）から自己完結の形で切り出したもの。

> 出自: この計画は `llm-wiki`（個人ナレッジベース）での5本の論文 ingest と壁打ちから生成された。背景の一次ソースは [01-related-work.md](01-related-work.md) を参照。

> **⚠️ 2026-05-26 重要更新①（ExpOS）**: 先行研究 **ExpOS**（Papo, Smoller, Laufer / Technion, arXiv 2605.23653）が判明。本計画が「未採掘」とした方向——現代的単眼3D手再構成（WiLoR）を開放手術スキル評価の process チャンネルに使う——を**先取りして実装済み**。新規性主張 #1（3D手を初適用）と #5（キネマティクス上の弱教師あり時間アテンションで feedback）は**取られた**。一方 #3（product-bias 実証分解）・#4（OSATS カテゴリ別分解）・#2残余（product-only 上界への増分価値）・公開データでの再現は**生存**。詳細は wiki `wiki/concepts/プロセス vs 成果の信号分解.md`、`wiki/sources/ExpOS.md`。

> **⚠️ 2026-05-26 重要更新②（先行研究調査 Tier 1 4本を ingest）**: deep-research 調査の最近接4本を精読・取り込み、4本柱を再評価した（wiki `wiki/concepts/プロセス vs 成果の信号分解.md` の「Tier 1 先行研究4本による4本柱の再評価」節）。
> - **#3 強化**: Kiyasseh et al. 2023（npj Digit Med）のバイアスは**人口統計・公平性**で product-bias とは別物 → #3 生存。さらに彼らの**ショートカット検証法**（交絡コントロール＋均衡再訓練）を成果信号へ転用でき、#3 は「確立手法の新適用」へ格上げ。
> - **#4 clean に生存**: Cui et al. 2024（npj Digit Med）は縫合を6 EASE サブスキルへ分解したが**全て process 側で product ノードを持たない** → OSATS の final quality を軸にした product/process 寄与分解は未踏。
> - **#2 最も危険**: Atazadah et al. 2026（ICVTS）が鳥瞰 MediaPipe palm キネマティクスで**経験年数予測が OSATS・時間を上回る**ことを示した。「キネマティクスが効く」はもう柱にできない。#2 は「product-only **静止画**ベースライン／対象は OSATS スコア・カテゴリ／公開データ」の3点同時でのみ narrow に生存 → **見出しから外し、product-only を #3/#4 分解の“分母”として使う**。
> - **公開再現 → 公開ベンチマーク構築へ格上げ**: Fischer et al. 2026（IJCARS, arXiv 2601.15918）で外科手姿勢の公開基盤は整いつつあるが**マルチビュー・脊椎**。鳥瞰・開放縫合に skill＋product＋手姿勢＋器具トラックを揃えた公開基盤は不在 → AIxSuture 上に作る価値が明確。
>
> **重心の移動（本更新の核）**: (a) **publishable core を Stage 0（#3+#4）に置く**——公開データのみ・手姿勢非依存・ExpOS と sensor 系の群れ全てに非依存で、単体で1本になる。(b) **3D 手 process チャンネル（Stage 1+）は「貢献」でなく「道具」**。(c) **完了時間を product-vs-process の主問いに据える**（ExpOS の支配特徴も Atazadah の baseline も完了時間＝成果と相関する交絡）。(d) feasibility は単眼が脆く、Fischer 流 top-down ＋フォールバック前提で進める。

## 一行テーゼ（2026-05-26 改訂）

> **公開データ AIxSuture 上で、開放縫合スキルスコアが「成果（product）」と「過程（process）」のどちらにどれだけ駆動されているかを実証的に分解する。** 具体的には (a) 同一モデルで入力の時間位置を連続的に振る制御実験と (b) OSATS カテゴリ単位の product/process 寄与分解により、OSS が「未検証」と明記した **product-bias を決着**させ、**完了時間が product 側か process 側か**という未解決の交絡を切り分ける。process チャンネル（単眼3D手＋器具キネマティクス）は新規の貢献ではなく、この分解を測るための**道具**であり、評価は Ishchenko 型 **product-only 静止画ベースラインを“分母”**として行う。
>
> 旧テーゼ（process チャンネルの新規構築＋GRS での上乗せ＋形成的FB）は、ExpOS・Atazadah・Bkheet・Kil により「キネマティクス process が効く」「手姿勢で feedback」が既に飽和したため**見出しから外した**。残る独自性は**分解の問い・ベースラインの選び方・公開性**にある。

## なぜこの方向か

- 既存研究は **product 軸**（最終結果の静止画 → 高精度、Ishchenko/Noraset）と **holistic-video 軸**（生動画 → ベンチマーク勝者、AIxSuture/Alipour/OSS）を太く採掘済み。
- **「process キネマティクスが効く」も既に飽和した。** ExpOS（3D手、WiLoR）・Bkheet 2022（2D手姿勢＋プロキシ）・Kil 2024（膜下カメラ針運動）・**Atazadah 2026（鳥瞰 palm キネマティクスが経験年数予測で OSATS・時間を上回る）** が、それぞれ別ハード・別データで示した。→ 「3D手を初めて使う」「キネマティクスで弁別」「手姿勢で feedback」のいずれも新規性の柱にできない。
- **だが誰も「成果と過程の寄与を分解」していない。** ExpOS は product/process を分解せず支配特徴が完了時間（成果と相関）。Atazadah の baseline は時間/OSATS で product-only 静止画ではなく、対象は経験年数。Cui は process をサブスキルへ分解したが product ノードを持たない。Kiyasseh のバイアスは人口統計で product-bias とは別物。→ 価値は **「product-bias の実証分解（#3）」「OSATS カテゴリ別の寄与分解（#4）」「公開 AIxSuture でのオープンな基盤化」** に集約される。
- product-bias が（Ishchenko により）ほぼ実証済みのため **GRS で勝負すると負ける**点は不変。ただし **「process は intermediate（中間スキル層）で最も効く」仮説は Atazadah が逆証拠を出した**——弁別力は低端（学生 vs 研修医）に集中し上端で saturate、群間差は**長く複雑なタスクでのみ**有意。価値の所在は「中間スキル層」より「**長く複雑なタスク**」かもしれない（要再検証、01・02 参照）。

## ロードマップ

| Stage | 中身 | 依存 | 状態 |
|---|---|---|---|
| **Stage 0** | product-bias の実証分解（#3）＋ OSATS カテゴリ別分解（#4）＋ 完了時間の product/process 切り分け（手姿勢に**非依存**）＋ 手姿勢 feasibility プローブ | 公開データ AIxSuture のみ | ← **publishable core。ここから着手** |
| Stage 1 | process チャンネル構築（3D 手＋器具キネマティクス、必要なら合成データ共訓練）。**貢献ではなく分解の道具** | Stage 0c プローブの結果 | 未着手・拡張扱い |
| Stage 2 | 時間アテンションモデル ＋ product/process late fusion ＋ 上乗せ評価 | Stage 1 | 未着手・拡張扱い |

**Stage 0 を中核論文に据える理由（2026-05-26 強化）**: Stage 0 は「3D手姿勢が外科映像で動くか」という最大リスクに**依存せず**、ExpOS・Atazadah・sensor 系の群れ全てに非依存で、**公開データのみで完結する clean な単独論文になりうる**。一方 risky な 3D 手メッシュを要する Stage 1+ は、地形が飽和して新規性が最も薄い領域。よって投資順序だけでなく**論文の重心そのもの**を Stage 0 に置く。Stage 1+ は「分解を測る道具立て＋公開ベンチマーク化」の拡張として位置づけ、手姿勢が全滅しても Stage 0 の成果は無傷。

詳細な実験設計は [02-stage0-experiments.md](02-stage0-experiments.md)。

## ファイル構成

- [README.md](README.md) — 本ファイル。全体像とロードマップ
- [01-related-work.md](01-related-work.md) — 5論文を product↔process 軸で整理 ＋ 使えるツール群
- [02-stage0-experiments.md](02-stage0-experiments.md) — Stage 0 の具体的実験設計・判定基準・方法論ガードレール
- [03-prior-art-prompt.md](03-prior-art-prompt.md) — 新規性主張の反証を探す先行研究調査プロンプト（ChatGPT 等の Web 調査用）

## 最大リスク（直視する）

- **単眼3D手姿勢がこの映像で本当に動くか**。手袋・鳥瞰視点・器具/針の相互オクルージョン。WiLoR/HaMeR は素手・三人称で訓練済み → 外科映像は OOD。Stage 0c のプローブが Stage 1+ の前提。
  - **【2026-05-26 緩和】** ExpOS が RoHans→WiLoR で開放手術映像から 21関節を抽出し r=0.778 を出した存在証明あり（コード公開 github.com/RoiPapo/ExpOS）。Atazadah も鳥瞰単眼 palm で OSATS を上回った。鳥瞰・単一術者・縫合パッドは有利な部分集合。
  - **【2026-05-26 警告】** Fischer 2026 は**単眼が OOD で脆く、マルチビュー三角測量が頑健**と結論（外科手姿勢の難所トライアド＝強い局所照明/グレア・器具スタッフ遮蔽・手袋の均一外見）。AIxSuture は単眼なので、単眼の脆さは直撃しうる。
  - **実装の更新**: 素の WiLoR でなく **Fischer 流 top-down**（人物検出→全身姿勢で粗初期化→object-agnostic 追跡でオクルージョン跨ぎ→手 crop に手特化モデルで精密化→制約付き3D最適化）。**全身モデル（Sapiens2 系）は外科手で最弱**と実証済み → プローブの SAPIENS2 への期待は下げる。**biomechanical 制約は逆効果**（最尤の生体力学形状が2D予測と不一致）。
  - **価値命題の更新**: Atazadah が「palm 軌跡は needle entry angle・回旋・指/手首の微細制御を取りこぼす」と明記 → 3D 関節化の意義はこの**微細運動の回収**にある。だがそれは最も再構成が難しい部位でもある（feasibility と価値が同じ場所でせめぎ合う）。
- **ダメな場合のフォールバック**: process チャンネルを **SAM3 マスクの2Dモーション統計**（重心軌跡・速度・idle time）または palm 軌跡に縮退。視点非依存で確実に回り、Stage 0（#3+#4、手姿勢非依存）の成果は無傷。
