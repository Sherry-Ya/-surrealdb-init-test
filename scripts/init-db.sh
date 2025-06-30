#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e
# 出错立即退出

# 用你的 SurrealDB 地址（Ngrok 或其他公网地址）
SURREALDB_URL="https://your-ngrok-url.ngrok-free.app"

echo "🚀 正在请求 SurrealDB 版本信息..."

# 调用 SurrealDB 的 /version 接口（无需认证，无需 SQL）
response=$(curl -s -w "%{http_code}" -o /tmp/version.txt "$SURREALDB_URL/version")

if [ "$response" != "200" ]; then
  echo "❌ 请求失败，HTTP 状态码: $response"
  exit 1
fi

echo "✅ SurrealDB 可用，版本信息如下："
cat /tmp/version.txt