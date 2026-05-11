---
title: Index
type: index
updated: 2026-05-11
---

# Wiki Index

## ソース
- [[sources/AIxSuture]] — 開放手術の縫合技術を動画ベースで自動評価する初のエンドツーエンド手法。AIxSutureデータセットとTSN+I3D/Video Swinベンチマーク
- [[sources/Automated measurement extraction for suture quality]] — 縫合画像からの幾何学的計測値自動抽出システム（Mask R-CNN + 線形割当）
- [[sources/SQL基礎まとめ]] — SQLの基本構文と主要概念（エイリアス、制約、INDEX、VIEW、CTE、トランザクション、ウィンドウ関数）

## エンティティ
- [[entities/AIxSuture データセット]] — 314本の開放手術縫合訓練動画データセット（OSATS評価付き）
- [[entities/Detectron2]] — Meta AI Researchの物体検出・セグメンテーションライブラリ
- [[entities/I3D]] — Inceptionベースの3D CNN動画認識モデル
- [[entities/Mask R-CNN]] — インスタンスセグメンテーションフレームワーク（He et al., 2017）
- [[entities/OSATS]] — 外科技術の客観的評価尺度（8カテゴリ、GRS 8〜40点）
- [[entities/Simple Suture Datasets]] — Simple interrupted suture画像データセット（silk/nylon、計240画像）
- [[entities/Temporal Segment Network]] — 動画を時間セグメントに分割して行動認識するフレームワーク（TSN）
- [[entities/Video Swin Transformer]] — 時空間シフトウィンドウ機構を持つ動画Transformer

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
