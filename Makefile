
.PHONY: all vagrant dynamic

all: vagrant dynamic

vagrant: 
	vagrant up --provision
	open http://192.168.96.51:8500

dynamic:
	rm -f consul_io.py
	wget https://raw.githubusercontent.com/ansible/ansible/v2.7.11/contrib/inventory/consul_io.py
	chmod u+x consul_io.py

	# consul_io.py failed if kv_groups is not defined
	curl --request PUT --data "0" http://192.168.96.51:8500/v1/kv/ansible/groups
	# consul_io.py failed if kv_metadata is not defined
	curl --request PUT --data "0" http://192.168.96.51:8500/v1/kv/ansible/metadata

	ansible-playbook -i consul_io.py debug.yml -u vagrant -k
