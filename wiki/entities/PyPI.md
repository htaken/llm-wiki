---
title: PyPI
type: entity
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, インフラ]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [Python Package Index, pypi.org]
---

# PyPI (Python Package Index)

Pythonの公式パッケージリポジトリ。多くのPythonパッケージは [pypi.org](https://pypi.org/) でホストされ、pipや [[entities/uv]] のデフォルトindexとして使われる。

## uvにおける位置づけ

- [[entities/uv]] のデフォルトindex
- `[[tool.uv.index]]` で `explicit = true` を指定したindexを追加した場合、それ以外のパッケージはPyPIから取得される
- 追加indexで競合がある場合の **「フォールバック」** として機能

## 非PyPIホスティングの例

- [[entities/PyTorch]] のCUDA別ビルド（`https://download.pytorch.org/whl/cu124` など）
- 社内プライベートindex
- 特定企業がホストするミラー

これらを使うときは `[[tool.uv.index]]` でnameを付けて定義し、`[tool.uv.sources]` で個別パッケージにindexを指定する。

## 関連

- [[entities/uv]]
- [[entities/PyTorch]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
