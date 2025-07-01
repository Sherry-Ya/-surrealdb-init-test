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

# ====== 安装 surreal CLI（自动放到 /usr/local/bin） ======
if ! command -v surreal &> /dev/null; then
  echo ""
  echo "🔧 未检测到 surreal CLI，正在安装..."
  curl -sSf https://install.surrealdb.com | sh -s -- --path /usr/local/bin
  echo "✅ Surreal CLI 安装完成"
fi

# ====== 导入 .surql 文件 ======
if [ -f "$SURQL_FILE" ]; then
  echo ""
  echo "📤 开始导入数据文件 $SURQL_FILE ..."
  surreal import \
    --conn "$SURREALDB_URL" \
    --user "$USER" \
    --pass "$PASS" \
    --ns "$NAMESPACE" \
    --db "$DATABASE" \
    "$SURQL_FILE"
  echo "✅ 数据导入完成"
else
  echo "⚠️ 找不到文件 $SURQL_FILE，跳过数据导入"
fi