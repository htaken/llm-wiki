---
title: CTE
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, クエリ構成]
sources: [sql-basic.md]
aliases: [Common Table Expression, WITH句, WITH]
---

# CTE（Common Table Expression）

`WITH` 句で定義する **一時的な名前付きテーブル**。クエリ内でのみ参照できる。

## 基本構文

```sql
WITH user_totals AS (
  SELECT user_id, SUM(amount) AS total_amount
  FROM orders
  GROUP BY user_id
)
SELECT users.name, user_totals.total_amount
FROM users
JOIN user_totals
  ON users.id = user_totals.user_id;
```

## 動作イメージ

### ステップ1: CTEを評価

`orders` から user_id ごとの合計を計算:

| user_id | amount |
|---|---|
| 1 | 100 |
| 1 | 300 |
| 2 | 500 |

↓ `GROUP BY user_id` + `SUM(amount)`

| user_id | total_amount |
|---|---|
| 1 | 400 |
| 2 | 500 |

これを `user_totals` という一時テーブルとして以後扱える。

### ステップ2: メインクエリ

`users` テーブル:

| id | name |
|---|---|
| 1 | 田中 |
| 2 | 佐藤 |

↓ JOIN

| name | total_amount |
|---|---|
| 田中 | 400 |
| 佐藤 | 500 |

## メリット

- **段階分割**: 複雑なクエリを小さなステップに分けて記述できる
- **可読性向上**: 中間結果に名前が付くので意図が明確になる
- **再利用**: 同じ計算を1クエリ内で複数回参照できる（サブクエリの繰り返しを避けられる）

## [[concepts/VIEW]] との違い

- VIEW: DBに永続化され、別クエリからも参照可
- CTE: 単一クエリ内のみ有効（一時的）

→ 単発の段階分割ならCTE、複数クエリで使い回すならVIEW。

## 参考

- ソース: [[sources/SQL基礎まとめ]]
