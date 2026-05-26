---
title: OSATS
type: entity
created: 2026-04-11
updated: 2026-05-26
tags: [外科技術評価, 評価尺度, 医学教育]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md, Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md, 2605.22200v1.md]
aliases: [Objective Structured Assessment of Technical Skills, GRS, Global Rating Score]
---

# OSATS (Objective Structured Assessment of Technical Skills)

外科手術の技術スキルを客観的に評価するための標準化された評価尺度。Martin et al. (1997) によって提案された。

## 概要

OSATSは8つのスキルカテゴリから構成され、各カテゴリを5段階リッカート尺度で評価する。全カテゴリのスコアの合計がGlobal Rating Score（GRS）となり、8〜40点の範囲をとる。GRSは訓練プログラムや介入の評価に頻用される総合指標。

### 8カテゴリ

[[sources/OSS Challenge]]で列挙された8カテゴリ（各1〜5点）:
1. respect for tissue（組織への配慮）
2. time and motion（時間と動作）
3. instrument handling（器具の扱い）
4. flow of operation（手術の流れ）
5. suture technique（縫合技術）
6. final quality（最終的な品質）
7. knowledge of procedure（手技の知識）
8. overall performance（総合的なパフォーマンス）

## スキルレベルへの分類（GRSベース）

GRSをスキルレベルに離散化する際、データセット/タスクによりクラス定義が異なる:

| | クラス数 | 定義 |
|---|---|---|
| [[entities/AIxSuture データセット]]（原論文） | 3 | Novice (GRS<16) / Intermediate (16≤GRS<24) / Proficient (GRS≥24) |
| [[sources/OSS Challenge]] Task 1 | 4 | beginner (GRS<16) / intermediate (16≤GRS<24) / proficient (24≤GRS<32) / **expert (GRS≥32)** |

OSSチャレンジでは expert（GRS≥32）クラスを新設。GRS≥32は学生による実施でもexpertに分類される。

## OSATS予測の難しさ（OSSチャレンジの知見）

[[sources/OSS Challenge]] Task 2（8カテゴリ個別予測）は、Task 1（GRS分類）より全チームで性能が大きく低下した。理由:
- 単一出力→多出力問題への変化（各サブカテゴリが異なる性能側面に依存）
- 4クラス→5クラスで難度上昇
- **カテゴリ別の評価者間一致度（ICC）は集約GRSより低く**、ラベルノイズが増す

ICC(A, k=3) では GRS が 0.92〜0.94 と高いのに対し、OSATSカテゴリ別は 0.79〜0.91。最高は knowledge of specific procedure（0.91）、最低は respect for tissue（0.79）。

## 評価者間の一致度

AIxSuture データセットでは3名の独立評価者が使用し、平均Pearson相関係数 > 0.8を達成。ただし評価者ごとに軽度のバイアスがあり、特に高スキルレベルの評価で不一致が大きくなる傾向が報告されている。

## 縫合品質評価での位置づけ

[[sources/Automated measurement extraction for suture quality]]では、OSATSのような主観的評価基準を補完する客観的計測値の自動抽出が目指されている。OSATSは指導医による観察評価が前提であり、計測値ベースの自動評価と組み合わせることで、学生の自主練習にもフィードバックを提供できる可能性がある。

## 関連ページ

- [[concepts/外科技術自動評価]]
- [[sources/AIxSuture]]
- [[sources/OSS Challenge]]
- [[sources/Automated measurement extraction for suture quality]]
