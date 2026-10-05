# AWS Database Services — DynamoDB & RDS

AWS provides multiple database services for different types of applications.

Two important ones are:

* **Amazon DynamoDB** → NoSQL database
* **Amazon RDS** → Managed relational database

The most important difference is:

```text id="9qk2r1"
DynamoDB → NoSQL
RDS      → SQL / Relational
```

---

# Part 1 — Amazon DynamoDB

## 1. What is DynamoDB?

**Amazon DynamoDB** is a fully managed, serverless **NoSQL database** provided by AWS.

It is designed for applications that need:

* Fast performance
* High scalability
* Low-latency access
* Flexible data models
* Large-scale workloads

Applications can interact with DynamoDB without managing database servers.

```text id="x6m9gq"
Application
     ↓
DynamoDB
     ↓
Table
     ↓
Items
```

---

# 2. DynamoDB Data Model

DynamoDB organizes data using:

```text id="f3q8la"
Table
  ↓
Items
  ↓
Attributes
```

These are roughly comparable to:

```text id="2j8m1v"
DynamoDB              Relational DB

Table       →         Table
Item        →         Row
Attribute   →         Column
```

However, DynamoDB is a NoSQL database and does not require a traditional relational schema.

---

# 3. Table

A **table** is a collection of items.

Example:

```text id="g2p4dd"
Users
│
├── Item 1
├── Item 2
└── Item 3
```

Example table:

```text id="8s0c7y"
Users

userId       name       age
--------------------------------
101          Ananya     20
102          Rahul      21
103          Priya      22
```

---

# 4. Item

An **item** is an individual record in a DynamoDB table.

Example:

```json id="b8v5j2"
{
  "userId": "101",
  "name": "Ananya",
  "age": 20
}
```

Each item can have different attributes depending on the application's data model.

---

# 5. Attributes

Attributes are the individual pieces of data inside an item.

Example:

```text id="p7n3m2"
userId → 101
name   → Ananya
age    → 20
```

Unlike a traditional relational database, DynamoDB allows flexible attributes.

---

# 6. Primary Key

Every DynamoDB table needs a **primary key**.

There are two main types:

1. Partition key
2. Composite primary key

---

# 7. Partition Key

A partition key uniquely identifies an item when the table uses a simple primary key.

Example:

```text id="k3x8z2"
userId
```

If:

```text id="v5y0r4"
userId = 101
```

then DynamoDB can efficiently locate that item.

The partition key should generally have good distribution across values.

---

# 8. Composite Primary Key

A table can use:

```text id="x5z9b1"
Partition Key + Sort Key
```

Example:

```text id="7j3m8q"
Partition Key → userId
Sort Key      → orderId
```

Example data:

```text id="1q2w3e"
userId    orderId
---------------------
101       ORD001
101       ORD002
102       ORD003
```

This allows multiple items to share the same partition key while being uniquely identified by the combination of partition key and sort key.

---

# 9. Global Secondary Index — GSI

A **Global Secondary Index (GSI)** allows queries using a different key structure from the table's primary key.

Example:

```text id="n4x7p2"
Main Table
Partition Key → userId

GSI
Partition Key → email
```

This allows the application to efficiently query using `email`.

---

# 10. Local Secondary Index — LSI

A **Local Secondary Index (LSI)** uses the same partition key as the table but a different sort key.

Example:

```text id="y5c1k7"
Table:
Partition Key → userId
Sort Key      → orderId

LSI:
Partition Key → userId
Sort Key      → orderDate
```

LSIs must be defined when the table is created.

---

# 11. DynamoDB Capacity Modes

DynamoDB supports two main capacity modes.

### On-Demand

AWS automatically handles capacity based on traffic.

Useful when:

* Traffic is unpredictable
* You don't want to manage capacity manually
* Workloads vary significantly

### Provisioned

You specify read and write capacity.

Useful when:

* Traffic is predictable
* You want more control over capacity planning

---

# 12. DynamoDB Performance

DynamoDB is designed for very fast access when data is modeled around its access patterns.

A key concept is:

> **Design your table around how the application will query the data.**

Unlike SQL databases, you generally don't design DynamoDB around complex joins.

---

# 13. DynamoDB Consistency

DynamoDB supports different read consistency models.

### Eventually Consistent Reads

The result might briefly reflect an older version of the data.

### Strongly Consistent Reads

Returns the most recent data for supported operations.

Strong consistency can have different performance/cost characteristics, so the application should use it only when required.

---

# 14. DynamoDB Streams

**DynamoDB Streams** captures changes made to items in a DynamoDB table.

Example:

```text id="h2j9m4"
DynamoDB
   ↓
DynamoDB Stream
   ↓
Lambda
   ↓
Perform Action
```

For example, when a new item is added, a Lambda function could process the event.

---

# 15. DynamoDB TTL

**Time to Live (TTL)** allows DynamoDB to automatically remove expired items based on a designated attribute.

Example:

```text id="w8d4k1"
Session
   ↓
expiresAt = timestamp
   ↓
TTL
   ↓
Automatically removed
```

This is useful for:

* Temporary sessions
* Temporary tokens
* Expiring records
* Caches

---

# 16. DynamoDB Transactions

DynamoDB supports transactional operations that allow multiple related operations to succeed or fail together.

This is useful when data consistency across multiple items is important.

---

# 17. DynamoDB with Terraform

Terraform can create a DynamoDB table.

Example:

```hcl id="k5r8p2"
resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = {
    Name = "Users Table"
  }
}
```

Here:

```text id="m3z7c1"
hash_key = "userId"
```

defines the partition key.

---

# Part 2 — Amazon RDS

# 18. What is Amazon RDS?

**Amazon RDS (Relational Database Service)** is a managed service for running relational databases in AWS.

RDS supports database engines such as:

* PostgreSQL
* MySQL
* MariaDB
* Oracle
* Microsoft SQL Server
* Amazon Aurora

RDS handles many administrative tasks such as:

* Provisioning
* Backups
* Patching
* Monitoring
* Maintenance

---

# 19. What is a Relational Database?

A relational database stores structured data in tables.

Example:

```text id="e3v6m8"
Users

id    name       email
--------------------------
1     Ananya     a@x.com
2     Rahul      r@x.com
```

Tables can be related using keys.

For example:

```text id="q6r1v8"
Users
  |
  | user_id
  ↓
Orders
```

Relational databases use SQL to query and manipulate data.

---

# 20. RDS Database Instance

An RDS database instance provides the computing resources for the managed database.

Example:

```text id="t9v3k5"
RDS
 |
 ├── Database Engine
 ├── CPU
 ├── Memory
 ├── Storage
 └── Network
```

Unlike DynamoDB, RDS involves managing database-instance configuration such as instance class and storage.

---

# 21. RDS Database Engines

Common choices include:

```text id="h8j2n6"
PostgreSQL
MySQL
MariaDB
Oracle
SQL Server
Aurora
```

For example:

```text id="u4c9x1"
Application
     ↓
RDS PostgreSQL
```

---

# 22. RDS Storage

RDS uses managed storage for database data.

Storage configuration can involve:

* Storage type
* Allocated storage
* Storage scaling

The exact options depend on the selected engine and configuration.

---

# 23. RDS Backups

RDS provides automated backup capabilities.

Backups can help recover database data after accidental deletion or other failures.

RDS also supports **DB snapshots**.

```text id="d7q2m4"
RDS
 ↓
Snapshot
 ↓
Restore
```

A snapshot can be used to create a new database from the captured state.

---

# 24. Multi-AZ

**Multi-AZ** deployments improve availability.

A simplified architecture:

```text id="p4v8n2"
             Application
                  |
                  ↓
             RDS Primary
                  |
             Replication
                  |
                  ↓
           Standby in another AZ
```

If the primary database experiences certain failures, AWS can perform a failover to the standby.

### Important

Multi-AZ is primarily about **high availability**, not about increasing read capacity.

---

# 25. Read Replicas

A **Read Replica** is used to provide additional read capacity.

Example:

```text id="s2x7m9"
             Application
              /       \
             ↓         ↓
         Primary    Read Replica
         (Write)       (Read)
```

This can help applications with heavy read workloads.

### Remember

```text id="n7v1k4"
Multi-AZ
→ High availability

Read Replica
→ Read scaling
```

---

# 26. RDS Security

RDS can be protected using:

* VPC
* Private subnets
* Security Groups
* Encryption
* IAM-related mechanisms where supported
* Database authentication
* Network controls

A common architecture is:

```text id="c8m3w1"
Internet
   ↓
Application
   ↓
Private RDS
```

The database should generally not be directly exposed to the public internet.

---

# 27. RDS Subnet Group

An **RDS DB subnet group** defines the subnets where an RDS database can be placed.

For high availability, subnets are typically provided across multiple Availability Zones.

Example:

```text id="a6p2s8"
VPC
│
├── Private Subnet AZ-1
│
└── Private Subnet AZ-2
       ↓
   RDS Subnet Group
```

---

# 28. RDS Parameter Groups

A **DB parameter group** contains engine configuration parameters.

It allows certain database settings to be customized.

```text id="j4m9q3"
RDS
 ↓
Parameter Group
 ↓
Database Configuration
```

---

# 29. RDS with Terraform

Terraform can create an RDS database instance.

Simplified example:

```hcl id="v7c2k8"
resource "aws_db_instance" "database" {
  identifier        = "my-database"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = var.db_password

  skip_final_snapshot = true
}
```

For real production deployments, database credentials should be handled securely rather than hardcoded.

---

# 30. DynamoDB vs RDS

This is one of the most important comparisons.

| Feature           | DynamoDB                                       | RDS                                                  |
| ----------------- | ---------------------------------------------- | ---------------------------------------------------- |
| Type              | NoSQL                                          | Relational                                           |
| Data model        | Key-value/document                             | Tables/rows/columns                                  |
| Query language    | DynamoDB APIs/expressions                      | SQL                                                  |
| Schema            | Flexible                                       | Structured                                           |
| Joins             | No traditional joins                           | Yes                                                  |
| Server management | Highly managed/serverless                      | Managed database instances                           |
| Scaling           | Designed for large-scale distributed workloads | Instance/storage scaling options                     |
| Best suited for   | High-scale key-value/document workloads        | Relational applications                              |
| Examples          | Sessions, shopping carts, metadata             | Banking-style relational data, business applications |

---

# 31. When to Use DynamoDB?

DynamoDB is a good fit when:

* You need very fast key-based access.
* Your workload needs high scalability.
* Your application doesn't require traditional relational joins.
* You want a highly managed/serverless database.
* Your data naturally fits a key-value/document model.

Example:

```text id="v8j4m1"
User Session
      ↓
DynamoDB
```

---

# 32. When to Use RDS?

RDS is a good fit when:

* You need SQL.
* Your data is relational.
* You need joins.
* You need transactions and relational constraints.
* Your application already uses PostgreSQL/MySQL/etc.

Example:

```text id="r3x7k2"
Application
    ↓
PostgreSQL
    ↓
Users + Orders + Payments
```

---

# 33. Real-World Architecture

A common AWS application could look like:

```text id="y6m2p9"
                    Internet
                       |
                       ↓
                 Load Balancer
                       |
                       ↓
                 EC2 / Application
                    /       \
                   /         \
                  ↓           ↓
                S3          Database
                              |
                     ┌────────┴────────┐
                     ↓                 ↓
                  RDS              DynamoDB
```

Different data can be stored in different services depending on the application's requirements.

For example:

```text id="z4n8c2"
Images / Videos
      ↓
     S3

Relational business data
      ↓
     RDS

High-scale key-value data
      ↓
   DynamoDB
```

---

# 34. Terraform Resources

### DynamoDB

Common resource:

```text id="f2k5v7"
aws_dynamodb_table
```

### RDS

Common resources include:

```text id="q7n3m1"
aws_db_instance
aws_db_subnet_group
aws_db_parameter_group
aws_db_option_group
```

These can be combined with VPC and Security Group resources.

---

# 35. Database + VPC Relationship

RDS commonly works with VPC networking:

```text id="w5j9p2"
VPC
│
├── Public Subnets
│
└── Private Subnets
      │
      └── RDS
```

Security Group:

```text id="b3x8k4"
EC2 Security Group
        ↓
   Port 5432
        ↓
RDS PostgreSQL
```

For MySQL:

```text id="n6v1r9"
Port 3306
```

For PostgreSQL:

```text id="k8q3m5"
Port 5432
```

The database Security Group should allow connections only from the required application resources rather than from the entire internet.

---

# 36. Common Database Mistakes

### DynamoDB

* Choosing a poor partition key.
* Designing without considering access patterns.
* Using unnecessary indexes.
* Giving overly broad IAM permissions.

### RDS

* Making the database publicly accessible unnecessarily.
* Opening database ports to `0.0.0.0/0`.
* Not configuring backups appropriately.
* Storing passwords directly in source code.
* Confusing Multi-AZ with Read Replicas.
* Forgetting that RDS is a managed service but still requires configuration and cost management.

---

# 37. Important Security Practices

For both databases:

* Use encryption where appropriate.
* Use least-privilege IAM permissions.
* Keep databases private when possible.
* Restrict network access with Security Groups.
* Protect database credentials.
* Enable backups according to recovery requirements.
* Monitor database activity and performance.
* Avoid exposing database ports directly to the internet.

---

# 38. Quick Revision

### DynamoDB

```text id="e5w2m8"
DynamoDB
   ↓
NoSQL
   ↓
Table
   ↓
Items
   ↓
Attributes

Primary Key
├── Partition Key
└── Sort Key (optional)

GSI
LSI
Streams
TTL
On-Demand
Provisioned
```

### RDS

```text id="u3n7p1"
RDS
 ↓
Relational Database
 ↓
PostgreSQL / MySQL / etc.
 ↓
Database Instance
 ↓
Storage + Backups
 ↓
Multi-AZ / Read Replicas
```

---

# 39. Most Important Difference

Remember this:

```text id="c7m2x9"
                    DATABASE
                       |
              ┌────────┴────────┐
              ↓                 ↓
          DynamoDB              RDS
              |                 |
            NoSQL              SQL
              |                 |
       Key-Value/Document    Relational
              |                 |
      High-scale access     Structured data
```

### One-line definitions

> **DynamoDB is a fully managed NoSQL database designed for fast, scalable key-value and document workloads.**

> **Amazon RDS is a managed relational database service that makes it easier to set up, operate, and scale supported SQL database engines in AWS.**
