---
title: "Kubernetes on Raspberry Pi - Part 2"
date: 2024-06-08T09:30:03+00:00
# weight: 1
# aliases: ["/first"]
tags: ["kubernetes", "homelab", "raspberrypi", "k3s", "ansibible"]
categories: ["homelab", "kubernetes", "raspberrypi", "automation"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: true
description: "Multi-part series on working with Kubernetes"
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "/images/k8s-raspberry-pi/ansible.png" # image path/url
    alt: "Ansible" # alt text
    caption: "Automation with Ansible" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
    hiddenInList: false
    hiddenInSingle: false
    linkFullImages: true
---

## Ansible

As I am aware that this will not be the last time I will rebuild this cluster (I plan setup HA on the controlplane at a later time)I need a way to automate and simplify the cluster rebuild process each time. Enter Ansible. Ansible is an open-source automation tool that simplifies complex IT tasks. Written in Python, it allows you to automate various operations, such as system configuration, software deployment, and workflow orchestration. Ansible’s strengths lie in its simplicity and ease of use, making it a popular choice for managing infrastructure and achieving operational excellence across different platforms

### Installing Ansible

The only dependency that Ansible has is Python installed on your local machine. If you are on a Mac like myself it is fairly simple to install. (I use brew for package management)

``` 
brew install ansible

# Alternatively
# pip3 install ansible
```

For other operating systems, its fairly simple to find alternative package managers to get Ansible installed (choco, yum, apt, etc.)

### Creating an Inventory File

Ansible will use an inventory file to communicate with my servers. Like a hosts file on your local machine (found at /etc/hosts), which matches IP addresses to domain names. Ansible's inventory file matches the IP addresses I've configured on my Raspberry Pi's to groups. Hosts file can be either `.ini` or `.yaml`, since my inventory is relatively simple I will be using a INI file. For more complex inventories, I would recommend defining your inventory in YAML.

My inventory file looks like the following:

```
# Control Plane Nodes
[controlplane]
controlplane1 ansible_host=192.168.1.100 

# Worker Nodes
[workers]
worker1 ansible_host=192.168.1.101 
worker2 ansible_host=192.168.1.102 
worker3 ansible_host=192.168.1.103 

# Group 'bramble' with all k3s nodes.
[bramble:children]
controlplane
workers

# Variables that will be applied to all
[bramble:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

- [controlplane] and [workers] are groups that I have defined.
- [bramble:children] is a group of groups.
- I defined in each respective line the hostname of the node and the local IP address of the node on my network.
- Finally I defined a group variable that specifies the desired SSH private key I want Ansible to use when communicating with my nodes.

### Ad-Hoc Ansible Command

Now that I have Ansible installed and created an inventory file, let's just run a command to validate everything is functional. 

```
ansible controlplane -m ping -u chunwu

[WARNING]: Platform linux on host cp1 is using the discovered Python interpreter at
/usr/bin/python3.11, but future installation of another Python interpreter could change the meaning
of that path. See https://docs.ansible.com/ansible-
core/2.17/reference_appendices/interpreter_discovery.html for more information.
cp1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.11"
    },
    "changed": false,
    "ping": "pong"
}
```

The ad-hoc command above will ping all nodes in the group `controlplane`. In my case, since I only have one node specified I only get a response from one node. I also specified my a username of `chunwu` which is how I configured Raspberry Pi OS when I imaged the SD cards.

## K3s

Before I jump into the specific Ansible playbook for my cluster configuration, let's dive into steps if we were to do this manually.

### CGroup Configuration

Other guides you may find online will ask you to modify `/boot/firmware/cmdline.txt` but more recently the file you need to modify is `/boot/cmdline.txt`. The `cmdline.txt` file is a configuration file, located in the boot paritition of the SD card on Raspberry Pi, and used to pass additional parameters to the Linux Kernel for the system boot. Read more about cgroups [here](https://www.man7.org/linux/man-pages/man7/cgroups.7.html)

```
# 1. Open the cmdline.txt file
sudo vim /boot/firmware/cmdline.txt

#2. Add below into THE END of the current line
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory

# 3. Save the file and reboot
sudo shutdown -r now
```

### Master Node Installation

Run the following command to install the K3s master node. 

```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable=traefik --flannel-backend=host-gw --tls-san=192.168.1.85 --bind-address=192.168.1.85 --advertise-address=192.168.1.100 --node-ip=192.168.1.100 --cluster-init" sh -s -
```

There a multitude of ways to configure K3s installation, more details can be found in the [documentation](https://docs.k3s.io/installation/configuration). In the command I have specified...

- server: This is telling k3s to run in server mode (as opposed to agent mode). In server mode, k3s will start up and manage Kubernetes master components.
- disable=traefik: This is instructing k3s to disable the Traefik ingress controller. By default, k3s includes and enables Traefik; this flag will prevent that from happening. I plan to install at a later time using Helm.
- flannel-backend=host-gw: This flag is setting the backend for Flannel (k3s’s default network provider) to use. The host-gw option provides high-performance networking by creating a route for each node in the cluster.
- tls-san=192.168.1.85: The — tls-san flag allows you to specify additional IP or DNS names that should be included in the TLS certificate that is automatically generated for the Kubernetes API server. You can repeat this flag to add more than one SAN. The value 192.168.1.85 is an additional Subjective Alternative Name (SAN) for the Kubernetes API server’s certificate.
- bind-address=192.168.1.85: This is the IP address that the k3s API server will listen on.
- advertise-address=192.168.1.85: This is the IP address that the k3s API server will advertise to other nodes in the cluster. They will use this IP to connect to the API server.
- node-ip=192.168.1.85: This defines the IP that should be used for Kubernetes services on the nod
- cluster-init: This flag instructs k3s to initialize a new Kubernetes cluster. If this flag is not provided, k3s will join an existing cluster if one is available.

As evolve my configuration I keep this section up to date. Once installed, the k3s configuration should be located in `/etc/rancher/k3s/k3s.yaml`. I recommend changing the file permissions and creating a `k3s` configuration file in your `~/.kube/conf.yaml` local machine so that you can access your cluster.

### Worker Node Installation

To install the worker nodes, we first need to obtain the K3S_TOKEN from the master node. Execute the command shown below to retrieve it:

```
# get node-token from master node
sudo cat /var/lib/rancher/k3s/server/node-token
```

Upon retrieval of the node token, it is necessary to inject it into the script shown below. This script should be executed on all the Pi nodes specified previously. Please ensure to update the IP address associated with K3S_URL, as required.

```
# Execute this to install the nodes
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.100:6443 \
  K3S_TOKEN="<token>" sh -
```

That's it your cluster is now configured! But that's an awful a lot of work to repeat manually if wish to ever rebuild your cluster.

## Ansible Playbook

The following Ansible playbook will do everything I mentioned above:

```
---
- name: Node Preparation
  become: true
  hosts: bramble
  tasks:
  - name: Ping Host
    ping: 
  - name: Enable Cgroups
    lineinfile:
      path: /boot/firmware/cmdline.txt
      backrefs: true
      regexp: '^((?!.*\bcgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory\b).*)$'
      line: '\1 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory'
    notify: 
    - Restart Raspberry Pi
  handlers:
  - name: Restart Raspberry Pi
    reboot:

- name: Install k3s on controlplane
  become: true
  hosts: controlplane
  tasks:
  - name: Ping Host
    ping:
  - name: Install K3s on controlplane server
    shell: 'curl -sfL https://get.k3s.io | sh -'
  - name: Give k3s time to startup agent
    pause:
      seconds: 60
  - name: Extract K3S_TOKEN from server output
    command: cat /var/lib/rancher/k3s/server/node-token
    register: k3s_token
    failed_when: k3s_token is failed or k3s_token.stdout is undefined
  - name: Set K3S_Token as a fact
    set_fact:
      k3s_token: "{{ k3s_token.stdout }}"

- name: Install k3s on workers nodes
  become: true
  hosts: workers
  tasks:
  - name: Ping hosts
    ping:
  - name: Install k3s onto worker nodes
    shell: curl -sfL https://get.k3s.io | K3S_URL=https://{{ hostvars['cp1']['ansible_default_ipv4'].address }}:6443 K3S_TOKEN={{ hostvars['cp1']['k3s_token'] }} K3S_NODE_NAME={{ inventory_hostname }} sh -

- name: Get k3s kubeconfig
  become: true
  hosts: controlplane
  tasks:
  - name: Fetch kubeconfig
    fetch: 
      src: /etc/rancher/k3s/k3s.yaml
      dest: k3sconfig
      flat: true
```

You can also refer to my [Github repository](https://github.com/CPWu/raspberry-pi-bramble/tree/main/playbooks).

## What's Next?

There are several different paths I can take with this guide on Part 3, stay tuned!