# Kubernetes Cluster

data "civo_size" "xsmall" {
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

    ingress_rule {
        action     = "allow"
        cidr       = ["0.0.0.0/0"]
        protocol   = "tcp"
        port_range = "80"
        label      = "kubernetes_http"
    }

    ingress_rule {
        action     = "allow"
        cidr       = ["0.0.0.0/0"]
        protocol   = "tcp"
        port_range = "443"
        label      = "kubernetes_https"
    }

    ingress_rule {
        action     = "allow"
        cidr       = ["0.0.0.0/0"]
        protocol   = "tcp"
        port_range = "6443"
        label      = "kubernetes_api"
    }

}