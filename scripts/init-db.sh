#!/bin/bash
set -e

SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"
NAMESPACE="momo"
DATABASE="momo"

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
  -H "NS: $NAMESPACE" \
  -d "DEFINE DATABASE $DATABASE;")
echo "✅ 创建数据库结果：$create_db"