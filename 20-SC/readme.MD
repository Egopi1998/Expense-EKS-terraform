security group modules:

    public → Covers bastion, ingress ALB, and public access
    private → Covers EKS, RDS, internal services

    Public Access Rules (public SG):
        SSH (22) -- open to the internet (same risk as before)
        HTTPS (443) -- open to the internet
        HTTP (80) -- open to the internet
    Private Access Rules (private SG):
        All traffic (0-65535) -- within the private SG
        MySQL (3306) -- from the public SG
        HTTPS (443) -- from the public SG
        HTTP (80) -- from the public SG
        NodePort range (30000-32767) -- from the public SG