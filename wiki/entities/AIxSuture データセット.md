---
title: AIxSuture データセット
type: entity
created: 2026-04-11
updated: 2026-05-26
tags: [データセット, 外科技術評価, 開放手術, 縫合]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md, 2605.22200v1.md]
aliases: [AIxSuture, AIxSuture dataset]
---

# AIxSuture データセット

開放手術の縫合訓練を記録した動画データセット。[[concepts/外科技術自動評価]]のための初の大規模開放手術動画コーパスとして公開されている。

## 概要

| 項目 | 内容 |
|------|------|
| 動画数 | 314本 |
| 動画長 | 各約5分 |
| フレームレート | 30fps |
| 総データ量 | 約100GB |
| カメラ | GoPro Hero 5（鳥瞰固定、カメラ移動なし） |
| モダリティ | RGB動画のみ（センサー・深度・音声なし） |
| 収集場所 | University Hospital RWTH Aachen |
| 公開先 | Zenodo（ベース314本）/ Synapse（チャレンジ拡張版）。詳細は「配布先・ファイル構成」節 |

## データ収集

VR HMD（ヘッドマウントディスプレイ）訓練の効果を調査する研究の一環として収集された。医学生・歯学生がシミュレーション環境で開放手術の縫合を実施し、各参加者について訓練前・訓練後の2本の動画が撮影された。

## 取得情報の範囲

本データセットは "video-only" を設計上の特徴とし、追加センサー類は意図的に含めていない。これは[[concepts/外科技術自動評価]]における motion-based 手法（器具追跡・力/トルク・キネマティクス等）との明確な対比点であり、追加ハードウェア不要であることが臨床導入容易性の根拠となっている。

含まれるもの:
- RGB動画ファイル
- 学生ID・動画ID・訓練前後フラグ（Excelスプレッドシートで管理）
- 3評価者によるOSATS 8カテゴリのスコアおよびGRS

含まれないもの:
- 器具トラッキング・ハンドキーポイント等のアノテーション
- 力・トルク・触覚センサー
- ロボットキネマティクス、アイトラッキング
- フェーズ/動作セグメンテーション等の時間アノテーション

## モデル入力時の前処理

論文ベンチマークでは以下の前処理が用いられている:
- 30 fps → **5 fps にダウンサンプル**してフレーム抽出
- 解像度を **270×480 ピクセル**にリサイズ
- リサイズ以外のハンドクラフト特徴抽出は行わない

## アノテーション

- 3名の独立した評価者が[[entities/OSATS]]（8カテゴリ）で評価
- 評価者間の平均Pearson相関係数 > 0.8（優れた一致度）
- Global Rating Score（GRS）: 8〜40点の範囲
- 3クラスに分類:
  - **Novice**: GRS < 16
  - **Intermediate**: 16 ≤ GRS < 24
  - **Proficient**: GRS ≥ 24

## データ分割

- 訓練70% / 検証15% / テスト15%
- 同一学生の訓練前後動画は同じ分割に配置（データリーク防止）
- Novice・Proficient各30〜40%、Intermediate 20〜30%（やや不均衡）

## ベンチマーク結果

[[sources/AIxSuture]]で報告されたベンチマークでは、[[entities/Temporal Segment Network]] + [[entities/Video Swin Transformer]]（Tiny）が最良のF1スコア72%、精度75%を達成した。

## 制限事項

- 訓練前後の設計上、intermediate・expert（GRS > 32）レベルのデータが少ない
- より均質な分布を得るには追加収録が必要

## OSSチャレンジでの拡張

[[sources/OSS Challenge]]（MICCAI 2024/2025 EndoVisサブチャレンジ）では、本データセットを基盤に拡張版が用いられた。`Test`は非公開（private）として保持される。

| データセット版 | Train（公開） | Test（非公開） | 計 |
|---|---|---|---|
| AIxSuture | 314 | 0 | 314 |
| 2024 challenge | 329（うち15本はラベル欠落のexpert） | 50 | 379 |
| 2024 + experts | 329（フルラベル） | 50 | 379 |
| 2025 challenge | 349 | 59 | 408 |

### expertデータの追加収録（2024）

AIxSutureはexpert（GRS>32）動画が乏しいため、深層学習モデルがexpert性能を認識できるか検証する目的で追加収録した。

- **30名のexpert**（5年以上の経験を持つ歯科外科レジデント）＋**35名の学生**を、原研究と同条件で各1回収録
- 3名のexpert評価者がOSATSで評価（うち1名は原注釈と重複）
- **GRS>32は学生による実施でもexpertクラスに分類**される（分類タスクの定義上）
- 15本のexpertを訓練、残り50本をテストに割当。技術的エラーにより2024時点では追加15本のOSATSラベルが参加者に未提供 → 事後の「追加expertデータあり」版での再提出が許可された

### 2025での追加とキーポイント注釈（Task 3）

- Task 1/2向けに訓練20本・テスト9本を追加。intermediate/expertを増やしクラス不均衡を緩和（2024より平坦な分布）
- **Task 3（キーポイントトラッキング）向け注釈**: 全体の部分集合に対し、左右の手・scissors・needle holder・tweezers・needle のキーポイントを注釈
  - 訓練52本（**1 fpm**、ツール/手のセグメンテーションマスク付き）＋検証8本（**1 fps**）＋テスト16本（1 fps）、計1,816フレーム
  - 各キーポイントに可視性フラグ（visible / hidden / out-of-frame）。1名が注釈、2人目がレビュー（LabelBox使用）
  - スキルレベルで層化分割。**hidden約26.5%・out-of-frame約11.5%**（訓練集合）。針が最も頻繁に隠れ（小さく指で隠れやすい）、手は最もフレーム外/隠れが多い

> なお、4クラス分類（beginner/intermediate/proficient/**expert**）はOSSチャレンジ独自で、AIxSuture原論文の3クラス（novice/intermediate/proficient）とは異なる。詳細は[[entities/OSATS]]参照。

## 配布先・ファイル構成

2つの配布チャネルがある。（2026-05-26時点、公開メタデータ調査による）

### Zenodo — ベースのAIxSuture（314本）

- DOI: 10.5281/zenodo.7940583（https://zenodo.org/records/7940583）
- 公開 2023-05-11、v1.0、**合計 102.1 GB**、ライセンス **CC BY-NC-ND 4.0**
- ファイル一覧:

| ファイル | サイズ | 内容 |
|---|---|---|
| `OSATS.xlsx` | 84.7 kB | OSATS/GRSスコアのスプレッドシート |
| Packages 01〜11（zip 11本） | 合計 ~102 GB | 動画本体（mp4） |
| `LICENCE` | 546 B | ライセンス |
| `README` | 405 B | 説明 |

各ファイルにMD5チェックサム付き。

### Synapse — OSSチャレンジ拡張版

- プロジェクトルート: `syn54123724`「Open Suturing Skills Challenge」（2024-03-19作成、EndoVis/DKFZ配下）
- **論文がData Availabilityに記載した `syn58905622` は、プロジェクトではなく「Train」フォルダ**（2024-05-02作成、親=`syn54123724`）
- wikiサブページ: Data（`/wiki/626578`）、Results（`/wiki/629948`）、Task1/Task2
- 動画はVIDEO IDでmp4ファイル名とOSATSスプレッドシートを紐付け。スプレッドシートには STUDENT / GROUP / TIME / SUTURES（分類対象外）/ INVESTIGATOR 列を含む
- **評価者構成の痕跡**: Data wikiに「students rated by A, B, C; experts by A, D, E」とあり、expert追加収録時に新評価者 D・E が加わり A が原注釈と重複したことと整合する
- **Test フォルダは非公開**（署名でゲート）。訓練データのダウンロードに規約署名が必要で、テストは主催側マシンでクローズド評価（[[sources/OSS Challenge]]「データアクセスと評価方式」参照）

> 個別ファイル名レベルの完全な差分特定は、Synapseのファイル一覧取得が認証付きAPI（POST）を要し、かつテスト領域が署名ゲート下にあるため未確認。上記は公開エンティティメタデータ・wikiと論文記述からの再構成。
