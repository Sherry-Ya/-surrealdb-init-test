#!/bin/bash
set -e

# ====== SurrealDB 连接配置 ======
SURREALDB_URL="http://localhost:8000"
USER="root"
PASS="root"

# ====== 设置 Namespace / Database ======
# 默认使用 commit hash（前 7 位）作为 namespace（如果在 GitHub Actions 中）
: "${GITHUB_SHA:=localtest1234567}"
NAMESPACE="${GITHUB_SHA:0:7}"
DATABASE="app"

# ====== 导入文件路径（从 GitHub 仓库中获取）======
SURQL_FILE="./init/export.surql"

echo "📌 当前 namespace = $NAMESPACE"
echo "📌 当前 database  = $DATABASE"
echo "📁 导入文件路径 = $SURQL_FILE"

# ====== 检查 surreal CLI 是否存在 ======
if ! command -v surreal &> /dev/null; then
  echo "🔧 未检测到 surreal CLI，正在安装..."
  curl -sSf https://install.surrealdb.com | sh
  sudo mv surreal /usr/local/bin
fi

# ====== 获取版本 ======
echo "🚀 正在请求 SurrealDB 版本信息..."
version_response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain')
echo "✅ SurrealDB 版本：$version_response"

# ====== 创建 NAMESPACE 和 DATABASE（幂等）======
echo ""
echo "📦 创建 NAMESPACE=$NAMESPACE 和 DATABASE=$DATABASE..."
curl -s -X POST "$SURREALDB_URL/sql" \
  -u "$USER:$PASS" \
  -H "Content-Type: text/plain" \
  -d "DEFINE NAMESPACE $NAMESPACE; USE NAMESPACE $NAMESPACE; DEFINE DATABASE $DATABASE;" \
  > /dev/null
echo "✅ 创建完成"

# ====== 执行导入 .surql 文件 ======
echo ""
echo "📤 开始导入 $SURQL_FILE ..."
surreal import \
  --conn "$SURREALDB_URL" \
  --user "$USER" --pass "$PASS" \
  --ns "$NAMESPACE" --db "$DATABASE" \
  "$SURQL_FILE"
echo "✅ 数据导入完成"