---
title: PyTorch
type: entity
created: 2026-05-11
updated: 2026-05-11
tags: [Python, 深層学習, ライブラリ]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
---

# PyTorch

Pythonの代表的な深層学習ライブラリ。本Wikiでは [[entities/uv]] における非標準パッケージインストールの題材として扱う（モデルアーキテクチャや学習APIには触れない）。

## パッケージ配布の特殊性

PyTorchはPythonパッケージとしては配布形態が特殊で、これが [[entities/uv]] や pip での扱いを難しくしている。

### 1. 専用indexでホスト

[[entities/PyPI]] にも `torch` パッケージはあるが、最新のアクセラレータ別ビルドは公式の独自index `https://download.pytorch.org/whl/...` で配布される:

| index URL | 内容 |
|-----------|------|
| `https://download.pytorch.org/whl/cpu` | CPUのみ |
| `https://download.pytorch.org/whl/cu118` | CUDA 11.8 |
| `https://download.pytorch.org/whl/cu121` | CUDA 12.1 |
| `https://download.pytorch.org/whl/cu124` | CUDA 12.4 |

### 2. アクセラレータごとに異なるwheel

PyTorchはアクセラレータごとに異なるwheelをビルドし、ローカルバージョン（e.g., `2.5.1+cpu`, `2.5.1+cu121`）で区別する。各wheelは異なるindexで公開され、利用環境に応じてindexを切り替える必要がある。

### 3. PyPI上の `torch` のOS別ビルド

`torch=2.5.1` のPyPI上のwheelは:
- **Windows / macOS**: CPU版
- **Linux**: GPU-accelerated（CUDA 12.4ターゲット）

つまり「LinuxでCPU版が欲しい」「macOSで何らかのGPU版が欲しい」場合は、PyPI以外を指定する必要がある。

## uvでのインストールパターン

### 単一index固定（CUDA 12.4）

```toml
[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true

[tool.uv.sources]
torch = { index = "pytorch-cu124" }
torchvision = { index = "pytorch-cu124" }
```

### OS別自動切り替え（[[concepts/Environment Markers]]）

```toml
[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", marker = "platform_system == 'Windows'" },
  { index = "pytorch-cu124", marker = "platform_system == 'Linux'" },
]
```

### extra で手動切り替え（[[concepts/Optional Dependencies]]）

```toml
[project.optional-dependencies]
cpu = ["torch>=2.5.1"]
cu124 = ["torch>=2.5.1"]

[tool.uv]
conflicts = [[{ extra = "cpu" }, { extra = "cu124" }]]

[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", extra = "cpu" },
  { index = "pytorch-cu124", extra = "cu124" },
]
```

`uv sync --extra cpu` / `uv sync --extra cu124` でインストール内容を切り替えられる。

## なぜ `explicit = true` が重要か

PyTorchのindex URLには `numpy`, `jinja2`, `networkx` などPyTorchの依存パッケージも一部ホストされているが、**バージョン範囲が限定**（例: numpyは2.0.0未満のみ）。`explicit = false` だとこれらがPyTorch index経由でインストールされてしまい、他パッケージの依存と衝突する可能性がある。`explicit = true` で「`[tool.uv.sources]` に明示したパッケージ（torch/torchvision）のみこのindexを使う」と限定するのが推奨パターン。

## 関連

- [[entities/uv]]
- [[entities/PyPI]]
- [[entities/flash-attention]] — PyTorchの上に乗る代表例（build isolation 無効化が必要）
- [[concepts/Environment Markers]]
- [[concepts/Optional Dependencies]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
