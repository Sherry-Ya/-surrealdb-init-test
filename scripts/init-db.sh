#!/bin/bash
set -e

SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"

# 查询 SurrealDB 版本
SQL="RETURN version();"

echo "🚀 测试连接：RETURN version()"

response=$(curl -s -w "%{http_code}" -o /tmp/response.json \
  --request POST "$SURREALDB_URL/sql" \
  --user "$USER:$PASS" \
  --header "Content-Type: application/json" \
  --data "{\"query\":\"$SQL\"}")

if [ "$response" != "200" ]; then
  echo "❌ 请求失败，HTTP 状态码: $response"
  cat /tmp/response.json
  exit 1
fi

echo "✅ 请求成功，SurrealDB 版本："
cat /tmp/response.json