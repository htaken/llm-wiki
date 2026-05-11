---
title: VIEW
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, 抽象化]
sources: [sql-basic.md]
aliases: [ビュー, SQL VIEW]
---

# VIEW

保存されたSELECT文。仮想的なテーブルとして扱える。

## 例

```sql
CREATE VIEW active_users AS
SELECT *
FROM users
WHERE deleted_at IS NULL;
```

定義後、通常のテーブルのように参照できる:

```sql
SELECT * FROM active_users;
```

内部的には毎回もとのSELECT文が実行される:

```sql
SELECT * FROM users WHERE deleted_at IS NULL;
```

## 用途

### 1. 複雑SQLの隠蔽

複数JOINや集計を含むクエリをVIEWにすると、利用側はシンプルなSELECTで済む。

### 2. 権限制御

特定カラムを隠したVIEWを作って、機密情報へのアクセスを制限できる。

```sql
CREATE VIEW public_users AS
SELECT id, name
FROM users;
```

→ `email` などのセンシティブなカラムをVIEW経由では参照できなくする。

## VIEWと[[concepts/CTE]]の違い

| | VIEW | CTE（WITH） |
|---|---|---|
| 永続性 | DB上に保存 | クエリ内のみ |
| 再利用 | 別クエリからも参照可 | 同一クエリ内のみ |
| 用途 | 共有・権限制御 | クエリの段階分割 |

## 参考

- ソース: [[sources/SQL基礎まとめ]]
