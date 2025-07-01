#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e
# 当脚本执行中遇到任何命令返回非 0（出错）时，立即终止整个脚本

# 使用 ngrok 分配的公网地址访问 SurrealDB
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"

echo "🚀 正在请求 SurrealDB 版本信息..."

# 使用 curl 访问 /version 接口，并捕获响应内容
response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain' \
)

# 打印 SurrealDB 返回的版本号
echo "✅ SurrealDB 版本：$response"