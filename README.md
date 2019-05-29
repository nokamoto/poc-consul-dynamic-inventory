# poc-consul-dynamic-inventory

```bash
$ make
```

## dynamic inventory
```bash
# consul_io.py failed if kv_groups is not defined
curl --request PUT --data "foo-your-cluster,master" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node01 && echo
curl --request PUT --data "foo-your-cluster,worker" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node02 && echo
curl --request PUT --data "foo-your-cluster,worker" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node03 && echo

# consul_io.py failed if kv_metadata is not defined
curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node01 && echo
curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node02 && echo
curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node03 && echo
```

```bash
python consul_io.py
{
  "_meta": {
    "hostvars": {
      "192.168.96.51": {
        "cluster": "your-cluster",
        "consul_datacenter": "dc1",
        "consul_nodename": "node01",
        "service": "foo",
        "version": "v1.14.1"
      },
      "192.168.96.52": {
        "cluster": "your-cluster",
        "consul_datacenter": "dc1",
        "consul_nodename": "node02",
        "service": "foo",
        "version": "v1.14.1"
      },
      "192.168.96.53": {
        "cluster": "your-cluster",
        "consul_datacenter": "dc1",
        "consul_nodename": "node03",
        "service": "foo",
        "version": "v1.14.1"
      }
    }
  },
  "all": [
    "192.168.96.51",
    "192.168.96.52",
    "192.168.96.53"
  ],
  "dc1": [
    "192.168.96.51",
    "192.168.96.52",
    "192.168.96.53"
  ],
  "foo-your-cluster": [
    "192.168.96.51",
    "192.168.96.52",
    "192.168.96.53"
  ],
  "master": [
    "192.168.96.51"
  ],
  "worker": [
    "192.168.96.52",
    "192.168.96.53"
  ]
}
```
