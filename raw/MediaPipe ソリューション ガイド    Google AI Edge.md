---
title: "MediaPipe ソリューション ガイド  |  Google AI Edge"
source: "https://ai.google.dev/edge/mediapipe/solutions/guide?hl=ja"
author:
published:
created: 2026-05-26
description:
tags:
  - "clippings"
---
MediaPipe Solutions は、アプリケーションで人工知能（AI）と機械学習（ML）の手法を迅速に適用するためのライブラリとツールのスイートを提供します。これらのソリューションは、アプリケーションにすぐに組み込み、ニーズに合わせてカスタマイズして、複数の開発プラットフォームで使用できます。MediaPipe Solutions は MediaPipe [オープンソース プロジェクト](https://github.com/google/mediapipe) の一部であるため、アプリケーションのニーズに合わせてソリューション コードをさらにカスタマイズできます。MediaPipe Solutions スイートには、次のものが含まれています。

![MediaPipe Solutions、Studio、Model Maker](https://ai.google.dev/static/edge/mediapipe/images/solutions/overview-diagram.svg?hl=ja)

これらのライブラリとリソースは、各 MediaPipe ソリューションのコア機能を提供します。

- **MediaPipe Tasks**: ソリューションをデプロイするためのクロス プラットフォーム API とライブラリ。 [詳細](https://ai.google.dev/edge/mediapipe/solutions/tasks?hl=ja)
- **MediaPipe モデル**: 各ソリューションで使用できる、事前トレーニング済みのすぐに実行可能なモデル。

これらのツールを使用すると、ソリューションをカスタマイズして評価できます。

- **MediaPipe Model Maker**: データを使用してソリューションのモデルをカスタマイズします。 [詳細](https://ai.google.dev/edge/mediapipe/solutions/model_maker?hl=ja)
- **MediaPipe Studio**: ブラウザでソリューションを可視化、評価、ベンチマークします。 [詳細](https://ai.google.dev/edge/mediapipe/solutions/studio?hl=ja)

## 利用可能なソリューション

MediaPipe Solutions は複数のプラットフォームで利用できます。各ソリューションには 1 つ以上のモデルが含まれており、一部のソリューションではモデルをカスタマイズすることもできます。次のリストに、サポートされている各プラットフォームで利用可能なソリューションと、Model Maker を使用してモデルをカスタマイズできるかどうかを示します。

| 解決策                                                                                                     | Android | Web | Python | iOS | モデルをカスタマイズする |
| ------------------------------------------------------------------------------------------------------- | ------- | --- | ------ | --- | ------------ |
| [LLM Inference API](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference?hl=ja)           |         |     |        |     |              |
| [オブジェクト検出](https://ai.google.dev/edge/mediapipe/solutions/vision/object_detector?hl=ja)                 |         |     |        |     |              |
| [画像分類](https://ai.google.dev/edge/mediapipe/solutions/vision/image_classifier?hl=ja)                    |         |     |        |     |              |
| [画像セグメンテーション](https://ai.google.dev/edge/mediapipe/solutions/vision/image_segmenter?hl=ja)              |         |     |        |     |              |
| [インタラクティブなセグメンテーション](https://ai.google.dev/edge/mediapipe/solutions/vision/interactive_segmenter?hl=ja) |         |     |        |     |              |
| [手のランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker?hl=ja)               |         |     |        |     |              |
| [ジェスチャー認識](https://ai.google.dev/edge/mediapipe/solutions/vision/gesture_recognizer?hl=ja)              |         |     |        |     |              |
| [画像エンベディング](https://ai.google.dev/edge/mediapipe/solutions/vision/image_embedder?hl=ja)                 |         |     |        |     |              |
| [顔検出](https://ai.google.dev/edge/mediapipe/solutions/vision/face_detector?hl=ja)                        |         |     |        |     |              |
| [顔のランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/face_landmarker?hl=ja)               |         |     |        |     |              |
| [ポーズのランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/pose_landmarker?hl=ja)             |         |     |        |     |              |
| [画像生成](https://ai.google.dev/edge/mediapipe/solutions/vision/image_generator?hl=ja)                     |         |     |        |     |              |
| [テキスト分類](https://ai.google.dev/edge/mediapipe/solutions/text/text_classifier?hl=ja)                     |         |     |        |     |              |
| [テキスト エンベディング](https://ai.google.dev/edge/mediapipe/solutions/text/text_embedder?hl=ja)                 |         |     |        |     |              |
| [言語検出ツール](https://ai.google.dev/edge/mediapipe/solutions/text/language_detector?hl=ja)                  |         |     |        |     |              |
| [音声分類](https://ai.google.dev/edge/mediapipe/solutions/audio/audio_classifier?hl=ja)                     |         |     |        |     |              |

## 始める

MediaPipe Solutions を始めるには、左側のナビゲーション ツリーに表示されているタスク（ [ビジョン](https://ai.google.dev/edge/mediapipe/solutions/vision/object_detector?hl=ja) 、 [テキスト](https://ai.google.dev/edge/mediapipe/solutions/text/text_classifier?hl=ja) 、 [音声](https://ai.google.dev/edge/mediapipe/solutions/audio/audio_classifier?hl=ja) など）を選択します。MediaPipe Tasks で使用する開発環境の設定についてサポートが必要な場合は、 [Android](https://ai.google.dev/edge/mediapipe/solutions/setup_android?hl=ja) 、 [ウェブアプリ](https://ai.google.dev/edge/mediapipe/solutions/setup_web?hl=ja) 、 [Python](https://ai.google.dev/edge/mediapipe/solutions/setup_python?hl=ja) の設定ガイドをご覧ください。

## 従来のソリューション

2023 年 3 月 1 日をもって、以下の MediaPipe レガシー ソリューションのサポートを終了しました。他のすべての MediaPipe レガシー ソリューションは、新しい MediaPipe ソリューションにアップグレードされます。詳しくは、以下のリストをご覧ください。すべての MediaPipe Legacy Solutions の [コード リポジトリ](https://github.com/google/mediapipe/tree/master/mediapipe) とビルド済みバイナリは、引き続き現状のまま提供されます。

| 以前のソリューション | ステータス | 新しい MediaPipe ソリューション |
| --- | --- | --- |
| 顔検出（ [詳細](https://github.com/google/mediapipe/blob/master/docs/solutions/face_detection.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/face_detector?hl=ja) | [顔検出](https://ai.google.dev/edge/mediapipe/solutions/vision/face_detector?hl=ja) |
| Face Mesh（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/face_mesh.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/face_landmarker?hl=ja) | [顔のランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/face_landmarker?hl=ja) |
| Iris（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/iris.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/face_landmarker?hl=ja) | [顔のランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/face_landmarker?hl=ja) |
| 手（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/hands.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker?hl=ja) | [手のランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker?hl=ja) |
| ポーズ（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/pose.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/pose_landmarker?hl=ja) | [ポーズのランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/pose_landmarker?hl=ja) |
| 総合的（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/holistic.md) ） | アップグレード | [ホリスティック ランドマーク検出](https://ai.google.dev/edge/mediapipe/solutions/vision/holistic_landmarker?hl=ja) |
| セルフィーのセグメンテーション（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/selfie_segmentation.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/image_segmenter?hl=ja) | [画像セグメンテーション](https://ai.google.dev/edge/mediapipe/solutions/vision/image_segmenter?hl=ja) |
| 髪のセグメンテーション（ [詳細](https://github.com/google/mediapipe/blob/master/docs/solutions/hair_segmentation.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/image_segmenter?hl=ja) | [画像セグメンテーション](https://ai.google.dev/edge/mediapipe/solutions/vision/image_segmenter?hl=ja) |
| オブジェクト検出（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/object_detection.md) ） | [アップグレード済み](https://ai.google.dev/edge/mediapipe/solutions/vision/object_detector?hl=ja) | [オブジェクト検出](https://ai.google.dev/edge/mediapipe/solutions/vision/object_detector?hl=ja) |
| ボックスの追跡（ [詳細](https://github.com/google/mediapipe/blob/master/docs/solutions/box_tracking.md) ） | サポート終了 |  |
| インスタント モーション トラッキング（ [詳細](https://github.com/google/mediapipe/blob/master/docs/solutions/instant_motion_tracking.md) ） | サポート終了 |  |
| Objectron（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/objectron.md) ） | サポート終了 |  |
| KNIFT（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/knift.md) ） | サポート終了 |  |
| AutoFlip（ [情報](https://github.com/google/mediapipe/blob/master/docs/solutions/autoflip.md) ） | サポート終了 |  |
| MediaSequence（ [info](https://github.com/google/mediapipe/blob/master/docs/solutions/media_sequence.md) ） | サポート終了 |  |
| YouTube 8M（ [詳細](https://github.com/google/mediapipe/blob/master/docs/solutions/youtube_8m.md) ） | サポート終了 |  |