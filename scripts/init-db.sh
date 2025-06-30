#!/bin/bash
set -e

# SurrealDB 地址与账号信息
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"

# SQL 查询，必须压缩为单行，并替换换行符为 \n
INIT_SQL="DEFINE NAMESPACE dev; DEFINE DATABASE dev;"

echo "🚀 正在初始化 SurrealDB..."
echo "$INIT_SQL"

# 执行请求
response=$(curl -s -w "%{http_code}" -o /tmp/response.json \
  --request POST "$SURREALDB_URL/sql" \
  --user "$USER:$PASS" \
  --header "Content-Type: application/json" \
  --data "{\"query\":\"$INIT_SQL\"}")

# 检查返回码
if [ "$response" != "200" ]; then
  echo "❌ 初始化失败，HTTP 状态码: $response"
  echo "❗ 错误信息："
  cat /tmp/response.json
  exit 1
fi

echo "✅ 初始化成功"
cat /tmp/response.json