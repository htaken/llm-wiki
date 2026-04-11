---
title: OSATS
type: entity
created: 2026-04-11
updated: 2026-04-11
tags: [外科技術評価, 評価尺度, 医学教育]
sources: [AIxSuture:vision-based-assessment-of-open-suturing-skills.md, Automated-measurement-extraction-for-assessing-simple-suture-quality-in-medical-education.md]
aliases: [Objective Structured Assessment of Technical Skills]
---

# OSATS (Objective Structured Assessment of Technical Skills)

外科手術の技術スキルを客観的に評価するための標準化された評価尺度。Martin et al. (1997) によって提案された。

## 概要

OSATSは8つのスキルカテゴリから構成され、各カテゴリをリッカート尺度で評価する。全カテゴリのスコアの合計がGlobal Rating Score（GRS）となり、8〜40点の範囲をとる。

[[entities/AIxSuture データセット]]では、GRSに基づいて以下の3クラスに分類されている:
- **Novice**: GRS < 16
- **Intermediate**: 16 ≤ GRS < 24
- **Proficient**: GRS ≥ 24（臨床的に「技術を習得した」と見なされる閾値）

## 評価者間の一致度

AIxSuture データセットでは3名の独立評価者が使用し、平均Pearson相関係数 > 0.8を達成。ただし評価者ごとに軽度のバイアスがあり、特に高スキルレベルの評価で不一致が大きくなる傾向が報告されている。

## 縫合品質評価での位置づけ

[[sources/Automated measurement extraction for suture quality]]では、OSATSのような主観的評価基準を補完する客観的計測値の自動抽出が目指されている。OSATSは指導医による観察評価が前提であり、計測値ベースの自動評価と組み合わせることで、学生の自主練習にもフィードバックを提供できる可能性がある。

## 関連ページ

- [[concepts/外科技術自動評価]]
- [[sources/AIxSuture]]
- [[sources/Automated measurement extraction for suture quality]]
