#!/bin/bash
set -e

# ====== SurrealDB 连接信息 ======
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"

# ====== NAMESPACE / DATABASE 使用 commit hash 作为唯一命名空间 ======
NAMESPACE=${GITHUB_SHA:0:7}
DATABASE=${GITHUB_SHA:0:7}

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

# ====== 检查 surreal CLI 是否存在，否则安装 ======
if ! command -v surreal &> /dev/null; then
  echo ""
  echo "🔧 未检测到 surreal CLI，正在安装..."
  curl -sSf https://install.surrealdb.com | sh
  sudo mv surreal /usr/local/bin
  echo "✅ Surreal CLI 安装完成"
fi

# ====== 导入 .surql 文件到数据库 ======
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