#!/bin/bash
# 指定使用 bash 解释器执行该脚本

set -e
# 当脚本执行中遇到任何命令返回非 0（出错）时，立即终止整个脚本
# 用于避免继续执行后续命令导致错误或数据污染

# 用你的公网 SurrealDB 地址替换，比如用 ngrok 暴露本地端口
SURREALDB_URL="https://620c-221-248-160-222.ngrok-free.app"

# 连接 SurrealDB 所需的用户名和密码（默认是 root/root）
USER="root"
PASS="root"

# 使用 curl 向 SurrealDB 的 /sql 接口发送 SQL 初始化请求
# 包含两个操作：DEFINE NAMESPACE test; DEFINE DATABASE test;

#curl -s --request POST "$SURREALDB_URL/sql" \      # 发送 POST 请求到 SurrealDB 的 SQL 接口
#  --header "Content-Type: application/json" \      # 设置请求头：声明这是 JSON 数据
#  --user "$USER:$PASS" \                           # 基本认证，传入用户名和密码
#  --data '{"query":"DEFINE NAMESPACE dev; DEFINE DATABASE dev;" }'

  curl --location --request GET 'http://192.168.0.72:8000/version' \
  --header 'Accept: text/plain' \
  --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
  --header 'Host: 192.168.0.72:8000' \
  --header 'Connection: keep-alive'
  # 请求体为 JSON，里面是 SurrealQL 语句：创建命名空间和数据库