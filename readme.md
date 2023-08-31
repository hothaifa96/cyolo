# NATS Cluster and Python Environment Setup

This repository contains Terraform configurations to set up a NATS cluster with 3 instances on AWS. It also includes a Python script that loads environment variables from a `values.env` file and interacts with the NATS cluster.

## installations

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
- AWS-cli
- AWS credentials configured either as environment variables or in `~/.aws/credentials`.
- Python 3.11 installed on your machine.
- docker and docker compose if we need to run the cide in docker-compose

## project Setup

1. Clone this repository
3. configure aws-cli
2. Iniitialize and apply terraform
3. using pip3 install the requirements.txt file
4. add the subscriber , publisher, subject and message values into values.env
5. Run `python main.py`
## or
1. using docker compose start 3 nets contaners
2. 4. add the subscriber , publisher, subject and message values into values.env
3. Run `python main.py`

## project structure
- cyolo
- ├─ docker-compose-cluster ..... (built while learning nats for this demo)
- │  ├─ docker-compose.yaml ..... docker-compose file
- │  ├─ server-configs ..... server config files
- │  │  ├─ server1.conf ...... server1 conf file
- │  │  ├─ server2.conf ...... server2 conf file
- │  │  └─ server3.conf ...... server3 conf file
- ├─ publisher ......... publisher and subscriber
- │   ├─ p.py ..... publisher script
- │   └─ s.conf ......sublisher script
- ├─ test . package-lock.json
- │   ├─ values.env................. env file
- │   ├─ test_cluster.py................. test script
- │   └─ requirements.env................. packages to install
- ├─ main.tf ...... terraform file
- └─ readme.md ..... readme.md

