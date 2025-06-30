#!/bin/bash
set -e

# 设置 SurrealDB 地址和登录凭据
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"
USER="root"
PASS="root"

# SQL 初始化语句（可以用换行拼接）
INIT_SQL=$(cat <<EOF
DEFINE NAMESPACE dev;
DEFINE DATABASE dev;
EOF
)

echo "🚀 正在初始化 SurrealDB..."
echo "$INIT_SQL"

# 发送 SQL 请求
response=$(curl -s -w "%{http_code}" -o /tmp/response.json \
  --request POST "$SURREALDB_URL/sql" \
  --user "$USER:$PASS" \
  --header "Content-Type: application/json" \
  --data "{\"query\":\"$INIT_SQL\"}")

# 检查 HTTP 状态码
if [ "$response" != "200" ]; then
  echo "❌ 初始化失败，HTTP 状态码: $response"
  echo "❗ 错误信息："
  cat /tmp/response.json
  exit 1
fi

echo "✅ 初始化成功"
cat /tmp/response.json