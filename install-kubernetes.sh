#!/usr/bin/env bash

<<-"COMMENT"

    Description: This script will install kubernetes on a RHEL system

    Author: iStackz

    Date: 8/2/2026
    Updated: 8/17/2026

    Source: https://lucaberton.com/blog/install-kubernetes-rocky-linux-9

    Note: I used this guide and added my own sauce to complete the install, most of the heavy lifting was provided by this guide.
    This script will prompt the user for input to determine if it is performing a control-plane node setup or a worker node setup. Alternatively,
    make sure to use the words 'control' or 'serv/er' in the hostname for the control-plane nodes and 'work/er' for the worker nodes 
    
    Always be sure to review the script before you run it and edit the file as needed

COMMENT

# function to install Flannel CNI
install_flannel() {
    
    # Option A: Flannel (simple)
    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

    return 0
}

# function to install Cilium CNI
install_cilium() {

    # Option B: Cilium (advanced, eBPF-based)
    CILIUM_CLI_VERSION="$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)"

    curl -L --fail https://github.com/cilium/cilium-cli/releases/download/"${CILIUM_CLI_VERSION}"/cilium-linux-amd64.tar.gz | tar -xz -C /usr/local/bin

    # install cilium
    cilium install

    # verify cilium install
    cilium status --wait

    # unset environment variable
    unset CILIUM_CLI_VERSION

    # check nodes again
    kubectl get nodes

    return 0
}

# function for kubernetes' control-plane nodes (server) 
control_plane_setup() {

    # check if firewall is active
    if [[ "$(firewall-cmd --state)" =~ running ]]
    then
        # multi-line comment
        <<-COMMENT
            ports explaination:

                6443 --> API Server
                2379,2380 --> etcd
                10250 --> kubelet
                10259 --> scheduler
                10257 --> controller-manager
        COMMENT

        # whitelist ports on firewall
        firewall-cmd --add-port={6443/tcp,2379-2380/tcp,10250/tcp,10259/tcp,10257/tcp}
        firewall-cmd --runtime-to-permanent # make changes persist
        firewall-cmd --reload # reload configuration changes
    fi

    # check if kubeadm is installed
    if [[ "$(rpm -qa | grep -i 'kubeadm')" ]]
    then
        # local variable
        local ipv4_net=10.244.0.0/16

        # run until user inputs correct 
        #while true
        #do
        #   # prompt for user input
        #   read -p "Enter a subnet for pod IPv4 assignment (CIDR notation) (CIDR IE /8 /16 /24) (example: 192.168.1.0/16): " ipv4_net
        #
        #   # validate user input
        #   if [[ "$ipv4_net" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]
        #   then
        #       # initializes pod for flannel (CNI) (a network for kubernetes)
        #       kubeadm init --pod-network-cidr="${ipv4_net}"
        #       break # exit out of the while loop
        #   else
        #       echo -e "\e[31mError! Invalid format. Please try again."
        #       echo -e "\n"
        #   fi
        #done

        # initialize pod for flannel CNI
        kubeadm init --pod-network-cidr="${ipv4_net}"

        # unset variable
        unset ipv4_net
    fi

    # check if directory exists
    if [[ ! -d "${HOME}"/.kube ]]
    then
        # create directory
        mkdir "${HOME}"/.kube
    fi

    # check if file exists
    if [[ ! -e "${HOME}"/.kube/config ]]
    then
        # check if file exists
        if [[ -e /etc/kubernetes/admin.conf ]]
        then
            # copy file to path
            cp /etc/kubernetes/admin.conf "${HOME}"/.kube/config

            # set ownership of file
            chown "$(id -u)":"$(id -u)" "${HOME}"/.kube/config

            # set permissions of file
            chmod 0644 "${HOME}"/.kube/config
        fi
    fi

    # verify the API server is running
    kubectl get nodes | tee -a ./kube_install.log 2>&1

    # Install a CNI pluggin (uncomment one of the two options below)

    # Option A: Install Flannel (simple)
    install_flannel

    # Option B: Install Cilium (advanced, eBPF-based)
    #install_cilium

    # generate token and print join command (to be used by the worker nodes)
    kubeadm token create --print-join-command | tee -a ./kube_install.log 2>&1 

    # print message
    echo -e "\nRun this command on each worker node"
    echo -e "kubeadm join <control-plane_ipv4>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
    echo -e "replace the placeholders with your applicable information\n"
    
    # verify the control-plane
    kubectl get nodes | tee -a ./kube_install.log 2>&1

    return 0
}


# function for the kubernetes' worker nodes
worker_setup() {

    # check if firewall is running
    if [[ "$(firewall-cmd --state)" =~ running ]]
    then
        # multi-line comment
        #<<-"COMMENT"
        #   ports explaination:
        #
        #   10250 --> kubelet
        #   10256 --> kube-proxy
        #   30000 --> nodeport
        #COMMENT    

        # whitelist ports
        firewall-cmd --add-port={10250/tcp,10256/tcp,30000-32767/tcp}
        firewall-cmd --runtime-to-permanent
        firewall-cmd --reload
    fi

    # print message
    echo -e "\nGet the join token from the control-plane (kubernetes server node) and run the 'kubeadm join' command, follow the syntax: "
    echo -e "kubeadm join <control-plane_ipv4>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
    echo -e "replace the placeholders with your applicable information\n"

    return 0
}

# main function
main() {

    # check if running as root
    if [[ "$(id -u)" != '0' ]]
    then
        echo -e "\e[31mError! Script must be ran as root. Try again!\e[0m"
        exit 1
    fi

    # disable swap
    swapoff -a

    sed -i '/ swap / s/^/#/' /etc/fstab

    # create conf file to persist the loading of kernel modules
    cat <<-EOF > /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF

    # set conf file permissions
    chmod 0644 /etc/modules-load.d/k8s.conf
    
    # command to load kernel modules
    modprobe overlay
    modprobe br_netfilter

    # create conf file with required sysctl parameters
    cat <<-EOF > /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward = 1
    EOF
    
    # set conf permissions
    chmod 0644 /etc/sysctl.d/k8s.conf

    # apply configs
    sysctl -p /etc/sysctl.d/k8s.conf

    # set SELINUX to permissive (required by kubelet)
    setenforce 0 # temporary for session

    # search file for keyword
    if [[ "$(grep -i 'selinux' /etc/selinux/config | cut -d '=' -f 2)" != 'permissive' ]]
    then
        # search and replace
        sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config # persists after reboots
    fi

    # add docker repo (for containerd.io package)
    if [[ ! -e /etc/yum.repos.d/docker-ce.repo ]]
    then
        yum config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    fi

    # install containerd if not installed
    if [[ ! "$(rpm -qa | grep -i 'containerd.io')" ]]
    then
        yum install -y containerd.io
    fi

    # generate the default config
    if [[ ! -e /etc/containerd/config.toml ]]
    then
        # create file
        containerd config default | tee /etc/containerd/config.toml

        # set permissions
        chmod 0644 /etc/containerd/config.toml
    fi

    # enable SystemdCgroup (critical for Kubernetes)
    if [[ -e /etc/containerd/config.toml ]]
    then
        # look for keyword
        if [[ "$(grep -i 'systemdcgroup' /etc/containerd/config.toml)" ]]
        then
            # look for keyword
            if [[ "$(grep -i 'systemdcgroup' /etc/containerd/config.toml | cut -d '=' -f 2 | tr -d ' ')" != 'true' ]]
            then
                # search and replace
                sed -r -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
            fi
        else
            containerd config default | tee /etc/containerd/config.toml

            chmod 0644 /etc/containerd/config.toml

            if [[ ! "$(grep -i 'systemdcgroup' /etc/containerd/config.toml | cut -d '=' -f 2 | tr -d ' ')" =~ true ]]
            then
                sed -r -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
            fi
        fi
    fi

    # make rc.local executable
    if [[ "$(stat -c "%a" /etc/rc.d/rc.local)" != '744' ]]
    then
        chmod 0744 /etc/rc.d/rc.local
    fi

    # start and enable containerd
    systemctl restart containerd
    systemctl enable --now containerd

    # verify containerd status
    if [[ "$(systemctl is-active containerd)" =~ active ]]
    then
        echo -e "\e[33mSuccess! Containerd is running here is it's status:\e[0m" >> ./kube_install.log
        echo -e "\n $(systemctl status containerd) " | tee -a ./kube_install.log 2>&1
    fi

    # Add kubernetes repository
    local kube_version="$(curl -sSL https://dl.k8s.io/release/stable.txt)" # get kubernetes latest version number
    local version="${kube_version%.[0-9]}" # remove the last part from the version number (.<digit>)

    # check if the repository file exists
    if [[ ! -e /etc/yum.repos.d/kubernetes.repo ]]
    then
        # create the file
        cat <<-EOF > /etc/yum.repos.d/kubernetes.repo
        [kubernetes]
        name=kubernetes
        baseurl=https://pkgs.k8s.io/core:/stable:/${version}/rpm/
        enabled=1
        gpgcheck=1
        gpgkey=https://pkgs.k8s.io/core:/stable:/${version}/rpm/repodata/repomd.xml.key
        EOF

        # set permissions on repo file
        chmod 0644 /etc/yum.repos.d/kubernetes.repo
    fi

    # unset variables
    unset kube_version
    unset version

    # install kubelet, kubeadm, and kubectl
    yum install -y kubelet kubeadm kubectl

    # enable kubelet (it will wait for kubeadm init)
    systemctl enable --now kubelet

    #--- OPTIONS do it by host name OR prompt user ---#

    # verify hostname for control-plane or worker
    #if [[ "$(hostname)" =~ (serv|control) ]]
    #then
    #   control_plane
    #elif [[ "$(hostname)" =~ (work|client) ]]
    #then
    #   worker
    #fi

    # while loop to prompt user for input

    local user_input

    while true
    do
        # promp user
        read -p "Is this a control-plane or a worker node? (control-plane/worker): " user_input

        # validate user input
        if [[ "$user_input" =~ worker ]]
        then
            worker_setup # call function
            break # break out of while loop
        elif [[ "$user_input" =~ control-plane ]]
        then
            control_plane_setup # call function
            break # break out of while loop
        else
            echo -e "\e[31Error! Wrong input. Enter either 'control-plane' OR 'worker'. try again!\e[0m"
        fi
    done

    unset user_input

    return 0
}

# run the main function
main

# successful exit
exit 0

#----------------------- NOTES ----------------------#

## suggestions below were grabbed from the source material ##

#<<TESTING
## All system pods should be running
#kubectl get pods -n kube-system
#
## Deploy a test application
#kubectl create deployment nginx --image=nginx:alpine --replicas=2
#kubectl expose deployment nginx --port=80 --type=NodePort
#kubectl get svc nginx
#
## Access via http://<node-ip>:<nodeport>
#
## cleanup test
#kubectl delete deployment nginx
#kubectl delete svc nginx
#TESTING
#
#<<HARDENING
## add the following to /etc/kubernetes/manifests/kube-apiserver.yaml enable logging
#--audit-log-path=/var/log/kubernetes/audit.log
#--audit-policy-file=/etc/kubernetes/audit-policy.yaml
#
## back up etcd
#ETCDCTL_API=3
#
#if [[ ! -d /backup ]]
#then
#   mkdir /backup
#fi
#
#etcdctl snapshot save /backup/etcd-snapshot.db \
#--endpoints=https://127.0.0.1:2379 \
#--cacert=/etc/kubernetes/pki/etcd/ca.crt \
#--key=/etc/kubernetes/pki/etcd/server.key
#
## installing a metrics server
#kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#HARDENING
#
#<<TROUBLESHOOTING
## if kubelet doesn't start (common issue: containerd isn't running or SystemdCgroup is not enabled)
#journalctl -xeu kubelet
#
## if node stays in 'NotReady' mode (Check if CNI is installed or if there are network plugin errors)
#kubectl describe node <name>
#
## if kubeadm init fails with pre-flight errors (reset and retry)
#kubeadm reset -f
#rm -rf /etc/cni/net.d
#kubeadm init --pod-network-cidr=<ipv4_address>/<cidr> # sets the subnet block for IPv4 pod assignment
#TROUBLESHOOTING

