# 步驟
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply --auto-approve
---
其中因為 consul-server 用 systemctl 啟動 consul、consul-esm 需要些時間
所以 remote-exec 有睡覺一下，不然 consul_node 會一直註冊失敗

# 參考
https://developer.hashicorp.com/consul/tutorials/developer-discovery/terraform-consul-provider