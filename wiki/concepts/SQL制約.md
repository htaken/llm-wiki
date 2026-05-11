---
title: SQL制約
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, データ整合性]
sources: [sql-basic.md]
aliases: [Constraint, 制約]
---

# SQL制約（Constraint）

DBに不正データが入るのを防ぐためのルール。アプリケーション側のバリデーションに頼らず、**DBレイヤで整合性を担保**する仕組み。

## 主要な制約

### PRIMARY KEY（主キー）

各行を一意に識別するためのカラム（または組み合わせ）。

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT
);
```

特徴:
- **重複禁止**
- **NULL禁止**

| id | name |
|---|---|
| 1 | 田中 |
| 2 | 佐藤 |

→ `id` がその行を一意に指す。

### FOREIGN KEY（外部キー）

別テーブルとの関係（参照整合性）を保証する。

```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

効果: 存在しないユーザーへの参照を防げる。

```sql
INSERT INTO orders (user_id) VALUES (999);
-- users.id = 999 が存在しなければエラー
```

### CHECK制約

任意の条件を満たすデータのみ許可する。

```sql
age INTEGER CHECK (age >= 0)
```

よくある用途:

```sql
CHECK (age >= 0)
CHECK (price > 0)
CHECK (status IN ('draft', 'published'))
```

## なぜDBレイヤで制約をかけるか

- アプリ側のバグや別経路（手動INSERT等）での不正データ混入を防げる
- 一貫性が単一の真実の場所（DB）で保証される
- 関連: [[concepts/トランザクション]] と組み合わせるとACIDのConsistencyの中核を担う

## 参考

- ソース: [[sources/SQL基礎まとめ]]
