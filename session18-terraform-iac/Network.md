# AWS VPC — Virtual Private Cloud

## 1. What is a VPC?

**Amazon VPC (Virtual Private Cloud)** is a logically isolated virtual network inside AWS.

It allows us to control how AWS resources communicate with:

* Each other
* The internet
* Other networks
* Other AWS services

For example, EC2 instances run inside a VPC.

```text
AWS
│
└── VPC
    │
    ├── Public Subnet
    │    └── EC2
    │
    └── Private Subnet
         └── Database
```

### Simple definition

> **VPC = Your private network inside AWS.**

---

# 2. Why Do We Need a VPC?

Suppose we deploy an application consisting of:

```text
Frontend
Backend
Database
```

We don't necessarily want the database directly accessible from the internet.

A VPC allows us to design the network:

```text
Internet
   ↓
Load Balancer
   ↓
Backend
   ↓
Database
```

The database can remain in a **private subnet**.

This gives us control over:

* IP addresses
* Routing
* Internet access
* Network security
* Subnet design
* Communication between resources

---

# 3. Main Components of a VPC

A VPC commonly contains:

```text
                    VPC
                     │
       ┌─────────────┼─────────────┐
       │             │             │
     Subnets     Route Tables   Security
                                  Groups
       │
   ┌───┴────┐
   │        │
 Public   Private
 Subnet   Subnet
   │        │
  EC2      RDS
```

Important components:

1. VPC
2. CIDR Block
3. Subnets
4. Availability Zones
5. Route Tables
6. Internet Gateway
7. NAT Gateway
8. Security Groups
9. Network ACLs
10. VPC Endpoints

---

# 4. CIDR Block

A VPC needs an IP address range.

This is specified using **CIDR notation**.

Example:

```text
10.0.0.0/16
```

This defines the IP address range available inside the VPC.

For example:

```text
VPC
10.0.0.0/16
```

We can divide this into smaller subnet ranges.

```text
VPC: 10.0.0.0/16

├── Public Subnet
│   10.0.1.0/24
│
└── Private Subnet
    10.0.2.0/24
```

### Common private IPv4 ranges

```text
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

These ranges are commonly used for private networks.

---

# 5. Subnet

A **subnet** is a smaller network range inside a VPC.

Example:

```text
VPC
10.0.0.0/16
│
├── Subnet 1
│   10.0.1.0/24
│
├── Subnet 2
│   10.0.2.0/24
│
└── Subnet 3
    10.0.3.0/24
```

Subnets allow us to organize resources.

There are two common types:

* Public subnet
* Private subnet

---

# 6. Public Subnet

A subnet is considered **public** when its route table provides a route to an **Internet Gateway**.

Example:

```text
Internet
   ↓
Internet Gateway
   ↓
Public Subnet
   ↓
EC2
```

A resource in a public subnet can be reachable from the internet if its network configuration and security rules allow it.

A public subnet does **not** automatically mean every resource inside it is publicly accessible.

---

# 7. Private Subnet

A private subnet does not have a direct route to the Internet Gateway for general internet access.

Example:

```text
VPC
│
├── Public Subnet
│      └── EC2
│
└── Private Subnet
       └── Database
```

Databases such as RDS are commonly placed in private subnets.

---

# 8. Public vs Private Subnet

| Feature                   | Public Subnet                      | Private Subnet               |
| ------------------------- | ---------------------------------- | ---------------------------- |
| Route to Internet Gateway | Yes                                | No direct route              |
| Direct internet access    | Possible with proper configuration | Not directly                 |
| Common resources          | Load Balancer, public EC2          | Databases, internal services |
| Security                  | Internet-facing                    | More isolated                |

### Important

A subnet itself is not "public" because of a checkbox.

Its routing configuration determines whether it is public.

---

# 9. Availability Zones

An AWS Region contains multiple **Availability Zones (AZs)**.

Example:

```text
Region: ap-south-1
│
├── AZ-1
├── AZ-2
└── AZ-3
```

We can create subnets in different Availability Zones.

Example:

```text
VPC
│
├── AZ-1
│    └── Public Subnet
│
└── AZ-2
     └── Public Subnet
```

Using multiple AZs can improve availability and fault tolerance.

---

# 10. Route Table

A **route table** determines where network traffic should go.

Example:

```text
Destination          Target
--------------------------------
10.0.0.0/16          local
0.0.0.0/0            Internet Gateway
```

Meaning:

```text
10.0.0.0/16
     ↓
Stay inside VPC

0.0.0.0/0
     ↓
Send to Internet Gateway
```

A subnet is associated with a route table.

---

# 11. Internet Gateway

An **Internet Gateway (IGW)** allows communication between a VPC and the internet.

Example:

```text
Internet
   ↕
Internet Gateway
   ↕
VPC
   ↕
Public Subnet
   ↕
EC2
```

The Internet Gateway is attached to the VPC.

A public subnet's route table can contain:

```text
0.0.0.0/0 → Internet Gateway
```

---

# 12. NAT Gateway

A **NAT Gateway** allows resources in a private subnet to initiate connections to the internet without allowing unsolicited inbound internet connections directly to those resources.

Example:

```text
Private EC2
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

A common architecture is:

```text
                    Internet
                       ↑
                       |
                Internet Gateway
                       |
              ┌────────┴────────┐
              │                 │
        Public Subnet      Private Subnet
              │                 │
         NAT Gateway ←──────────┘
              │
           Load Balancer
```

A private server can use the NAT Gateway to download updates or access external APIs.

---

# 13. Internet Gateway vs NAT Gateway

This is an important distinction.

| Internet Gateway                | NAT Gateway                                             |
| ------------------------------- | ------------------------------------------------------- |
| Connects VPC to internet        | Provides outbound internet access for private resources |
| Attached to VPC                 | Created in a subnet                                     |
| Used by public subnet routing   | Used by private subnet routing                          |
| Supports internet communication | Primarily enables outbound connections                  |

Simple memory trick:

```text
Public Subnet
     ↓
Internet Gateway

Private Subnet
     ↓
NAT Gateway
     ↓
Internet Gateway
```

---

# 14. Security Groups

A **Security Group** is a virtual firewall associated with resources such as EC2.

It controls:

* Inbound traffic
* Outbound traffic

Example:

```text
Internet
   ↓
Security Group
   ↓
EC2
```

Example rules:

```text
HTTP  → 80
HTTPS → 443
SSH   → 22
```

Security Groups are **stateful**.

This means if an allowed connection is established, the response traffic is automatically allowed.

---

# 15. Network ACL

A **Network ACL (NACL)** is another layer of network traffic control.

Unlike Security Groups, NACLs operate at the **subnet level**.

```text
VPC
│
└── Subnet
     │
     └── Network ACL
          │
          └── Resources
```

NACLs are **stateless**, meaning inbound and outbound traffic rules are evaluated independently.

---

# 16. Security Group vs NACL

| Feature        | Security Group          | NACL                       |
| -------------- | ----------------------- | -------------------------- |
| Level          | Resource/ENI            | Subnet                     |
| Stateful       | Yes                     | No                         |
| Rules          | Allow rules             | Allow + deny rules         |
| Return traffic | Automatically allowed   | Must be explicitly allowed |
| Common use     | Instance-level firewall | Subnet-level control       |

For most application security configurations, Security Groups are a major component.

---

# 17. VPC Endpoint

A **VPC Endpoint** allows resources inside a VPC to access supported AWS services without requiring traffic to go through the public internet.

For example:

```text
Private EC2
    ↓
VPC Endpoint
    ↓
S3
```

This can be useful for private architectures where resources should communicate with AWS services without public internet connectivity.

Two common categories are:

* Gateway endpoints
* Interface endpoints

---

# 18. Example VPC Architecture

A common production-style architecture looks like:

```text
                         Internet
                            |
                            ↓
                   Internet Gateway
                            |
                    Public Subnets
                    /            \
                   /              \
          Load Balancer       NAT Gateway
                                      |
                                      ↓
                              Private Subnets
                              /              \
                             /                \
                         EC2/API            EC2/API
                             |
                             ↓
                         RDS Database
```

The basic security idea is:

```text
Internet
   ↓
Public resources
   ↓
Private application layer
   ↓
Private database
```

---

# 19. Traffic Flow Example

Suppose an EC2 instance is in a public subnet.

A user wants to access a web application.

```text
User
 ↓
Internet
 ↓
Internet Gateway
 ↓
Route Table
 ↓
Public Subnet
 ↓
Security Group
 ↓
EC2
 ↓
Application
```

For a private EC2 instance accessing the internet:

```text
Private EC2
 ↓
Private Route Table
 ↓
NAT Gateway
 ↓
Public Subnet
 ↓
Internet Gateway
 ↓
Internet
```

---

# 20. VPC and EC2

EC2 instances are launched into a subnet inside a VPC.

Example:

```text
VPC
│
└── Subnet
      │
      └── EC2
```

When launching EC2, we can specify:

* VPC
* Subnet
* Security Group
* Private IP
* Public IP configuration

---

# 21. VPC and RDS

RDS databases are commonly placed in private subnets.

Example:

```text
VPC
│
├── Public Subnet
│    └── Application / Load Balancer
│
└── Private Subnets
     └── RDS
```

This prevents the database from being directly exposed to the public internet.

---

# 22. VPC Peering

**VPC Peering** allows two VPCs to communicate privately.

Example:

```text
VPC A
10.0.0.0/16
   |
   | VPC Peering
   |
VPC B
10.1.0.0/16
```

The VPCs must have non-overlapping IP ranges for straightforward routing.

---

# 23. VPC with Terraform

Terraform is commonly used to create VPC infrastructure.

A basic VPC configuration might include:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}
```

A subnet:

```hcl
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}
```

An Internet Gateway:

```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
```

---

# 24. Important Terraform VPC Resources

Common resources include:

```text
aws_vpc
aws_subnet
aws_route_table
aws_route_table_association
aws_internet_gateway
aws_nat_gateway
aws_eip
aws_security_group
aws_network_acl
aws_vpc_endpoint
```

These resources are often combined to build an entire AWS network.

---

# 25. Typical Terraform VPC Structure

A Terraform project might look like:

```text
terraform-vpc/
│
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

The infrastructure can be:

```text
Terraform
   |
   ↓
VPC
├── Public Subnet
│    ├── Route Table
│    └── Internet Gateway
│
└── Private Subnet
     ├── Route Table
     └── NAT Gateway
```

---

# 26. Common VPC Mistakes

### 1. Overlapping CIDR ranges

Avoid creating conflicting networks.

Example:

```text
VPC A: 10.0.0.0/16
VPC B: 10.0.0.0/16
```

This can create problems when trying to connect the networks.

### 2. Incorrect route table

An EC2 instance may have a public IP but still not have internet connectivity if routing is incorrect.

### 3. Confusing Security Groups and NACLs

Remember:

```text
Security Group → Resource level
NACL            → Subnet level
```

### 4. Assuming a subnet is public because it has a public IP

Public accessibility depends on the network configuration, especially routing.

### 5. Exposing databases

Databases should generally not be directly accessible from the public internet.

---

# 27. Public vs Private Architecture

### Less secure/simple design

```text
Internet
   ↓
EC2
   ↓
Database
```

### Common production design

```text
Internet
   ↓
Load Balancer
   ↓
Private Application Servers
   ↓
Private Database
```

The second design provides better network isolation.

---

# 28. Quick Revision

| Concept           | Meaning                                           |
| ----------------- | ------------------------------------------------- |
| VPC               | Virtual private network in AWS                    |
| CIDR              | Defines IP address range                          |
| Subnet            | Smaller network inside VPC                        |
| Public Subnet     | Has route toward Internet Gateway                 |
| Private Subnet    | No direct route to Internet Gateway               |
| Route Table       | Controls where traffic goes                       |
| Internet Gateway  | Connects VPC to internet                          |
| NAT Gateway       | Allows private resources outbound internet access |
| Security Group    | Stateful resource-level firewall                  |
| NACL              | Stateless subnet-level firewall                   |
| Availability Zone | Isolated location within a Region                 |
| VPC Endpoint      | Private access to supported AWS services          |
| VPC Peering       | Private connection between VPCs                   |

---

# 29. Key Things to Remember

```text
VPC = Network

CIDR = IP range
Subnet = Smaller network
Route Table = Where traffic goes
Internet Gateway = Internet connection
NAT Gateway = Private subnet → Internet
Security Group = Resource firewall
NACL = Subnet firewall
VPC Endpoint = Private access to AWS services
```

### Most important traffic patterns

```text
Public EC2:

EC2
 ↓
Route Table
 ↓
Internet Gateway
 ↓
Internet
```

```text
Private EC2:

EC2
 ↓
Private Route Table
 ↓
NAT Gateway
 ↓
Internet Gateway
 ↓
Internet
```

### One-line definition

> **Amazon VPC is a logically isolated virtual network in AWS that allows us to control IP addressing, subnets, routing, and network access for AWS resources.**
