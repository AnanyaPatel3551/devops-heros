# AWS S3 — Simple Storage Service

## 1. What is Amazon S3?

**Amazon S3 (Simple Storage Service)** is an AWS service used to **store and retrieve data as objects**.

Unlike EC2, which provides computing power, S3 is primarily used for **storage**.

Examples of things we can store in S3:

* Images
* Videos
* PDFs
* Documents
* Logs
* Backups
* Application files
* Static website files
* Data used for analytics

### Simple idea

```text
EC2 = Compute
S3  = Storage
```

Instead of storing files on a server's local disk, applications can store them in S3.

---

# 2. How S3 Works

S3 uses **object storage**.

The basic structure is:

```text
S3
 |
 └── Bucket
      |
      ├── Object
      ├── Object
      ├── Object
      └── Object
```

For example:

```text
my-photos-bucket/
│
├── profile.jpg
├── vacation.jpg
└── documents/
      └── resume.pdf
```

---

# 3. Bucket

A **bucket** is a container used to store objects.

Example:

```text
Bucket: ananya-project-files
```

Inside the bucket:

```text
ananya-project-files
│
├── image.png
├── resume.pdf
└── data/
     └── users.csv
```

### Important

S3 bucket names must be **globally unique** across AWS.

For example:

```text
my-bucket
```

may already be taken.

You may need something more unique:

```text
ananya-terraform-demo-2026
```

---

# 4. Object

An **object** is the actual piece of data stored in S3.

An object consists of:

* Data
* Key
* Metadata

Example:

```text
Bucket
  |
  └── profile.jpg
```

Here:

```text
profile.jpg = Object Key
```

The object contains the actual image data.

---

# 5. Object Key

An S3 object key identifies an object inside a bucket.

Example:

```text
images/profile.jpg
```

S3 does not actually use traditional folders like a normal file system.

Instead, the `/` is part of the object's key.

For example:

```text
images/profile.jpg
```

is one object key.

The console displays it as if it were:

```text
images/
   └── profile.jpg
```

---

# 6. S3 Bucket Region

When creating a bucket, we normally select an AWS Region.

Example:

```text
Bucket
   ↓
ap-south-1
   ↓
Mumbai Region
```

Choosing an appropriate region can help with:

* Latency
* Compliance
* Cost
* Integration with other resources

For example, if most of your application infrastructure is in `ap-south-1`, keeping related resources in the same region can simplify architecture and reduce unnecessary data transfer.

---

# 7. S3 Storage Classes

S3 provides different **storage classes** depending on how frequently data is accessed.

Common classes include:

| Storage Class                 | Typical Use                                         |
| ----------------------------- | --------------------------------------------------- |
| S3 Standard                   | Frequently accessed data                            |
| S3 Intelligent-Tiering        | Unknown/changing access patterns                    |
| S3 Standard-IA                | Infrequently accessed data                          |
| S3 One Zone-IA                | Infrequent data that can tolerate single-AZ storage |
| S3 Glacier Instant Retrieval  | Archive data needing fast retrieval                 |
| S3 Glacier Flexible Retrieval | Long-term archive                                   |
| S3 Glacier Deep Archive       | Very rarely accessed archives                       |

### Simple idea

```text
Frequently used
      ↓
S3 Standard

Less frequently used
      ↓
IA

Long-term archive
      ↓
Glacier
```

Storage class affects cost and retrieval characteristics.

---

# 8. S3 Versioning

**Versioning** allows S3 to keep multiple versions of an object.

Suppose:

```text
resume.pdf
```

is uploaded.

Then it is updated twice:

```text
Version 1
Version 2
Version 3
```

S3 can retain these versions.

This helps protect against:

* Accidental deletion
* Accidental overwrites
* Application mistakes

Example:

```text
resume.pdf
   |
   ├── Version 1
   ├── Version 2
   └── Version 3
```

Versioning is especially useful for important data.

---

# 9. S3 Encryption

S3 supports encryption to protect stored data.

There are two broad concepts:

### Encryption at rest

Data is encrypted while stored in S3.

### Encryption in transit

Data can be protected while moving using HTTPS/TLS.

Common S3 server-side encryption options include:

* SSE-S3
* SSE-KMS
* SSE-C

For many applications, **SSE-S3** is sufficient for basic server-side encryption.

For workloads requiring centralized key management and more control, **SSE-KMS** can be used.

---

# 10. Bucket Policies

A **bucket policy** is a resource-based policy attached to an S3 bucket.

It controls who can perform actions on the bucket or its objects.

For example:

```text
User/Application
       |
       ↓
Bucket Policy
       |
       ↓
S3 Bucket
```

A policy can control actions such as:

```text
s3:GetObject
s3:PutObject
s3:DeleteObject
```

---

# 11. IAM Policy vs S3 Bucket Policy

This distinction is important.

### IAM Policy

Attached to:

* IAM user
* IAM group
* IAM role

Example:

```text
IAM Role
   ↓
IAM Policy
   ↓
Allow s3:GetObject
```

### Bucket Policy

Attached directly to the S3 bucket.

```text
S3 Bucket
   ↓
Bucket Policy
```

Both can affect whether an operation is allowed.

---

# 12. S3 Block Public Access

S3 provides **Block Public Access** settings to help prevent accidental public exposure of buckets and objects.

For private application data, this should generally remain enabled unless there is a specific reason to allow public access.

Example:

```text
Internet
   X
   |
S3 Bucket
   |
Private Data
```

Do not make an S3 bucket public simply because an application needs to access it.

Applications can often use IAM permissions or **presigned URLs** instead.

---

# 13. Presigned URLs

A **presigned URL** provides temporary access to an S3 object without making the bucket publicly accessible.

Example:

```text
Private S3 Object
       ↓
Presigned URL
       ↓
User
```

A URL can be generated with an expiration time.

For example:

```text
Valid for 10 minutes
```

After expiration, the URL no longer provides access.

This is useful for:

* Private downloads
* Temporary file uploads
* Sharing files securely

---

# 14. S3 Lifecycle Rules

Lifecycle rules automatically manage objects as they become older.

For example:

```text
Day 0
 ↓
S3 Standard

Day 30
 ↓
S3 Standard-IA

Day 90
 ↓
S3 Glacier

Day 365
 ↓
Delete
```

This can help reduce storage costs and automate data retention.

Lifecycle rules can be configured based on:

* Object age
* Object prefixes/tags
* Storage transitions
* Expiration

---

# 15. S3 Object Lock

**S3 Object Lock** can help prevent objects from being deleted or overwritten for a specified retention period.

It is useful for requirements involving:

* Compliance
* Records retention
* Data protection

Object Lock supports retention mechanisms such as:

* Governance mode
* Compliance mode
* Legal holds

---

# 16. S3 Replication

S3 supports replication of objects between buckets.

For example:

```text
Bucket A
Mumbai
   |
   | Replication
   ↓
Bucket B
Another Region
```

This can be useful for:

* Disaster recovery
* Compliance
* Geographic redundancy

Two common concepts are:

* Same-Region Replication (SRR)
* Cross-Region Replication (CRR)

---

# 17. Static Website Hosting

S3 can host static websites containing files such as:

```text
index.html
style.css
script.js
```

Example:

```text
User
 ↓
S3
 ↓
index.html
 ↓
Website
```

This is suitable for static websites.

For example:

```text
HTML
CSS
JavaScript
Images
```

For modern production architectures, S3 is often combined with services such as CloudFront for content delivery.

---

# 18. S3 and EC2

EC2 and S3 are commonly used together.

Example:

```text
              Application
                  |
                 EC2
                  |
             IAM Role
                  |
                  ↓
                 S3
                  |
        +---------+---------+
        |         |         |
      Images    Backups    Files
```

An EC2 application can upload files to S3 using AWS APIs.

An IAM role can provide the required permissions without hardcoding AWS access keys.

---

# 19. S3 and IAM

IAM determines **who can access S3 and what they can do**.

Example:

```text
IAM Role
   |
   ↓
Policy
   |
   ↓
Allow:
s3:GetObject
   |
   ↓
S3 Bucket
```

Following the **principle of least privilege**, an application should receive only the permissions it actually needs.

For example, if an application only needs to download objects, it may only need:

```text
s3:GetObject
```

instead of:

```text
s3:*
```

---

# 20. AWS CLI — Basic S3 Commands

List buckets:

```bash
aws s3 ls
```

Create a bucket:

```bash
aws s3 mb s3://my-unique-bucket-name
```

List objects:

```bash
aws s3 ls s3://my-unique-bucket-name
```

Upload a file:

```bash
aws s3 cp file.txt s3://my-unique-bucket-name/
```

Download a file:

```bash
aws s3 cp s3://my-unique-bucket-name/file.txt .
```

Copy a directory:

```bash
aws s3 cp ./data s3://my-unique-bucket-name/data/ --recursive
```

Delete an object:

```bash
aws s3 rm s3://my-unique-bucket-name/file.txt
```

Delete a bucket:

```bash
aws s3 rb s3://my-unique-bucket-name
```

A bucket must generally be empty before it can be deleted.

---

# 21. S3 with Terraform

Terraform can create and manage S3 buckets.

Basic example:

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "ananya-terraform-demo-2026"

  tags = {
    Name = "Terraform Demo"
  }
}
```

Terraform workflow:

```text
Terraform Code
      ↓
terraform init
      ↓
terraform plan
      ↓
terraform apply
      ↓
S3 Bucket
```

---

# 22. S3 Versioning with Terraform

Example:

```hcl
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

Here Terraform enables versioning on the bucket.

---

# 23. S3 Encryption with Terraform

Example:

```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

This enables server-side encryption using S3-managed keys.

---

# 24. Important Terraform S3 Resources

Common Terraform resources include:

```text
aws_s3_bucket
aws_s3_bucket_versioning
aws_s3_bucket_server_side_encryption_configuration
aws_s3_bucket_lifecycle_configuration
aws_s3_bucket_policy
aws_s3_bucket_public_access_block
```

These allow us to manage different aspects of an S3 bucket through Infrastructure as Code.

---

# 25. Common S3 Mistakes

### 1. Making buckets public unnecessarily

Avoid exposing private data to the internet.

### 2. Forgetting encryption

Sensitive data should be appropriately protected.

### 3. No lifecycle policy

Old data can accumulate and increase storage costs.

### 4. Not enabling versioning for important data

Versioning can help recover from accidental overwrites/deletions.

### 5. Confusing bucket and object

```text
Bucket = Container
Object = Actual stored data
```

### 6. Assuming S3 is a normal filesystem

S3 is **object storage**, not a traditional block filesystem.

---

# 26. S3 vs EBS

This is important because both are storage services but work differently.

| Feature         | S3                                     | EBS                 |
| --------------- | -------------------------------------- | ------------------- |
| Type            | Object storage                         | Block storage       |
| Attached to EC2 | No                                     | Yes                 |
| Typical use     | Files, backups, media                  | OS/application disk |
| Access          | API/HTTP                               | Mounted as a disk   |
| Scaling         | Designed for very large object storage | Volume-based        |
| Example         | Images, PDFs, backups                  | EC2 root disk       |

Simple rule:

```text
Need to store files/objects?
        ↓
       S3

Need a disk for EC2?
        ↓
       EBS
```

---

# 27. S3 in a Real Application

Consider a website where users upload profile pictures.

Instead of storing images directly on the EC2 disk:

```text
User
 ↓
Application
 ↓
EC2
 ↓
S3
 ↓
profile.jpg
```

The database might store:

```text
user_id
name
profile_image_key
```

while the actual image is stored in S3.

This separates **application data** from **file storage**.

---

# 28. S3 Security Best Practices

* Keep buckets private by default.
* Use Block Public Access unless public access is required.
* Use IAM roles instead of hardcoded AWS credentials.
* Follow least privilege.
* Enable encryption.
* Enable versioning for important data.
* Use lifecycle rules where appropriate.
* Monitor access using AWS logging/auditing services.
* Avoid putting sensitive information directly into object names or metadata.
* Regularly review bucket policies and permissions.

---

# 29. Quick Revision

| Concept             | Meaning                                   |
| ------------------- | ----------------------------------------- |
| S3                  | AWS object storage service                |
| Bucket              | Container for objects                     |
| Object              | Actual stored data                        |
| Object Key          | Identifier/path-like name of an object    |
| Versioning          | Keeps multiple versions of objects        |
| Storage Class       | Determines storage/access characteristics |
| Lifecycle           | Automatically transitions/deletes objects |
| Bucket Policy       | Policy attached to an S3 bucket           |
| Block Public Access | Helps prevent public exposure             |
| Presigned URL       | Temporary access to an object             |
| Encryption          | Protects stored data                      |
| Replication         | Copies objects to another bucket          |
| Terraform           | Manages S3 using Infrastructure as Code   |

---

# 30. Key Things to Remember

```text
S3 = Object Storage

Bucket = Container
Object = Data
Key = Object identifier

Versioning = Keep object versions
Lifecycle = Automate storage transitions/deletion
Encryption = Protect stored data
Bucket Policy = Control bucket access
Presigned URL = Temporary object access
Block Public Access = Prevent accidental public exposure

Terraform:
aws_s3_bucket
aws_s3_bucket_versioning
aws_s3_bucket_policy
aws_s3_bucket_lifecycle_configuration
```

### One-line definition

> **Amazon S3 is a highly scalable object storage service used to store and retrieve files and other data as objects inside buckets.**
