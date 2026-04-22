graph TD
    User((Public User)) -->|HTTPS: abc.lxhome.fr| LB[Node IP: 443]
    
    subgraph K3s Cluster
        LB --> NIC[NGINX Ingress Controller]
        
        subgraph Namespace: Cert-Manager
            CM[Cert-Manager] <--> LE[Let's Encrypt API]
        end

        subgraph Namespace: Default
            NIC -->|Route via Ingress| S1[Service: App ABC]
            S1 --> P1[Pod: Container Port 3000]
            
            NIC -->|Route via Ingress| S2[Service: App Test]
            S2 --> P2[Pod: Container Port 8081]
        end

        NIC -.->|Watches| Secret[TLS Secrets Store]
        CM -.->|Writes| Secret
    end