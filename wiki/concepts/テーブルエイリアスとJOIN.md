---
title: テーブルエイリアスとJOIN
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, JOIN]
sources: [sql-basic.md]
aliases: [テーブル別名, alias, SQL alias]
---

# テーブルエイリアスとJOIN

`FROM users u` のように **テーブルに短縮名を付ける** 記法。JOINの記述を短くしたり、自己JOINで必須となる。

## 基本

```sql
SELECT u.name
FROM users u;
```

これは下記と同じ意味:

```sql
SELECT users.name
FROM users;
```

`u` が `users` の別名。

## JOINでの例

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o
  ON u.id = o.user_id;
```

- `u` = users
- `o` = orders

長いテーブル名を毎回書かずに済む。

## 自己JOIN（重要）

同じテーブルを複数回参照する場合、エイリアスが**必須**（区別できないため）。

```sql
SELECT e.name, m.name
FROM employees e
JOIN employees m
  ON e.manager_id = m.id;
```

- `e` = employee（部下）
- `m` = manager（上司）

社員と上司の関係を1つの `employees` テーブルから引き出している。

## 命名のコツ

- 1文字（`u`, `o`, `e`, `m`）で短く
- テーブル名の先頭1文字を使うと意味も伝わる
- ただし読み手が混乱する場合は意味のある略語にする（`emp`, `mgr` 等）

## 参考

- ソース: [[sources/SQL基礎まとめ]]
