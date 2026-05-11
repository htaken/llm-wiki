---
title: SQL基礎まとめ
type: source
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, データベース, 基礎]
sources: [sql-basic.md]
aliases: [SQL基礎, SQL基本]
---

# SQL基礎まとめ

SQLの基本構文と主要概念を網羅した学習ノート。RDBの操作に必要な要素（エイリアス、制約、削除系コマンド、INDEX、VIEW、CTE、トランザクション、数値関数、ウィンドウ関数）を扱う。

## 出典

- ファイル: `raw/sql-basic.md`
- 種別: 個人の学習ノート

## 目次

1. テーブルエイリアス（alias）
2. 制約（PRIMARY KEY / FOREIGN KEY / CHECK）
3. DROP / TRUNCATE / DELETE
4. INDEX
5. VIEW
6. WITH / CTE
7. トランザクション・ACID
8. 数値関数（ROUND/FLOOR/CEIL/ABS）
9. ウィンドウ関数（SUM OVER / ROW_NUMBER / RANK）

---

## 1. テーブルエイリアス

`FROM users u` のように短縮名を付ける記法。JOINや自己JOINで必須。

```sql
SELECT u.name, o.amount
FROM users u
JOIN orders o
  ON u.id = o.user_id;
```

自己JOIN（同じテーブルを複数回参照）では必ずエイリアスが必要:

```sql
SELECT e.name, m.name
FROM employees e
JOIN employees m
  ON e.manager_id = m.id;
```

詳細: [[concepts/テーブルエイリアスとJOIN]]

---

## 2. 制約（Constraint）

DBに不正データを入れないためのルール。代表的な3種:

- **PRIMARY KEY**: 各行を一意に識別。重複・NULL不可
- **FOREIGN KEY**: 別テーブルとの参照整合性を保証
- **CHECK**: 条件を満たすデータのみ許可（例: `age >= 0`）

詳細: [[concepts/SQL制約]]

---

## 3. DROP / TRUNCATE / DELETE

| 命令 | 対象 | WHERE | 速度 |
|---|---|---|---|
| `DROP TABLE` | テーブル自体を削除 | 不可 | - |
| `TRUNCATE TABLE` | 全行削除（テーブルは残る） | 不可 | 高速 |
| `DELETE FROM` | 行を削除（条件指定可） | 可 | 行数に依存 |

詳細: [[concepts/SQLテーブル削除コマンド]]

---

## 4. INDEX

検索の高速化。多くのDBは B+Tree を内部構造として使い、探索コストを O(n) から O(log n) に改善する。

```sql
CREATE INDEX idx_users_email ON users(email);
```

トレードオフ: INSERT/UPDATE時にINDEXも更新されるため、書き込みが遅くなる。

詳細: [[concepts/INDEX]]

---

## 5. VIEW

保存されたSELECT文。複雑なSQLの隠蔽や権限制御（特定カラムを隠す）に使える。

```sql
CREATE VIEW active_users AS
SELECT * FROM users WHERE deleted_at IS NULL;
```

詳細: [[concepts/VIEW]]

---

## 6. WITH / CTE

CTE（Common Table Expression）= 一時的な名前付きテーブル。クエリを段階分割でき可読性が向上する。

```sql
WITH user_totals AS (
  SELECT user_id, SUM(amount) AS total_amount
  FROM orders
  GROUP BY user_id
)
SELECT users.name, user_totals.total_amount
FROM users
JOIN user_totals ON users.id = user_totals.user_id;
```

詳細: [[concepts/CTE]]

---

## 7. トランザクション・ACID

複数SQLを「ひとまとまり」として扱い、途中で失敗した場合はROLLBACKで実行前状態へ戻せる。

```sql
BEGIN;
UPDATE accounts SET balance = balance - 1000 WHERE id = 1;
UPDATE accounts SET balance = balance + 1000 WHERE id = 2;
COMMIT;
```

ACID特性:
- **Atomicity**（原子性）
- **Consistency**（一貫性）
- **Isolation**（独立性）
- **Durability**（永続性）

詳細: [[concepts/トランザクション]]

---

## 8. 数値関数

| 関数 | 動作 | 例 |
|---|---|---|
| `ROUND(x)` | 四捨五入 | `ROUND(3.7)` → 4 |
| `FLOOR(x)` | 切り捨て | `FLOOR(3.9)` → 3 |
| `CEIL(x)` / `CEILING(x)` | 切り上げ | `CEIL(3.1)` → 4 |
| `ABS(x)` | 絶対値 | `ABS(-10)` → 10 |

---

## 9. ウィンドウ関数

`GROUP BY` と異なり、**行を残したまま**集約値を各行に付与する。`OVER (PARTITION BY ...)` で対象範囲を指定。

```sql
SELECT
  user_id,
  amount,
  SUM(amount) OVER (PARTITION BY user_id)
FROM orders;
```

主な関数:
- `SUM/AVG/COUNT OVER`: 集約値を保ったまま付与
- `ROW_NUMBER()`: 各パーティション内で1,2,3...を振る（例: 「各ユーザーの最新1件」）
- `RANK()`: 順位付け（同順位あり）

詳細: [[concepts/ウィンドウ関数]]

---

## キーポイント

- **制約**はDBレイヤでデータ整合性を担保する仕組み（アプリ側に依存しない）
- **INDEX**は読み込み高速化と書き込みコストのトレードオフ
- **VIEW/CTE**はクエリの再利用・段階分割の手段（VIEWは永続、CTEは1クエリ内のみ）
- **トランザクション**はACIDによってデータの一貫性を保証する基本機構
- **ウィンドウ関数**は集約と詳細行の両方が欲しいケースで強力
