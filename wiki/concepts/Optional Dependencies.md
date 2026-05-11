---
title: Optional Dependencies
type: concept
created: 2026-05-11
updated: 2026-05-11
tags: [Python, パッケージ管理, 依存関係, extras]
sources: ["raw/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能.md"]
aliases: [optional-dependencies, extras, extras_require]
---

# Optional Dependencies (extras)

`pyproject.toml` の `[project.optional-dependencies]` に記述する、**インストール時に明示的に要求しないと入らない依存パッケージ群**。setuptoolsの `extras_require` 相当。

## 動機

ユーザーが「全機能を使うわけではない」ライブラリで、デフォルトの依存を最小化したい場合に使う。例: pandasのExcelパーサやプロット機能。

```bash
pip install pandas              # 必須依存だけ
pip install pandas[excel]       # +openpyxl
pip install pandas[plot, excel] # +matplotlib +openpyxl
```

## pyproject.toml での書き方

```toml
[project]
name = "project"
dependencies = []

[project.optional-dependencies]
numpy-1 = ["numpy<2.0.0"]
numpy-2 = ["numpy>=2.0.0"]
```

## uvでの操作

[[entities/uv]] では:

```bash
uv add "numpy<2.0.0" --optional numpy-1   # 追加
uv sync --extra numpy-1                   # 個別インストール
uv sync --all-extras                      # 全extraインストール
```

## 通常はextras間の互換性が要求される

uvでは **同一プロジェクト内の複数extrasの依存が衝突するとエラー**:

```
× No solution found when resolving dependencies:
  ╰─▶ Because project[numpy-2] depends on numpy>=2.0.0
      and project[numpy-1] depends on numpy<2.0.0,
      we can conclude that project[numpy-1] and project[numpy-2] are incompatible.
```

これは `uv sync --extra numpy-1` のように片方しか使わなくても、依存解決自体が失敗する。

## conflicts 宣言（uv v0.5.3〜）

`tool.uv.conflicts` で **「これらのextrasは互いに排他である」** と明示宣言すると、依存解決時に互いを考慮しなくなる:

```toml
[tool.uv]
conflicts = [
    [
      { extra = "numpy-1" },
      { extra = "numpy-2" },
    ],
]
```

これで `uv sync --extra numpy-1` または `uv sync --extra numpy-2` が成立する（両方同時は当然不可）。

## 典型ユースケース

- [[entities/PyTorch]] のアクセラレータ別切り替え（`cpu` / `cu124` extras）
- [[entities/flash-attention]] のような **ビルド時にだけ必要な依存** を `build` extraに分離
- 大規模ライブラリの機能別オプション（`pandas[excel]` 等）

## [[concepts/Dependency Groups]] との違い

- **Optional dependencies**: ライブラリとして公開した時、エンドユーザーが選択できる依存。配布物に含まれる
- **Dependency groups**: 開発時のみ使う依存（lint/test等）。配布物には含まれない

詳細は [[concepts/Dependency Groups]] を参照。

## 関連

- [[entities/uv]]
- [[entities/PyTorch]]
- [[entities/flash-attention]]
- [[concepts/Dependency Groups]]
- [[concepts/Build Isolation]]
- [[sources/Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能]]
