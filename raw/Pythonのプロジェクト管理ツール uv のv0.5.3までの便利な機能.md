---
title: "Pythonのプロジェクト管理ツール uv のv0.5.3までの便利な機能"
source: "https://zenn.dev/turing_motors/articles/1435807a1b16d5"
author:
published: 2024-12-09
created: 2026-05-11
description:
tags:
  - "clippings"
---
63

7

[Python Advent Calendar 2024](https://qiita.com/advent-calendar/2024/python) の7日目です。

この記事ではuvについて、v0.5.3までのアップデートで個人的に便利だった機能を依存関係に焦点を当ててまとめました。

uvは高速なPythonパッケージとプロジェクト管理ツールです。2024年8月20日に [uv](https://astral.sh/blog/uv-unified-python-packaging) のバージョンがv0.3.0にアップデートされて以来、広く使われるようになりました。

以前に以下の記事をまとめています。これからuvを使いたい方などに参考になれば嬉しいです！また、公式のドキュメントがしっかりと整備されているので [https://docs.astral.sh/uv/getting-started/から使ってみることをオススメします。](https://docs.astral.sh/uv/getting-started/%E3%81%8B%E3%82%89%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B%E3%81%93%E3%81%A8%E3%82%92%E3%82%AA%E3%82%B9%E3%82%B9%E3%83%A1%E3%81%97%E3%81%BE%E3%81%99%E3%80%82)

<iframe src="https://embed.zenn.studio/card#zenn-embedded__8f9cfc5008af6" frameborder="0" height="122"></iframe>

現在のuvのバージョンがv0.5.3より前のバージョンであれば、以下のコマンドでuvをアップデートしましょう。

```
uv self update
```

## 1\. PyTorchを例にindex-urlを指定するパッケージのインストール

[Using uv with PyTorch - uv](https://docs.astral.sh/uv/guides/integration/pytorch/) として、uvでのPyTorchのインストール方法が公式ドキュメントがまとめられています。

この中で、そもそもPyTorchのインストールが特殊な理由として以下の2つが挙げています。

1. 多くのPythonパッケージは、 [PyPI (Python Package Index)](https://pypi.org/) でホストされています。一方で、PyTorchの場合は専用のindexでホストされています([https://download.pytorch.org/whl/cpu](https://download.pytorch.org/whl/cpu))。PyTorchのインストールの際には、このindexを指定するようにする必要があります。
2. PyTorchはアクセラレータごとに異なるwheelがビルドされて、そのwheelはローカルバージョンで指定されています(e.g., 2.5.1+cpu, 2.5.1+cu121)。各wheelは異なるindexで公開されて、異なるアクセラレータ環境ごとにindexを指定する必要があります(e.g., [https://download.pytorch.org/whl/cu121](https://download.pytorch.org/whl/cu121))。

そのため通常の `uv add torch` では、 [PyPI](https://pypi.org/project/torch/) でホストされているPyTorchのパッケージがインストールされます。ここで、

> In this case, PyTorch would be installed from PyPI, which hosts CPU-only wheels for Windows and macOS, and GPU-accelerated wheels on Linux (targeting CUDA 12.4)

とあることから `torch=2.5.1` では、PyPI上ではWindowsやmacOSではCPU、Linux環境ではCUDA 12.4でビルドされたwheelが公開されているらしいです。それ以外の組み合わせで行う場合を紹介されています。

## 1.1 tool.uv.indexを用いたPyPI以外のindexの指定

uvのv0.4.23から新しいindex指定が導入されて、pipスタイルの `--index-url` や `--extra-index-url` の設定オプションに相当する機能です。

最初に `tool.uv.index` を用いて名前付きのindexを定義します。今回はCUDA 12.4のPyTorchのindexを指定します。このURLはPyTorchの場合は [Previous PyTorch Versions](https://pytorch.org/get-started/previous-versions/) を参照するか、uvのドキュメントを参照してください ([Using a PyTorch index - uv](https://docs.astral.sh/uv/guides/integration/pytorch/#using-a-pytorch-index))。なお、以下のnameは任意の文字列です。

```
[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true
```

`tool.uv.sources` で、パッケージごとにどのindexからインストールするかを指定します。今回は上記で指定した名前付きindexを指定します。

```
[tool.uv.sources]
torch = { index = "pytorch-cu124" }
torchvision = { index = "pytorch-cu124" }
```

これによりtorchとtorchvisionは、 [https://download.pytorch.org/whl/cu124](https://download.pytorch.org/whl/cu124) でホストされているパッケージからインストールされます。後は `uv add torch torchvision` を実行することでパッケージをdependenciesに追加して、インストールすることが可能です。この操作はpipでの以下の操作と同じです。

```
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124
```

## 1.2 explicit = trueで\[tool.uv.sources\]に指定されていないパッケージはデフォルトのindex(PyPI)を使用する

`tool.uv.index` には `explicit` という設定があります。これを `true` に設定することにより、 `[tool.uv.sources]` で指定されていないパッケージはデフォルトのPyPIでホストされているパッケージをインストールします。PyTorchの場合は `explicit = true` が推奨されています。

そもそもなぜこの設定が必要なのかは、指定したindex urlにインストールしたいパッケージ以外もホストされている場合があり、余計な依存関係の競合が発生するおそれがあるためです。

`explicit = true` でなければ、 `tool.uv.sources` に指定されていないパッケージもこのindex URLからインストールします。PyTorchのindex URLにはnumpyや、jinja2やnetworkxなどもホストされています。ただ、それらのパッケージは一部バージョンしかホストされていません。例えばnumpyであれば2.0.0以上のバージョンはホストされていないため、他のパッケージの要求と一致しない場合があります。そのためPyTorch関連パッケージ以外はPyPIを参照するよう、 `explicit = true` に設定することが望ましいです。

## 1.3 Environment markersでOSごとにindexの指定を変更する

`tool.uv.sources` には `marker` としてenvironment markersを使用することができます。この機能は、特にmacOSでCPU版のtorchを指定する際に便利です。またPyTorch以外のパッケージにももちろん使えるため、クロスプラットフォームでの開発時に便利な機能です。

Environment markersについては後述するとして、先に [Configuring accelerators with environment markers - uv](https://docs.astral.sh/uv/guides/integration/pytorch/#configuring-accelerators-with-environment-markers) のpyproject.tomlを見てみましょう。

```
[project]
name = "project"
version = "0.1.0"
requires-python = ">=3.12.0"
dependencies = [
  "torch>=2.5.1",
  "torchvision>=0.20.1",
]

[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", marker = "platform_system == 'Windows'" },
  { index = "pytorch-cu124", marker = "platform_system == 'Linux'" },
]
torchvision = [
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

これはOSがWindowsであればpytorch-cpuで指定されているindex URLを使用し、Linuxであればpytorch-cu124で指定されているindex URLを使用するようになります。 `uv sync` のコマンドだけで柔軟にtorchのindexを変更してくれます。

では、enviromental makerについてです。そもそもuvは [PEP 508](https://peps.python.org/pep-0508/) に基づいた [Dependency specifiersの記述が可能](https://docs.astral.sh/uv/concepts/projects/dependencies/#dependency-specifiers-pep-508) で、その記述の1つにenviromental makerがあります。これにより、OSやCPUアーキテクチャなどシステムの環境に合わせて依存関係を記述することが可能になります。

markerとして、 [sys\_platform](https://docs.python.org/3/library/sys.html#sys.platform) (e.g., Linuxなら `'linux'`, macOSなら `'darwin'`)や [platform\_machine](https://docs.python.org/3/library/platform.html#platform.machine) (e.g., `'x86_64'`, `'aarch64'`, `'amd64'`)、前述した [platform\_system](https://docs.python.org/3/library/platform.html#platform.system) (e.g., `'Linux'`, `'Darwin'`, `'Windows'`)などが使用できます。他のmarkerなど詳細については、 [Python Packaging User Guideの環境マーカ](https://packaging.python.org/ja/latest/specifications/dependency-specifiers/#environment-markers) を参照してください。

このmarkerは `and` や `or` 、 `()` で組み合わせた条件式で記述することができます。これにより、OSはLinuxかつCPUアーキテクチャはx86\_64のときはこのindexでインストールする、といったことが可能になります。

一例として以下の記事では、macOSまたはaarch64のLinuxではCPU版の、x86\_64のLinuxではCUDA版のPyTorchを切り替えるを以下のように記述されています。

```
[tool.uv.sources]
torch = [
    { index = "torch-cuda", marker = "sys_platform == 'linux' and platform_machine == 'x86_64'"},
    { index = "torch-cpu", marker = "sys_platform == 'darwin' or (sys_platform == 'linux' and platform_machine == 'aarch64')"},
]
```

<iframe src="https://embed.zenn.studio/card#zenn-embedded__ff26f2550d7ca" frameborder="0"></iframe>

## 2\. optional-dependenciesを使う

[Optional dependencies - uv](https://docs.astral.sh/uv/concepts/projects/dependencies/#optional-dependencies)

特定のパッケージは `extras_require` としてデフォルトの依存関係を減らし、明示的にインストールするパッケージを要求します。例えばpandasであれば、Excel parserが必要なら `pip install pandas[excel]` 、Excel parserとplot機能が必要であれば `pip install pandas[plot, excel]` のように明示的に追加します([pyproject.toml](https://github.com/pandas-dev/pandas/blob/8a286fa16f3160e939b192cbe8e218992a84e6fc/pyproject.toml#L60-L122))。

uvではpyproject.toml内で `[project.optional-dependencies]` に依存関係を記述します。

コマンドは `uv add` 時に `--optional <extra名>` を指定することです。

```
uv add "numpy<2.0.0" --optional numpy-1
```

すると `[project.optional-dependencies]` に `numpy-1` として追加されます。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = []

[project.optional-dependencies]
numpy-1 = [
    "numpy<2.0.0",
]
```

このextrasに記述された依存パッケージをインストールするには `uv sync --all-extras` で実行可能で、特定のextrasだけインストールするには `uv sync --extra numpy-1` のように指定することが可能です。

## 2.1 競合するoptional-dependenciesはconflictsを宣言する

[Conflicting dependencies - uv](https://docs.astral.sh/uv/concepts/projects/config/#conflicting-dependencies)

uvではoptional-dependenciesは相互に互換性があることが要求されます。そのため以下のように互換性のないパッケージのバージョンを指定するとエラーが発生します。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = []

[project.optional-dependencies]
numpy-1 = [
    "numpy<2.0.0",
]
numpy-2 = [
    "numpy>=2.0.0",
]
```

```
$ uv sync
  × No solution found when resolving dependencies:
  ╰─▶ Because project[numpy-2] depends on numpy>=2.0.0 and project[numpy-1] depends on numpy<2.0.0, we can conclude that project[numpy-1] and project[numpy-2]
      are incompatible.
      And because your project requires project[numpy-1] and project[numpy-2], we can conclude that your projects's requirements are unsatisfiable.
```

ここでuvのv0.5.3から `tool.uv.conflicts` 追加されました。 `conflicts` を用いることで競合しているextrasを明示的に記載でき、このエラーを回避することができます。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = []

[project.optional-dependencies]
numpy-1 = [
    "numpy<2.0.0",
]
numpy-2 = [
    "numpy>=2.0.0",
]

[tool.uv]
conflicts = [
    [
      { extra = "numpy-1" },
      { extra = "numpy-2" },
    ],
]
```

もちろんこの2つの依存関係を同時にインストールすることはできません。

```
$ uv sync --all-extras
  Resolved 3 packages in 4ms
  error: extra \`numpy-1\`, extra \`numpy-2\` are incompatible with the declared conflicts: {\`project[numpy-1]\`, \`project[numpy-2]\`}
```

## 2.2 uv sync --extraでインストールするPyTorchを切り替える

[Configuring accelerators with optional dependencies - uv](https://docs.astral.sh/uv/guides/integration/pytorch/#configuring-accelerators-with-optional-dependencies)

`tool.uv.index` やoptional-dependenciesを用いることで、 `uv sync --extra cpu` や `uv sync --extra cu124` で切り替えられます。

以下のようにpyproject.tomlを設定することで可能です。 `tool.uv.sources` において、 `extra` としてoptional-dependenciesを指定することが可能です。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = []

[project.optional-dependencies]
cpu = [
  "torch>=2.5.1",
]
cu124 = [
  "torch>=2.5.1",
]

[tool.uv]
conflicts = [
  [
    { extra = "cpu" },
    { extra = "cu124" },
  ],
]

[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", extra = "cpu" },
  { index = "pytorch-cu124", extra = "cu124" },
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

## 3\. 複数のdev-dependenciesを使い分ける

uvのv0.4.27から [Dependency groups](https://docs.astral.sh/uv/concepts/projects/dependencies/#dependency-groups) という機能が追加されました。これまでは単一だったdevelopment dependencies(開発用の依存関係; dev-dependencies)が、複数グループで設定できる機能です。

そもそもoptional-dependenciesではなく、dev-dependenciesはどのようなときに便利でしょうか。理由の1つとして、パッケージをビルドして公開するときにlinterやtest用のパッケージなどの余計な依存関係を含めずに済むことが挙げられます。

## 3.1 uv add --groupで\[dependency-groups\]に追加する

コマンドは `uv add` 時に `--gourp <グループ名>` を指定することです。

```
uv add ruff --group lint
uv add pytest --group test
```

すると `dependency-groups` にグループごとにパッケージが追加されます。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = []

[dependency-groups]
lint = [
    "ruff>=0.8.2",
]
test = [
    "pytest>=8.3.4",
]
```

また、以前までのバージョンと同様に `uv add --dev` も可能です。この場合は `dev` というグループに追加されます。

このグループに記述された依存パッケージをインストールするには `uv sync --all-groups` で実行可能であり、特定のグループだけインストールするには `uv sync --group lint` のように指定することが可能です。

また、 `default-groups` として `uv sync` に含めることができます。以下の記述で `uv sync` をすると `dev` と `lint` のグループ内の依存パッケージも加えてインストールします。

```
[tool.uv]
default-groups = ["dev", "lint"]
```

## 4.--no-build-isolationが必要なパッケージのインストール

[Build isolation - uv](https://docs.astral.sh/uv/concepts/projects/config/#build-isolation)

近年の多くのパッケージでは [PEP 517](https://peps.python.org/pep-0517/) に従い、隔離された仮想環境でビルドします。一方で、 [flash-attention](https://github.com/Dao-AILab/flash-attention) など一部パッケージでは意図的に現在の仮想環境内でビルドすることを要求する場合があります。

pipであればビルドに必要なパッケージ(e.g., setuptools, packaging)を先に仮想環境に追加した後に、 `pip install` に `--no-build-isolation` のオプションを追加することで実行できます。

uvの場合はどうすればいいか、実際に [flash-attention](https://github.com/Dao-AILab/flash-attention) をインストールしてみましょう。

## 4.1 flash-attentionインストール

まず最初にPyTorchを `tool.uv.index` を指定して追加します。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = [
    "torch>=2.5.1"
]

[tool.uv.sources]
torch = [
  { index = "pytorch-cu124" }
]

[[tool.uv.index]]
name = "pytorch-cu124"
url = "https://download.pytorch.org/whl/cu124"
explicit = true
```

次にビルドに必要なパッケージをインストールします。 [flash-attnのInstallation and features](https://github.com/Dao-AILab/flash-attention?tab=readme-ov-file#installation-and-features) には、 [packaging](https://pypi.org/project/packaging/), [ninja](https://pypi.org/project/ninja/), [psutil](https://pypi.org/project/psutil/) が必要なのでoptional-dependenciesに追加します。

```
uv add packaging ninja psutil --optional build
```

flash-attnを追加する前に便利な設定として `tool.uv.no-build-isolation-package` と `tool.uv.dependency-metadata` を追記します。なお、この設定は行わなくてもインストールできます。

[Build isolation - uv](https://docs.astral.sh/uv/concepts/projects/config/#build-isolation)

uvの場合は `uv add` や `uv sync` に `--no-build-isolation` のオプションを追加することができて、現在の仮想環境内でビルドするようにできます。ただ毎回このオプションを追加するのが面倒であり、特定のパッケージを選択的に付けたいため `tool.uv.no-build-isolation-package` を使います。以下のようにpyproject.tomlに記載します。

```
[tool.uv]
no-build-isolation-package = ["flash-attn"]
```

[Dependency metadata - uv](https://docs.astral.sh/uv/concepts/resolution/#dependency-metadata)

依存関係を解決する際に各パッケージのMETADATA(メタデータ)を用います。このメタデータはindexに静的ファイルとして用意されていることが多いですが、source distributionsのみ配布しているパッケージの場合はメタデータが存在しないことがあります。その場合はパッケージをビルドする必要があり、依存関係解決に時間が掛かる、正常にビルドできない、など問題が発生する可能性があります。

uvでは `tool.uv.dependency-metadata` としてメタデータを明示的に記述することができます。以下のようにpyproject.tomlに記載します。

```
[[tool.uv.dependency-metadata]]
name = "flash-attn"
version = "2.6.3"
requires-dist = ["torch", "einops"]
```

`name` はパッケージ名、 `version` はそのパッケージのバージョン、 `requires-dist` はパッケージの使用時に必要な依存パッケージを指定します。なお [setup.py](https://github.com/Dao-AILab/flash-attention/blob/main/setup.py) であれば `install_requires` に相当し、uvなどのpyproject.tomlであれば `dependencies` に相当するパッケージです。

`dependency-metadata` の宣言はメタデータが存在しない場合を対象としていますが、 `no-build-isolation` が必要なパッケージに役にたつケースがあります。flash-attnはこの例の一つです。

いよいよflash-attnのインストールです。以下のコマンドを実行しましょう。バージョンは2.6.3に固定していますが、任意のバージョンで選択してください。

```
uv add flash-attn==2.6.3 --optional compile
```

インストールまで時間が掛かると思いますが、無事インストールできたら完了です。pyproject.tomlは以下のようになります。

```
[project]
name = "project"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.12.0"
dependencies = [
    "torch>=2.5.1",
]

[project.optional-dependencies]
build = [
    "ninja>=1.11.1.2",
    "packaging>=24.2",
    "psutil>=6.1.0",
]
compile = [
    "flash-attn==2.6.3",
]

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

また、先にこのpyproject.tomlがある場合は2段階の `uv sync` を実行します。

```
uv sync --extra build
uv sync --extra build --extra compile
```

以上で無事にflash-attnがインストールできるようになりました。

## 5\. おわりに

この記事ではuvのv0.5.3までの便利な機能を、特にdependenciesに関係するところを紹介しました。uvはそれ以外にも自作パッケージビルドや、workspacesなど便利な機能があるので別の記事で紹介したいと思います。不明点などあればお気軽にコメントしていただけると嬉しいです！

63

7