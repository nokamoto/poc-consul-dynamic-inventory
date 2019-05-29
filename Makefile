
.PHONY: all vagrant dynamic

all: vagrant dynamic debug

vagrant: 
	vagrant up --provision
	open http://192.168.96.51:8500

dynamic:
	wget -nc https://raw.githubusercontent.com/ansible/ansible/v2.7.11/contrib/inventory/consul_io.py
	chmod u+x consul_io.py

	# consul_io.py failed if kv_groups is not defined
	curl --request PUT --data "foo-your-cluster,master" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node01 && echo
	curl --request PUT --data "foo-your-cluster,worker" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node02 && echo
	curl --request PUT --data "foo-your-cluster,worker" http://192.168.96.51:8500/v1/kv/ansible/groups/dc1/node03 && echo

	# consul_io.py failed if kv_metadata is not defined
	curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node01 && echo
	curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node02 && echo
	curl --request PUT --data '{"service": "foo", "cluster": "your-cluster", "version": "v1.14.1"}' http://192.168.96.51:8500/v1/kv/ansible/metadata/dc1/node03 && echo

	python consul_io.py

debug:
	ansible-playbook -i consul_io.py debug.yml -u vagrant -k
