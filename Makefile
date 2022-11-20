all: vagrant

vagrant:
	vagrant up --no-destroy-on-error --no-color | tee ./vagrantup.log
	./scripts/forward-ssh.sh

clean:
	vagrant destroy -f --no-color
	rm -rf .vagrant ./*.log
