#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e
# 当脚本执行中遇到任何命令返回非 0（出错）时，立即终止整个脚本

# SurrealDB 的本地地址（也可以换成 ngrok 公网地址）
SURREALDB_URL="http://192.168.0.72:8000"

echo "🚀 正在请求 SurrealDB 版本信息..."

# 使用 curl 访问 /version 接口，并捕获返回结果
response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain' \
  --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
  --header "Host: 192.168.0.72:8000" \
  --header "Connection: keep-alive")

# 打印接口返回内容
echo "✅ SurrealDB 版本：$response"