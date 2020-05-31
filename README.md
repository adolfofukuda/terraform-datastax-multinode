# Terraform-datastax-multinode


Follow these steps to get a 3 node cassandra cluster up and running.

* Install terraform.

* Adicionar na pasta pki os arquivos id_rsa e id_rsa.pub

* Update variables.tf with proper values

* run
  ```
  terraform get
  ```

This is to install an external module for cassandra security groups.

* run
  ```
  terraform plan
  ```

Review the changes.

* run
  ```
  terraform apply
  ```

To bring up resources.  At the end you should get the public IP address
of your nodes.  run ```terraform show``` at any time to get those public ips
for the next steps.

*  Para acessar 
   Na pasta terraform-datastax-multinode digitar:
   
   ssh -i pki/id_rsa ubuntu@<ip_addr of cassandra master>

*  Once your instances are up, ssh into each instance.  cassandra_0 and cassandra_1 are seed
nodes so you must do those one at a time.

ubuntu@ip-10-2-5-172:~$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens       Owns (effective)  Host ID                               Rack
UN  10.2.5.170  149.84 KB  256          64.3%             00a6ca46-a115-4dbf-a4af-68bfc830395f  rack1
UN  10.2.5.171  170.39 KB  256          69.0%             b4e6b40a-6e51-47b1-8493-aadc2949db47  rack1
UN  10.2.5.172  163.16 KB  256          66.7%             3294d6b2-a59a-41fb-8cac-53343cb8c049  rack1


