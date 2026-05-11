---
title: flash-attention
type: entity
created: 2026-05-11
updated: 2026-05-11
tags: [Python, 深層学習, CUDA, Attention]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [flash-attn, FlashAttention]
---

# flash-attention

[Dao-AILab/flash-attention](https://github.com/Dao-AILab/flash-attention) が開発するメモリ効率と速度を両立した [[concepts/Self-Attention]] 実装。本Wikiでは [[entities/uv]] における「build isolationを無効化しないとインストールできないパッケージ」の代表例として扱う。

## インストールが特殊な理由

近年の多くのPythonパッケージは [PEP 517](https://peps.python.org/pep-0517/) に従い隔離された仮想環境でビルドされる（[[concepts/Build Isolation]] 参照）。一方、flash-attentionは **意図的に現在の仮想環境内でビルドすることを要求** する。理由は、ビルド時に [[entities/PyTorch]] のCUDA環境やバージョンを参照する必要があるため。

## ビルドに必要なパッケージ

`setup.py` がimport時に要求するパッケージ:

- `packaging`
- `ninja`
- `psutil`

これらをビルド前に仮想環境に入れておく必要がある。

## uvでのインストール手順

### pyproject.toml

```toml
[project]
name = "project"
requires-python = ">=3.12.0"
dependencies = ["torch>=2.5.1"]

[project.optional-dependencies]
build = ["ninja>=1.11.1.2", "packaging>=24.2", "psutil>=6.1.0"]
compile = ["flash-attn==2.6.3"]

[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true

[tool.uv.sources]
torch = { index = "pytorch-cu124" }

[tool.uv]
no-build-isolation-package = ["flash-attn"]

[[tool.uv.dependency-metadata]]
name = "flash-attn"
version = "2.6.3"
requires-dist = ["torch", "einops"]
```

### 2段階の uv sync

```bash
uv sync --extra build                       # 先にビルド用パッケージを入れる
uv sync --extra build --extra compile       # その後 flash-attn をビルド
```

## ポイント

### no-build-isolation-package

`uv add --no-build-isolation` を毎回付ける代わりに、`pyproject.toml` で対象パッケージを宣言できる。

```toml
[tool.uv]
no-build-isolation-package = ["flash-attn"]
```

### dependency-metadata

flash-attentionのようにsource distributionのみ配布のパッケージは静的メタデータがなく、依存解決のために毎回ビルドが必要になる。`[[tool.uv.dependency-metadata]]` で `requires-dist` を明示するとビルド前に依存解決が完了し、インストール時間と失敗リスクを大幅に減らせる。

### なぜ extra に分けるか

`build` と `compile` を分けるのは、**ビルド依存（ninja等）を先にインストールしてから** flash-attentionをビルドするため。同じ `uv sync` で両方指定すると、ninjaが入る前にflash-attentionのビルドが走って失敗する可能性がある。

## 関連

- [[entities/uv]]
- [[entities/PyTorch]]
- [[concepts/Build Isolation]]
- [[concepts/Optional Dependencies]]
- [[concepts/Self-Attention]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
