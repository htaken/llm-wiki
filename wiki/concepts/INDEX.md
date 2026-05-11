---
title: INDEX
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [SQL, RDB, パフォーマンス]
sources: [sql-basic.md]
aliases: [インデックス, SQL INDEX]
---

# INDEX

DBの検索を高速化する索引構造。

## 基本

INDEXなしの場合、DBは条件にマッチする行を探すためテーブル全体をスキャンする（フルスキャン）。

```sql
SELECT * FROM users WHERE email = 'a@example.com';
```

INDEXを作成すると、索引を使って高速に該当行へジャンプできる:

```sql
CREATE INDEX idx_users_email ON users(email);
```

## イメージ

本の索引と同じ:
- INDEXなし → 最初のページから順に読む
- INDEXあり → 索引でページ番号を引いて直接飛ぶ

## 内部構造

多くのRDB（PostgreSQL, MySQL等）は **B+Tree** をINDEXの内部構造として使う。

| 操作 | INDEXなし | INDEXあり |
|---|---|---|
| 検索 | O(n) | O(log n) |

## デメリット

- INSERT/UPDATE時にINDEXも更新する必要がある
- そのため**書き込みが少し遅くなる**
- ストレージも追加で消費する

→ 読み込み速度と書き込み速度のトレードオフ。検索条件として頻繁に使うカラムにのみ張るのが基本。

## 参考

- ソース: [[sources/SQL基礎まとめ]]
