# SQL 基礎まとめ

# テーブルエイリアス（alias）

```sql
SELECT u.name
FROM users u;
```

これは：

```sql
SELECT users.name
FROM users;
```

と同じ意味。

- `u` は `users` の別名
- `o` は `orders` の別名

JOIN時に短く書ける。

---

## JOINでの例

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o
  ON u.id = o.user_id;
```

---

## 自己JOINで重要

```sql
SELECT e.name, m.name
FROM employees e
JOIN employees m
  ON e.manager_id = m.id;
```

- `e` = employee
- `m` = manager

同じテーブルを複数回使うため alias が必要。

---

# 制約（Constraint）

DBに不正データを入れないためのルール。

---

# PRIMARY KEY（主キー）

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT
);
```

## 役割

各行を一意に識別する。

| id | name |
|---|---|
| 1 | 田中 |
| 2 | 佐藤 |

`id` がその行のID。

---

## 特徴

- 重複禁止
- NULL禁止

つまり：

```sql
id = 1
id = 1
```

は不可。

```sql
id = NULL
```

も不可。

---

# FOREIGN KEY（外部キー）

```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## 役割

別テーブルとの関係を保証する。

---

## イメージ

users:

| id | name |
|---|---|
| 1 | 田中 |
| 2 | 佐藤 |

orders:

| id | user_id |
|---|---|
| 10 | 1 |

`user_id=1` は `users.id=1` を参照。

---

## 効果

存在しない user を防げる。

```sql
INSERT INTO orders (user_id)
VALUES (999);
```

→ users に存在しなければエラー。

---

# CHECK制約（条件制約）

```sql
age INTEGER CHECK (age >= 0)
```

## 役割

条件を満たすデータのみ許可。

---

## 例

```sql
INSERT INTO users (age)
VALUES (-10);
```

→ エラー。

---

## よくある用途

```sql
CHECK (age >= 0)
```

```sql
CHECK (price > 0)
```

```sql
CHECK (status IN ('draft', 'published'))
```

---

# DROP と TRUNCATE

# DROP

```sql
DROP TABLE users;
```

## 意味

テーブルそのものを削除。

- データ消滅
- カラム定義消滅
- テーブル消滅

---

# TRUNCATE

```sql
TRUNCATE TABLE users;
```

## 意味

中身だけ削除。

- テーブルは残る
- データだけ消える

---

# DELETEとの違い

```sql
DELETE FROM users;
```

これは：

- 1行ずつ削除
- WHERE可能
- 遅い場合あり

TRUNCATEは：

- 高速
- テーブル初期化向き

---

# INDEX

## 目的

検索高速化。

---

# INDEXなし

```sql
SELECT *
FROM users
WHERE email = 'a@example.com';
```

DBは全行探索する。

→ フルスキャン。

---

# INDEXあり

```sql
CREATE INDEX idx_users_email
ON users(email);
```

DBは索引を使って高速探索できる。

---

# イメージ

本の索引。

- INDEXなし → 最初から読む
- INDEXあり → ページ番号へ直接飛ぶ

---

# 内部構造

多くのDBは B+Tree を使う。

探索コスト：

- INDEXなし：O(n)
- INDEXあり：O(log n)

---

# デメリット

INSERT/UPDATE時：

- INDEX更新必要
- 書き込み少し遅くなる

---

# VIEW

## 一言

保存されたSELECT文。

---

## 例

```sql
CREATE VIEW active_users AS
SELECT *
FROM users
WHERE deleted_at IS NULL;
```

以後：

```sql
SELECT *
FROM active_users;
```

を書くと、

内部的には：

```sql
SELECT *
FROM users
WHERE deleted_at IS NULL;
```

が実行される。

---

# 用途

## 複雑SQL隠蔽

## 権限制御

```sql
CREATE VIEW public_users AS
SELECT id, name
FROM users;
```

emailなどを隠せる。

---

# WITH / CTE

CTE = Common Table Expression

「一時的な名前付きテーブル」。

---

# 元コード

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

---

# ステップ1

```sql
SELECT user_id, SUM(amount) AS total_amount
FROM orders
GROUP BY user_id
```

orders:

| user_id | amount |
|---|---|
| 1 | 100 |
| 1 | 300 |
| 2 | 500 |

↓

| user_id | total_amount |
|---|---|
| 1 | 400 |
| 2 | 500 |

この結果を：

```sql
user_totals
```

という一時テーブルとして扱う。

---

# ステップ2

```sql
SELECT users.name, user_totals.total_amount
FROM users
JOIN user_totals
  ON users.id = user_totals.user_id;
```

users:

| id | name |
|---|---|
| 1 | 田中 |
| 2 | 佐藤 |

↓

結果：

| name | total_amount |
|---|---|
| 田中 | 400 |
| 佐藤 | 500 |

---

# WITHのメリット

- SQLを段階分割できる
- 可読性向上
- 同じ計算を再利用可能

---

# トランザクション

## 一言

処理を「ひとまとまり」として扱う。

---

# 銀行送金例

Aから減算：

```sql
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;
```

Bへ加算：

```sql
UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;
```

途中失敗すると壊れる。

---

# トランザクション使用

```sql
BEGIN;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT;
```

---

# 意味

- 全成功 → COMMIT
- 失敗 → ROLLBACK

---

# ROLLBACK

```sql
ROLLBACK;
```

実行前状態へ戻す。

---

# ACID特性

- Atomicity
- Consistency
- Isolation
- Durability

DBの重要性質。

---

# 数値関数

# ROUND

四捨五入。

```sql
SELECT ROUND(3.7);
```

→ 4

---

# FLOOR

切り捨て。

```sql
SELECT FLOOR(3.9);
```

→ 3

---

# CEIL / CEILING

切り上げ。

```sql
SELECT CEIL(3.1);
```

→ 4

---

# ABS

絶対値。

```sql
SELECT ABS(-10);
```

→ 10

---

# ウィンドウ関数

## 普通のSUMとの違い

通常：

```sql
SELECT user_id, SUM(amount)
FROM orders
GROUP BY user_id;
```

→ 行が潰れる。

---

# ウィンドウ関数

行を残したまま集約。

---

# SUM OVER

orders:

| user_id | amount |
|---|---|
| 1 | 100 |
| 1 | 300 |
| 2 | 500 |

```sql
SELECT
  user_id,
  amount,
  SUM(amount) OVER (PARTITION BY user_id)
FROM orders;
```

結果：

| user_id | amount | sum |
|---|---|---|
| 1 | 100 | 400 |
| 1 | 300 | 400 |
| 2 | 500 | 500 |

---

# PARTITION BY

グループ分け。

---

# ROW_NUMBER

```sql
ROW_NUMBER() OVER (
  PARTITION BY user_id
  ORDER BY created_at DESC
)
```

ユーザーごとに：

- 新しい順
- 1,2,3...

を振る。

---

# 用途

「各ユーザーの最新1件」

---

# RANK

```sql
RANK() OVER (ORDER BY amount DESC)
```

順位付け。

---

## 例

| amount | rank |
|---|---|
| 100 | 1 |
| 90 | 2 |
| 90 | 2 |
| 80 | 4 |

同順位あり。
