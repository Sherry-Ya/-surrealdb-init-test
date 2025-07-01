#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e

# 公网地址或本地 SurrealDB 地址
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"

USER="root"
PASS="root"
NAMESPACE="dev"
DATABASE="dev"

echo "🚀 正在请求 SurrealDB 版本信息..."

version_response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain')

echo "✅ SurrealDB 版本：$version_response"

echo ""
echo "📦 正在初始化 NAMESPACE=$NAMESPACE, DATABASE=$DATABASE..."

# 添加 Accept: application/json 头
init_response=$(curl -s -X POST "$SURREALDB_URL/sql" \
  -u "$USER:$PASS" \
  -H "Accept: application/json" \
  -H "Content-Type: text/plain" \
  -d "DEFINE NAMESPACE $NAMESPACE; DEFINE DATABASE $DATABASE;")

echo "✅ 初始化结果："
echo "$init_response"