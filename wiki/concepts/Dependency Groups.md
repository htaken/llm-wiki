---
title: Dependency Groups
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, 依存関係, 開発依存]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [dependency-groups, dev-dependencies, 開発用依存関係]
---

# Dependency Groups

`pyproject.toml` の `[dependency-groups]` セクションに記述する、**開発時にのみ必要な依存を複数グループに分けて管理する機能**。[[entities/uv]] v0.4.27で導入された。

## 動機

従来は単一の `dev-dependencies` しかなかったため、lint用・test用・docs用などを混ぜざるを得なかった。たとえばCIでlintジョブだけ動かす際にも、pytestや関連ライブラリまでインストールしてしまい無駄が出る。

Dependency groupsを使えば:

- lintジョブでは `uv sync --group lint` でruff等のみ入れる
- testジョブでは `uv sync --group test` でpytest等のみ入れる
- ローカル開発では `uv sync --all-groups` で全部入れる

## pyproject.toml での書き方

```toml
[project]
name = "project"
dependencies = []

[dependency-groups]
lint = ["ruff>=0.8.2"]
test = ["pytest>=8.3.4"]
```

## uvでの操作

```bash
uv add ruff --group lint              # lint グループに追加
uv add pytest --group test            # test グループに追加
uv add --dev <pkg>                    # 従来通り。`dev` グループに追加される
uv sync --group lint                  # 個別インストール
uv sync --all-groups                  # 全グループインストール
```

## default-groups

`uv sync`（無引数）で含めるグループのデフォルトを指定できる:

```toml
[tool.uv]
default-groups = ["dev", "lint"]
```

これで `uv sync` 単体で `dev` と `lint` の依存が入る。

## [[concepts/Optional Dependencies]] との使い分け

| 観点 | Optional Dependencies | Dependency Groups |
|------|------------------------|-------------------|
| pyproject.tomlのセクション | `[project.optional-dependencies]` | `[dependency-groups]` |
| 配布物（wheel）に含まれるか | **含まれる**（ユーザーが選べる） | **含まれない** |
| 想定利用者 | ライブラリのエンドユーザー | 開発者 |
| 典型例 | `pandas[excel]`, `torch[cu124]` | `lint`, `test`, `docs` |
| uvコマンド | `uv sync --extra <name>` | `uv sync --group <name>` |

**判断基準**: そのパッケージを `pip install yourlib[X]` でエンドユーザーが入れることがあるか? あれば optional-dependencies、なければ dependency-groups。lint/testは開発者しか使わないので groups が正解。

## 関連

- [[entities/uv]]
- [[concepts/Optional Dependencies]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
