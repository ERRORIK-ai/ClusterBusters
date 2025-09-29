# Kubernetes Cluster

data "civo_size" "xmall" {
    filter {
        key = "name"
        values = ["g4s.kube.xsmall"]
        match_by = "re"
    }
}

resource "civo_kubernetes_cluster" "k8s_demo_1" {
    name         = "k8s_demo_1"
    applications = ""
    firewall_id  = civo_firewall.fw_demo_1.id

    pools {
        label      = "my-pool"
        size       = element(data.civo_size.xsmall.sizes, 0).name
        node_count = 2
    }
}


resource "civo_firewall" "fw_demo_1" {
    name = "fw_demo_1"

    create_default_rules = false # Dont allow traffic from every ip over all ports
    
}

resource "civo_firewall_rule" "kubernetes_http" {
    firewall_id = civo_firewall.fw_demo_1.id
    protocol = "tcp"
    start_port = "80"
    end_port = "80"
    cidr = ["0.0.0.0/0"]
    direction = "ingress"
    action = "allow"
    label = "kubernetes_http"
}

resource "civo_firewall_rule" "kubernetes_https" {
    firewall_id = civo_firewall.fw_demo_1.id
    protocol = "tcp"
    start_port = "443"
    end_port = "443"
    cidr = ["0.0.0.0/0"]
    direction = "ingress"
    action = "allow"
    label = "kubernetes_https"
}

resource "civo_firewall_rule" "kubernetes_api" {
    firewall_id = civo_firewall.fw_demo_1.id
    protocol = "tcp"
    start_port = "6443"
    end_port = "6443"
    cidr = ["0.0.0.0/0"] # Not secure, I know... But without the necessary certificates, nobody can access the API anyway.
    direction = "ingress"
    action = "allow"
    label = "kubernetes_api"
}