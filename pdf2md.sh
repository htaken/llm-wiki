#!/bin/zsh
# PDF を Markdown に変換し、画像を assets/{name}/ に保存するスクリプト (MinerU)
# 使い方: ./pdf2md.sh <PDFファイル>

set -e

if [ $# -eq 0 ]; then
    echo "使い方: $0 <PDFファイル>"
    exit 1
fi

PDF="$1"

if [ ! -f "$PDF" ]; then
    echo "エラー: ファイルが見つかりません: $PDF"
    exit 1
fi

BASENAME=$(basename "$PDF" .pdf)
OUTPUT_DIR=$(dirname "$PDF")
TMPDIR=$(mktemp -d)
ASSETS_DIR="${OUTPUT_DIR}/assets/${BASENAME}"
MD_FILE="${OUTPUT_DIR}/${BASENAME}.md"

echo "変換中: $PDF"
uv run --python 3.12 --with "mineru[all]" -- mineru -p "$PDF" -o "$TMPDIR" -b pipeline -l en

# MinerU の出力: {TMPDIR}/{BASENAME}/auto/{BASENAME}.md + images/
MINERU_OUT="${TMPDIR}/${BASENAME}/auto"

# MD ファイルを移動
cp "${MINERU_OUT}/${BASENAME}.md" "$MD_FILE"
echo "MDファイルを配置しました: $MD_FILE"

# 画像を assets/{BASENAME}/ に移動
if [ -d "${MINERU_OUT}/images" ] && [ "$(ls -A "${MINERU_OUT}/images")" ]; then
    mkdir -p "$ASSETS_DIR"
    cp "${MINERU_OUT}/images/"* "$ASSETS_DIR"/
    echo "画像を assets/${BASENAME}/ に移動しました"

    # MD 内の画像パスを書き換え
    sed -i '' "s|images/|assets/${BASENAME}/|g" "$MD_FILE"
    echo "MDのパスを更新しました"
fi

# 一時ディレクトリを削除
rm -rf "$TMPDIR"

echo "完了: $MD_FILE"
