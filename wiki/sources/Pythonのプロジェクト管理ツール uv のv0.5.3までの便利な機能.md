---
title: Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能
type: source
created: 2026-05-11
updated: 2026-05-11
tags: [Python, uv, パッケージ管理, PyTorch, 依存関係]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
url: https://zenn.dev/turing_motors/articles/1435807a1b16d5
author: Turing Motors（Zenn記事、Python Advent Calendar 2024 7日目）
published: 2024-12-09
---

# Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能

## 要約

[[entities/uv]] のv0.5.3までのアップデートで導入された依存関係まわりの便利な機能を整理した記事。特に [[entities/PyTorch]] のように非標準index・アクセラレータ別wheel・隔離ビルド不可のパッケージをどう扱うかを、具体的な `pyproject.toml` の書き方とともに紹介している。

uvはv0.3.0（2024-08-20）で広く使われ始めた高速なPythonパッケージ・プロジェクト管理ツール。v0.5.3までに以下のような依存関係制御機能が揃った:

1. `tool.uv.index` / `tool.uv.sources` による [[entities/PyPI]] 以外のindex指定
2. [[concepts/Environment Markers]] によるOS/アーキテクチャ別の依存切り替え
3. [[concepts/Optional Dependencies]] と `tool.uv.conflicts` による排他的extras
4. [[concepts/Dependency Groups]] による複数の開発用依存グループ
5. [[concepts/Build Isolation]] の選択的無効化（`no-build-isolation-package`）と `dependency-metadata` の明示

## キーポイント

### 1. tool.uv.index による非PyPI indexの指定

- uv v0.4.23から、pipの `--index-url` / `--extra-index-url` 相当のindex指定機能が導入
- `[[tool.uv.index]]` で名前付きindexを定義し、`[tool.uv.sources]` でパッケージごとに使うindexを指定
- 例: PyTorchのCUDA 12.4ビルドを使うには:
  ```toml
  [[tool.uv.index]]
  name = "pytorch-cu124"
  url = "https://download.pytorch.org/whl/cu124"
  explicit = true

  [tool.uv.sources]
  torch = { index = "pytorch-cu124" }
  ```

### 2. explicit = true の重要性

- `explicit = true` を設定すると、`[tool.uv.sources]` で名指しされていないパッケージは [[entities/PyPI]] からインストールされる
- PyTorchのindexにはnumpy・jinja2・networkxなども一部バージョンしかホストされておらず、他パッケージの要求と衝突する可能性があるため、`explicit = true` が推奨

### 3. Environment Markers でOS別にindexを切り替え

- `tool.uv.sources` には [PEP 508](https://peps.python.org/pep-0508/) ベースの [[concepts/Environment Markers]] が使える
- 例: Windowsはpytorch-cpu、Linuxはpytorch-cu124、を `uv sync` 一発で切り替える
- 使えるmarker: `sys_platform`, `platform_machine`, `platform_system` など。`and`/`or`/`()` で組み合わせ可能

### 4. Optional Dependencies（extras）

- `[project.optional-dependencies]` に記述、`uv add <pkg> --optional <extra名>` で追加
- `uv sync --extra <名>` でextra単位インストール、`uv sync --all-extras` で全部
- uv v0.5.3で `tool.uv.conflicts` が追加され、排他的なextrasを明示宣言できる（`numpy<2.0.0` と `numpy>=2.0.0` の同居など）
- extras × index指定の組み合わせで、`uv sync --extra cpu` / `uv sync --extra cu124` でPyTorchのアクセラレータを切り替えるパターンも可能

### 5. Dependency Groups

- uv v0.4.27で [[concepts/Dependency Groups]] が追加。複数の開発用依存グループを `[dependency-groups]` に分けて持てる
- `uv add ruff --group lint`、`uv add pytest --group test` のように追加
- `uv sync --group lint` で個別、`uv sync --all-groups` で全部
- `[tool.uv] default-groups = ["dev", "lint"]` で `uv sync` 時にデフォルトで含めるグループを指定
- optional-dependenciesと違い、パッケージ公開時に含まれない（lint/test用に最適）

### 6. Build Isolation と dependency-metadata

- [PEP 517](https://peps.python.org/pep-0517/) により多くのパッケージは隔離環境でビルドされるが、[[entities/flash-attention]] のように現在の仮想環境でビルドが必要なパッケージもある
- pip相当の `--no-build-isolation` は `uv add --no-build-isolation` で可能だが、特定パッケージのみ無効化したいときは:
  ```toml
  [tool.uv]
  no-build-isolation-package = ["flash-attn"]
  ```
- source distributionのみ配布されているパッケージはメタデータが静的に取得できないので、ビルドが必要になり時間がかかる。これを回避するため `tool.uv.dependency-metadata` でメタデータを明示できる:
  ```toml
  [[tool.uv.dependency-metadata]]
  name = "flash-attn"
  version = "2.6.3"
  requires-dist = ["torch", "einops"]
  ```
- flash-attnのインストールは `uv sync --extra build` でビルド依存を先に入れ、その後 `uv sync --extra build --extra compile` の2段階で行う

## 引用すべき具体例

### PyTorchをOS別に切り替える設定

```toml
[project]
dependencies = ["torch>=2.5.1", "torchvision>=0.20.1"]

[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", marker = "platform_system == 'Windows'" },
  { index = "pytorch-cu124", marker = "platform_system == 'Linux'" },
]

[[tool.uv.index]]
name = "pytorch-cpu"
url = "https://download.pytorch.org/whl/cpu"
explicit = true

[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true
```

### x86_64 LinuxはCUDA、macOSとaarch64 LinuxはCPU

```toml
[tool.uv.sources]
torch = [
    { index = "torch-cuda", marker = "sys_platform == 'linux' and platform_machine == 'x86_64'"},
    { index = "torch-cpu", marker = "sys_platform == 'darwin' or (sys_platform == 'linux' and platform_machine == 'aarch64')"},
]
```

## 関連

- [[entities/uv]]
- [[entities/PyTorch]]
- [[entities/flash-attention]]
- [[entities/PyPI]]
- [[concepts/Environment Markers]]
- [[concepts/Optional Dependencies]]
- [[concepts/Dependency Groups]]
- [[concepts/Build Isolation]]
