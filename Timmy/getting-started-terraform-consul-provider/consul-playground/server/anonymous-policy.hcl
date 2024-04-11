acl = "write"
key_prefix "consul-esm/" {
  policy = "write"
}
agent_prefix "" {
	policy = "write"
}
event_prefix "" {
	policy = "read"
}
key_prefix "" {
	policy = "read"
}
keyring = "read"
node_prefix "" {
	policy = "write"
}
operator = "read"
query_prefix "" {
	policy = "read"
}
service_prefix "" {
	policy = "read"
	intentions = "read"
}
session_prefix "" {
	policy = "read"
}
