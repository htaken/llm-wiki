---
title: SQLテーブル削除コマンド
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, DDL, DML]
sources: [sql-basic.md]
aliases: [DROP, TRUNCATE, DELETE]
---

# DROP / TRUNCATE / DELETE

データを消す3つのコマンドの違いを整理する。

## 比較表

| | 対象 | WHERE指定 | 速度 | テーブル定義 |
|---|---|---|---|---|
| `DROP TABLE` | テーブル自体 | 不可 | - | 消える |
| `TRUNCATE TABLE` | 全行 | 不可 | 高速 | 残る |
| `DELETE FROM` | 行（条件指定可） | 可 | 行数に依存 | 残る |

## DROP

```sql
DROP TABLE users;
```

テーブルそのものを消す:
- データが消滅
- カラム定義も消滅
- テーブル自体が消滅

→ 元に戻すには再度 `CREATE TABLE` が必要。

## TRUNCATE

```sql
TRUNCATE TABLE users;
```

中身だけ消す:
- テーブルは残る
- データだけ消える
- 高速（行ごとのログを書かないため）

→ テーブルを「初期化」する用途に向く。

## DELETE

```sql
DELETE FROM users;
DELETE FROM users WHERE deleted_at IS NOT NULL;
```

- 1行ずつ削除する
- `WHERE` で条件指定可能（部分削除）
- トランザクションでROLLBACK可能
- 全行削除する場合はTRUNCATEより遅いことが多い

## 使い分け

- **条件付きで一部消す** → `DELETE`
- **テーブル丸ごと初期化（高速）** → `TRUNCATE`
- **テーブル自体を消す** → `DROP`

## 参考

- ソース: [[sources/SQL基礎まとめ]]
