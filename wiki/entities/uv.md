---
title: uv
type: entity
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, ツール, Astral]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [uv (Python)]
---

# uv

[Astral](https://astral.sh/) が開発する高速なPythonパッケージおよびプロジェクト管理ツール。pipやpoetry/rye/pipenv等の代替として広く使われ始めている。Rust製で、依存関係の解決とインストールが従来ツールより大幅に速いのが特徴。

## 歴史的経緯

- 2024-08-20: v0.3.0公開。プロジェクト管理機能が一通り揃い、広く採用されるようになる
- v0.4.23: 名前付きindex指定（`tool.uv.index` / `tool.uv.sources`）を導入
- v0.4.27: [[concepts/Dependency Groups]] 機能を追加
- v0.5.3: `tool.uv.conflicts` を追加し、排他的な [[concepts/Optional Dependencies]] を扱えるように

## 主要コマンド

| コマンド | 用途 |
|---------|------|
| `uv self update` | uv自身のアップデート |
| `uv add <pkg>` | 依存追加 |
| `uv add <pkg> --optional <extra>` | optional-dependencies (extra) に追加 |
| `uv add <pkg> --group <group>` | dependency-group に追加 |
| `uv add --dev <pkg>` | dev グループに追加 |
| `uv sync` | 環境同期 |
| `uv sync --extra <name>` / `--all-extras` | 特定または全extra をインストール |
| `uv sync --group <name>` / `--all-groups` | 特定または全groupをインストール |
| `uv add --no-build-isolation <pkg>` | 隔離ビルドを無効化してインストール |

## pyproject.toml の主要セクション

uv固有の設定は `[tool.uv]`, `[[tool.uv.index]]`, `[tool.uv.sources]`, `[[tool.uv.dependency-metadata]]` などで記述する。

### 名前付きindex（v0.4.23〜）

```toml
[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true

[tool.uv.sources]
torch = { index = "pytorch-cu124" }
```

`explicit = true` は **「`[tool.uv.sources]` で明示指定されたパッケージしかこのindexを使わない」** という意味。指定しないと、そのindexにある他パッケージ（古いnumpy等）まで巻き込まれて依存関係衝突を起こす可能性がある。

### sources × marker / extra

`tool.uv.sources` の値はリストで、各要素に `marker`（[[concepts/Environment Markers]]）か `extra` を指定して条件付きで使うindexを切り替えられる。

### conflicts（v0.5.3〜）

互換性のないoptional-dependencies同士を明示宣言する:

```toml
[tool.uv]
conflicts = [
    [
      { extra = "cpu" },
      { extra = "cu124" },
    ],
]
```

### no-build-isolation-package と dependency-metadata

[[concepts/Build Isolation]] 参照。

## 設計上の特徴

- **デフォルトのindexは [[entities/PyPI]]**。`tool.uv.index` で追加・上書き可能
- **PEP 508 / PEP 517 準拠** の依存関係仕様
- **pyproject.toml ベース**。`requirements.txt` を別途持つ必要がない
- **ロックファイル `uv.lock`** で再現性を担保

## ユースケース（記事から）

- PyTorchをCUDA版/CPU版でOS別に切り替えてインストール
- [[entities/flash-attention]] のような `--no-build-isolation` 必須パッケージのインストール
- lint用・test用などdev依存を複数グループで管理

## 関連

- [[entities/PyPI]] — デフォルトのパッケージindex
- [[entities/PyTorch]] — 非標準index指定の代表例
- [[entities/flash-attention]] — build isolation無効化の代表例
- [[concepts/Environment Markers]]
- [[concepts/Optional Dependencies]]
- [[concepts/Dependency Groups]]
- [[concepts/Build Isolation]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
