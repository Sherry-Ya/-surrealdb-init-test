#!/bin/bash
set -e

# ====== SurrealDB 连接配置 ======
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"

# ====== 使用合法命名空间/数据库名（不能以数字开头） ======
: "${GITHUB_SHA:=localtest1234567}"
NAMESPACE="ns_${GITHUB_SHA:0:7}"
DATABASE="db_${GITHUB_SHA:0:7}"

# ====== .surql 文件路径 ======
SURQL_FILE="./init/export.surql"

echo "🚀 正在请求 SurrealDB 版本信息..."
version_response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain')
echo "✅ SurrealDB 版本：$version_response"

echo ""
echo "📦 创建 NAMESPACE=$NAMESPACE..."
create_ns=$(curl -s -X POST "$SURREALDB_URL/sql" \
  -u "$USER:$PASS" \
  -H "Accept: application/json" \
  -H "Content-Type: text/plain" \
  -d "DEFINE NAMESPACE $NAMESPACE;")
echo "✅ 创建命名空间结果：$create_ns"

echo ""
echo "📦 创建 DATABASE=$DATABASE（在 namespace=$NAMESPACE 下）..."
create_db=$(curl -s -X POST "$SURREALDB_URL/sql" \
  -u "$USER:$PASS" \
  -H "Accept: application/json" \
  -H "Content-Type: text/plain" \
  -d "USE NAMESPACE $NAMESPACE; DEFINE DATABASE $DATABASE;")
echo "✅ 创建数据库结果：$create_db"

# ====== 使用 HTTP API 导入 .surql 文件 ======
if [ -f "$SURQL_FILE" ]; then
  echo ""
  echo "📤 拼接 USE 语句后导入数据文件 $SURQL_FILE 到 $NAMESPACE/$DATABASE ..."

  payload=$(printf "USE NS %s;\nUSE DB %s;\n\n" "$NAMESPACE" "$DATABASE")
  payload+=$(cat "$SURQL_FILE")

  import_response=$(curl --http1.1 -s -X POST "$SURREALDB_URL/sql" \
    -u "$USER:$PASS" \
    -H "Accept: application/json" \
    -H "Content-Type: text/plain" \
    --data-binary "$payload")

  echo "✅ 数据导入结果：$import_response"
else
  echo "⚠️ 找不到文件 $SURQL_FILE，跳过数据导入"
fi