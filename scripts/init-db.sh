#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e
# 当脚本执行中遇到任何命令返回非 0（出错）时，立即终止整个脚本

# ✅ 使用 ngrok 分配的公网地址访问 SurrealDB
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"

# ✅ 系统管理员账户（默认 root/root）
USER="root"
PASS="root"

# ✅ 要初始化的 namespace 和 database
NAMESPACE="dev"
DATABASE="dev"

echo "🚀 正在请求 SurrealDB 版本信息..."

# 访问 /version 接口并打印版本号
version_response=$(curl -s --location --request GET "$SURREALDB_URL/version" \
  --header 'Accept: text/plain')

echo "✅ SurrealDB 版本：$version_response"

echo ""
echo "📦 正在初始化 NAMESPACE=$NAMESPACE, DATABASE=$DATABASE..."

# 执行 SQL 初始化（创建 namespace 和 database）
init_response=$(curl -s -X POST "$SURREALDB_URL/sql" \
  -u "$USER:$PASS" \
  -H "Content-Type: application/json" \
  -d "{\"query\": \"DEFINE NAMESPACE $NAMESPACE; DEFINE DATABASE $DATABASE;\"}")

echo "✅ 初始化结果："
echo "$init_response"