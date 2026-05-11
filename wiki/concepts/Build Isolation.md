---
title: Build Isolation
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, PEP 517, ビルド]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [build isolation, ビルド隔離, PEP 517]
---

# Build Isolation

[PEP 517](https://peps.python.org/pep-0517/) で定義された、**Pythonパッケージをsource distributionからビルドする際に隔離された仮想環境で行う仕組み**。

## 仕組み

パッケージをsource distribution（`.tar.gz`）からインストールする際:

1. ビルド用の **一時的な仮想環境** を作る
2. その環境に `pyproject.toml` の `[build-system].requires` で指定されたビルド依存をインストール
3. その環境内で `setup.py` や PEP 517 ビルドバックエンドを実行してwheelを生成
4. 生成されたwheelを **本番の仮想環境** にインストール

これによりビルド依存と実行時依存が分離され、ビルドツールのバージョン衝突を避けられる。

## 隔離が問題になるケース

一部パッケージは **意図的に現在の仮想環境内でビルドすることを要求** する。代表例:

- [[entities/flash-attention]]: ビルド時に [[entities/PyTorch]] のCUDA環境やバージョンを参照する必要がある
- その他、コンパイル時に既存のCUDA toolkit や特定バージョンのライブラリを参照するパッケージ

これらは隔離環境にPyTorchが入っていないとビルドできない。

## pipでの無効化

```bash
pip install flash-attn --no-build-isolation
```

ただし、**事前に必要なビルド依存（setuptools, packaging, ninja等）を仮想環境に入れておく必要がある**（隔離環境がないので自動では入らない）。

## uvでの無効化

### コマンドラインオプション

```bash
uv add flash-attn --no-build-isolation
```

### pyproject.toml で特定パッケージのみ無効化

```toml
[tool.uv]
no-build-isolation-package = ["flash-attn"]
```

毎回 `--no-build-isolation` を付けるのは面倒で、しかも **全パッケージで無効化したいわけではない**（他のパッケージは隔離ビルドのままが望ましい）ため、こちらが推奨。

## 関連: dependency-metadata

source distributionのみ配布のパッケージは **静的メタデータが取得できない**（PyPIにwheelのMETADATAが置かれていない）ため、依存解決のために毎回ビルドが必要になる。これは遅く、しばしば失敗する。

[[entities/uv]] では `[[tool.uv.dependency-metadata]]` でメタデータを明示できる:

```toml
[[tool.uv.dependency-metadata]]
name = "flash-attn"
version = "2.6.3"
requires-dist = ["torch", "einops"]
```

- `name`: パッケージ名
- `version`: 対象バージョン
- `requires-dist`: 依存パッケージリスト（`setup.py` の `install_requires`、または他の `pyproject.toml` の `dependencies` 相当）

これでuvはビルド前に依存関係を解決でき、インストール所要時間と失敗確率が大きく下がる。

## 実用上の組み合わせ（flash-attentionの例）

[[entities/flash-attention]] のインストールは:

1. PyTorchを先に入れる（CUDA版indexから）
2. ビルド依存（packaging, ninja, psutil）を `build` extraで入れる
3. `no-build-isolation-package` と `dependency-metadata` を pyproject.toml に書く
4. `uv sync --extra build` → `uv sync --extra build --extra compile` の2段階で同期

## 関連

- [[entities/uv]]
- [[entities/flash-attention]]
- [[entities/PyTorch]]
- [[concepts/Optional Dependencies]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
