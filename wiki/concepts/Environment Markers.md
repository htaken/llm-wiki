---
title: Environment Markers
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, PEP 508, 依存関係]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [環境マーカ, environment markers, PEP 508 markers]
---

# Environment Markers

[PEP 508](https://peps.python.org/pep-0508/) で定義された **依存関係を環境条件で切り替えるためのマーカ式**。OS・アーキテクチャ・Pythonバージョン等に応じて依存パッケージを条件付きで宣言できる。

## 使えるmarker（主要）

| marker | 値の例 | 用途 |
|--------|--------|------|
| `sys_platform` | `'linux'`, `'darwin'`, `'win32'` | `sys.platform` の値 |
| `platform_system` | `'Linux'`, `'Darwin'`, `'Windows'` | `platform.system()` の値 |
| `platform_machine` | `'x86_64'`, `'aarch64'`, `'amd64'` | `platform.machine()` の値 |
| `python_version` | `'3.12'` | Pythonのメジャー.マイナー |
| `implementation_name` | `'cpython'`, `'pypy'` | 実装系 |

完全な一覧は [Python Packaging User Guide / 環境マーカ](https://packaging.python.org/ja/latest/specifications/dependency-specifiers/#environment-markers) を参照。

## 演算子

`and`, `or`, `()` で論理結合できる。比較演算子は `==`, `!=`, `<`, `>`, `<=`, `>=`, `in`, `not in`。

## sys_platform と platform_system の違い

似ているが微妙に違う:

| OS | `sys_platform` | `platform_system` |
|----|----------------|-------------------|
| Linux | `'linux'` | `'Linux'` |
| macOS | `'darwin'` | `'Darwin'` |
| Windows | `'win32'` | `'Windows'` |

大文字小文字・略記が違うので、書き換えるときは注意。

## uvでの使い方

[[entities/uv]] では `tool.uv.sources` 内で `marker` キーとして使える。例: [[entities/PyTorch]] をOSとアーキテクチャで切り替える。

```toml
[tool.uv.sources]
torch = [
    { index = "torch-cuda",
      marker = "sys_platform == 'linux' and platform_machine == 'x86_64'" },
    { index = "torch-cpu",
      marker = "sys_platform == 'darwin' or (sys_platform == 'linux' and platform_machine == 'aarch64')" },
]
```

これにより `uv sync` 一発で、実行環境に応じたindexからtorchがインストールされる。CIや複数の開発マシン（macOSとLinuxサーバ等）が混在するプロジェクトで特に有用。

## 通常の `dependencies` でも使える

`tool.uv.sources` 以外の通常のdependencies指定でも使える（PEP 508準拠）:

```toml
dependencies = [
    "pywin32; sys_platform == 'win32'",
    "uvloop; sys_platform != 'win32'",
]
```

## 関連

- [[entities/uv]]
- [[entities/PyTorch]]
- [[concepts/Optional Dependencies]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
