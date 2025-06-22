#!/bin/bash

# DB設定
DB_NAME="test_db"
DB_USER="test_user"
CONTAINER_NAME="psql"

# 出力先ディレクトリ作成
OUTPUT_DIR="./db_dumps"
mkdir -p "$OUTPUT_DIR"

# ファイル名作成
LABEL=$1
TIMESTAMP=$(date +"%Y%m%d%H%M")
if [ -n "$LABEL" ]; then
    FILENAME="dump_${LABEL}_${TIMESTAMP}.sql"
else
    FILENAME="dump_${TIMESTAMP}.sql"
fi

# dump出力
docker exec "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" > "$OUTPUT_DIR/$FILENAME"
RESULT=$?

# 結果表示
if [ $RESULT -eq 0 ]; then
    echo "Dumped: $OUTPUT_DIR/$FILENAME"
else
    echo "Dump failed: $OUTPUT_DIR/$FILENAME"
fi
