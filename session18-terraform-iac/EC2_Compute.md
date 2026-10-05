# AWS EC2 — Elastic Compute Cloud

## 1. What is Amazon EC2?

**Amazon EC2 (Elastic Compute Cloud)** is an AWS service that provides **virtual servers in the cloud**.

Instead of buying and maintaining a physical server, we can create an EC2 instance on AWS and use it to run:

* Websites
* Backend applications
* APIs
* Databases (when appropriate)
* Docker containers
* Development environments
* Batch processing and other workloads

### Simple idea

```text
Traditional:
Your Computer/Physical Server
        ↓
    Application

AWS:
EC2 Instance
        ↓
    Application
```

An **EC2 instance is essentially a virtual machine running inside AWS**.

---

# 2. Why do we use EC2?

Without cloud computing, if we wanted a server, we would need to:

1. Purchase hardware
2. Install an operating system
3. Configure networking
4. Maintain the machine
5. Handle hardware failures
6. Scale the server when traffic increases

With EC2, AWS manages the underlying physical infrastructure and we can create and configure virtual servers whenever needed.

### Main advantages

* **On-demand:** Create servers whenever required.
* **Scalable:** Increase or decrease computing resources.
* **Flexible:** Choose different CPU, memory, storage and networking configurations.
* **Pay-as-you-go:** Generally pay for the resources used.
* **Customizable:** Choose the operating system and software.
* **Integrates with other AWS services:** VPC, S3, IAM, CloudWatch, Load Balancers, Auto Scaling, etc.

---

# 3. What is an EC2 Instance?

An **EC2 instance** is a virtual server created using AWS.

For example:

```text
EC2 Instance
├── Operating System
├── CPU
├── RAM
├── Storage
├── Network Interface
└── Application
```

You can install software on the instance just like you would on a normal computer.

For example:

```text
EC2
 ↓
Ubuntu
 ↓
Java
 ↓
Spring Boot Application
```

---

# 4. Important EC2 Concepts

When creating an EC2 instance, several components are involved.

```text
                    EC2
                     |
        +------------+------------+
        |            |            |
       AMI      Instance Type    EBS
        |            |            |
       OS       CPU + RAM       Storage
                     |
              Security Group
                     |
                   VPC
```

The most important concepts are:

1. AMI
2. Instance Type
3. Key Pair
4. EBS
5. Security Group
6. IP Address
7. VPC
8. User Data

---

# 5. AMI — Amazon Machine Image

An **AMI (Amazon Machine Image)** is a template used to create an EC2 instance.

It contains information such as:

* Operating system
* Software configuration
* Root volume configuration

Examples:

* Ubuntu
* Amazon Linux
* Windows Server
* Red Hat Enterprise Linux

### Example

If we select:

```text
Ubuntu AMI
      ↓
Create EC2
      ↓
Ubuntu EC2 Instance
```

Think of an AMI as a **blueprint/template for an EC2 machine**.

---

# 6. Instance Types

An EC2 instance type determines the computing resources available to the instance.

It mainly determines:

* CPU
* Memory
* Network performance
* Sometimes additional capabilities

AWS provides different instance families for different workloads.

Examples:

| Family    | General Purpose             |
| --------- | --------------------------- |
| `t3`      | General-purpose, burstable  |
| `t4g`     | General-purpose, ARM-based  |
| `m`       | General-purpose             |
| `c`       | Compute optimized           |
| `r`       | Memory optimized            |
| `g` / `p` | Accelerated computing / GPU |

Example:

```text
t3.micro
```

is a relatively small instance suitable for learning, development and lightweight workloads.

### Choosing an instance

```text
CPU-heavy application
        ↓
Compute optimized

Memory-heavy application
        ↓
Memory optimized

General application
        ↓
General purpose
```

---

# 7. Key Pair

A **key pair** is used to securely connect to an EC2 instance.

For Linux EC2 instances, SSH is commonly used.

```text
Your Computer
     |
     | SSH
     ↓
EC2 Instance
```

A key pair consists of:

* Public key → stored by AWS/associated with the instance
* Private key → kept by you

Example:

```bash
ssh -i my-key.pem ubuntu@<public-ip>
```

### Important

Never share your private key.

```text
Private Key = SECRET
```

---

# 8. EBS — Elastic Block Store

**Amazon EBS** provides persistent block storage for EC2 instances.

You can think of an EBS volume as a **virtual hard disk** attached to an EC2 instance.

```text
EC2 Instance
      |
      ↓
EBS Volume
      |
      ↓
Application/Data
```

EBS data can persist even when an instance is stopped.

Common EBS volume types include:

* `gp3` — general-purpose SSD
* `io2` — high-performance SSD
* `st1` — throughput optimized HDD
* `sc1` — cold HDD

For most general workloads, `gp3` is a common choice.

---

# 9. Security Groups

A **Security Group** acts as a virtual firewall for an EC2 instance.

It controls network traffic using rules.

For example:

```text
Internet
   |
   | TCP 22
   ↓
Security Group
   |
   ↓
EC2
```

A security group can control:

* Inbound traffic
* Outbound traffic

### Example rules

| Type       | Port | Purpose             |
| ---------- | ---: | ------------------- |
| SSH        |   22 | Linux remote access |
| HTTP       |   80 | Web traffic         |
| HTTPS      |  443 | Secure web traffic  |
| Custom TCP | 8080 | Application         |

Example:

```text
Inbound:
22  → Your IP
80  → 0.0.0.0/0
443 → 0.0.0.0/0
```

### Important

Avoid unnecessarily exposing sensitive ports to:

```text
0.0.0.0/0
```

because this means traffic from anywhere on the internet can potentially reach that port.

---

# 10. Public and Private IP Addresses

An EC2 instance can have different types of IP addresses.

### Private IP

Used for communication inside the VPC.

```text
EC2 A
10.0.1.10
   ↓
EC2 B
10.0.2.10
```

### Public IP

Used when the instance needs to communicate with the public internet.

Example:

```text
Internet
   ↓
Public IP
   ↓
EC2
```

Public IP addresses can change when an instance is stopped and started.

For a persistent public IPv4 address, AWS provides **Elastic IP**.

---

# 11. Elastic IP

An **Elastic IP (EIP)** is a static public IPv4 address that can be associated with an AWS resource such as an EC2 instance.

Example:

```text
Elastic IP
     ↓
EC2 Instance
```

This is useful when an application needs a stable public IPv4 address.

However, Elastic IPs should not be used unnecessarily.

---

# 12. VPC and EC2

Every EC2 instance runs inside a **VPC (Virtual Private Cloud)**.

A VPC is AWS's virtual networking environment.

```text
AWS
 |
 └── VPC
      |
      ├── Public Subnet
      |      |
      |      └── EC2
      |
      └── Private Subnet
             |
             └── EC2
```

EC2 depends on networking components such as:

* VPC
* Subnet
* Route Table
* Internet Gateway
* Security Group

We will study VPC separately.

---

# 13. User Data

**User Data** allows us to run commands automatically when an EC2 instance starts for the first time.

For example, we can automatically install Nginx:

```bash
#!/bin/bash

apt update
apt install -y nginx
systemctl start nginx
```

Instead of manually connecting to the server and installing software, the initialization can happen automatically.

This is especially useful for automation.

---

# 14. EC2 Instance Lifecycle

An EC2 instance has different states.

```text
Pending
   ↓
Running
   ↓
Stopping → Stopped
   ↓
Starting
   ↓
Running

Running
   ↓
Terminating
   ↓
Terminated
```

### Stop vs Terminate

**Stop**

* Instance is shut down.
* Can usually be started again.
* EBS volumes can remain.
* Some costs continue depending on resources attached.

**Terminate**

* Instance is permanently deleted.
* Root EBS volume is commonly deleted by default depending on configuration.
* Cannot normally be restarted.

### Remember

```text
STOP      → temporarily shut down

TERMINATE → delete the instance
```

---

# 15. EC2 Example Architecture

A simple web application can look like:

```text
                 Internet
                    |
                    ↓
             Internet Gateway
                    |
                    ↓
              Public Subnet
                    |
                    ↓
             Security Group
                    |
                    ↓
              EC2 Instance
                    |
              +-----+-----+
              |           |
            EBS       Application
                         |
                    Backend/API
```

In a production architecture, a load balancer and multiple EC2 instances may be used.

---

# 16. Connecting to a Linux EC2 Instance

After creating a Linux EC2 instance, we can connect using SSH.

Example:

```bash
ssh -i my-key.pem ubuntu@<PUBLIC-IP>
```

The Security Group must allow inbound SSH traffic on port `22`.

For example:

```text
Your computer
      |
      | SSH : 22
      ↓
Security Group
      |
      ↓
EC2
```

---

# 17. AWS CLI — Basic EC2 Commands

List EC2 instances:

```bash
aws ec2 describe-instances
```

Start an instance:

```bash
aws ec2 start-instances --instance-ids <instance-id>
```

Stop an instance:

```bash
aws ec2 stop-instances --instance-ids <instance-id>
```

Terminate an instance:

```bash
aws ec2 terminate-instances --instance-ids <instance-id>
```

List available AMIs:

```bash
aws ec2 describe-images
```

---

# 18. EC2 and IAM

IAM controls **who can access AWS resources**.

An EC2 instance can also have an **IAM Role** attached to it.

For example:

```text
EC2
 |
 | IAM Role
 ↓
Permission
 |
 ↓
S3
```

This allows the application running inside EC2 to access S3 without storing AWS access keys directly inside the application.

This is a recommended approach.

---

# 19. EC2 and S3

EC2 can communicate with S3.

Example:

```text
User
 ↓
EC2
 ↓
S3
 ↓
Files / Images / Backups
```

For example, a web application running on EC2 can store uploaded images in S3.

---

# 20. EC2 and Auto Scaling

If application traffic increases, one EC2 instance may not be enough.

We can use **Auto Scaling** to automatically add or remove instances based on demand.

```text
Low Traffic
    ↓
2 EC2 Instances

High Traffic
    ↓
5 EC2 Instances
```

This improves scalability and availability.

---

# 21. EC2 Pricing — Basic Idea

EC2 pricing depends on factors such as:

* Instance type
* Region
* Operating system
* Usage duration
* Purchasing model
* Storage
* Data transfer

Common purchasing options include:

### On-Demand

Pay for usage without a long-term commitment.

### Reserved Instances / Savings Plans

Commitment-based options that can reduce costs for predictable workloads.

### Spot Instances

Use spare AWS capacity at potentially lower prices, but instances can be interrupted.

For learning, **On-Demand** is usually the easiest model to understand.

---

# 22. EC2 with Terraform

Terraform allows us to create and manage EC2 infrastructure using code.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "my-web-server"
  }
}
```

Terraform then manages the infrastructure instead of us manually creating it through the AWS Console.

Basic workflow:

```text
Terraform Configuration
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS EC2 Instance
```

To remove it:

```bash
terraform destroy
```

---

# 23. Important Terraform EC2 Resources

Some commonly used Terraform resources are:

```text
aws_instance
aws_security_group
aws_key_pair
aws_ebs_volume
aws_eip
```

These resources can be combined to build an EC2 environment.

Example:

```text
Terraform
   |
   +── aws_vpc
   |
   +── aws_subnet
   |
   +── aws_security_group
   |
   +── aws_instance
   |
   └── aws_eip
```

---

# 24. Common Mistakes

### 1. Opening SSH to everyone

Avoid:

```text
Port 22 → 0.0.0.0/0
```

when you can restrict access to your IP.

### 2. Forgetting the Security Group

Even if the EC2 instance is running, you may not be able to connect if the required port isn't allowed.

### 3. Confusing Stop and Terminate

```text
Stop      ≠ Delete
Terminate = Delete
```

### 4. Losing the private key

Without the required credentials, connecting to an instance can become difficult.

### 5. Forgetting running resources

EC2 and related resources can incur charges. Delete resources that are no longer needed.

---

# 25. EC2 in One Picture

```text
                         AWS
                          |
                         VPC
                          |
                     Subnet
                          |
                   Security Group
                          |
                    EC2 Instance
                   /      |      \
                  /       |       \
                AMI      EBS      IP
                 |         |
                OS       Storage
                          |
                    Application
```

---

# 26. Quick Revision

| Concept        | Meaning                                         |
| -------------- | ----------------------------------------------- |
| EC2            | Virtual server in AWS                           |
| AMI            | Template used to create an instance             |
| Instance Type  | Defines CPU, memory, networking, etc.           |
| EBS            | Persistent block storage                        |
| Security Group | Virtual firewall                                |
| Key Pair       | Used for secure instance access                 |
| Public IP      | Internet-reachable IPv4 address                 |
| Private IP     | Internal VPC address                            |
| Elastic IP     | Static public IPv4 address                      |
| User Data      | Startup commands/scripts                        |
| VPC            | Virtual network containing the EC2              |
| IAM Role       | Gives AWS permissions to applications/instances |

---

# 27. Key Things to Remember

```text
EC2 = Compute
AMI = Machine blueprint
Instance Type = CPU + Memory + capabilities
EBS = Disk/Storage
Security Group = Firewall
Key Pair = Secure login
VPC = Network
User Data = Startup script
IAM Role = Permissions
Terraform = Infrastructure as Code
```

### One-line definition

> **Amazon EC2 is an AWS compute service that provides resizable virtual servers in the cloud, allowing us to run applications without managing physical hardware.**
