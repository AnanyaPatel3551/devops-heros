# AWS IAM — Identity and Access Management

## 1. What is IAM?

**AWS IAM (Identity and Access Management)** is an AWS service used to control:

* **Who** can access AWS
* **What** they can access
* **What actions** they can perform

In simple terms:

> **IAM controls authentication and authorization in AWS.**

```text id="m3w9vq"
Who are you?
      ↓
Authentication
      ↓
What can you do?
      ↓
Authorization
```

---

# 2. Why Do We Need IAM?

Suppose a company has:

```text
Developer
DevOps Engineer
Administrator
Application
```

They should not all have unlimited access to AWS.

For example:

```text id="y4y2dd"
Developer
   ↓
Can access EC2

Application
   ↓
Can read S3

Administrator
   ↓
Can manage many AWS resources
```

IAM allows us to give each identity only the permissions it needs.

This follows the principle of:

> **Least Privilege — give only the permissions required to perform the task.**

---

# 3. Authentication vs Authorization

These two concepts are extremely important.

### Authentication

Determines **who you are**.

Example:

```text id="9k5j1a"
Username + Password
        ↓
     IAM User
```

### Authorization

Determines **what you are allowed to do**.

Example:

```text id="6q2m2z"
IAM User
   ↓
IAM Policy
   ↓
Allow EC2 actions
```

### Simple memory trick

```text id="5k0d1j"
Authentication = Who are you?

Authorization = What can you do?
```

---

# 4. IAM Components

The main IAM components are:

```text id="3ljyis"
IAM
│
├── Users
├── Groups
├── Roles
├── Policies
└── Permissions
```

These work together to control access.

---

# 5. IAM User

An **IAM User** represents an identity that can interact with AWS.

A user can have:

* Console access
* Access keys for programmatic access
* Permissions through policies

Example:

```text id="f0zj52"
IAM User: Ananya
       ↓
    Policies
       ↓
AWS Resources
```

However, AWS generally recommends using **federated identities or IAM Identity Center** for human workforce access where appropriate rather than creating many long-lived IAM users.

---

# 6. IAM Groups

An **IAM Group** is a collection of IAM users.

Example:

```text id="cx7l6a"
Developers Group
│
├── Ananya
├── Rahul
└── Priya
```

A policy can be attached to the group:

```text id="mby6gk"
Developers Group
       ↓
Policy
       ↓
EC2 Access
```

All users in the group can inherit the group's permissions.

This makes permission management easier.

---

# 7. IAM Roles

An **IAM Role** is an identity that provides permissions but is designed to be **assumed** rather than permanently tied to one person.

Roles are extremely important in AWS.

They are commonly used by:

* EC2
* Lambda
* ECS
* Other AWS services
* Applications
* Federated users

Example:

```text id="2h1y2c"
EC2
 ↓
IAM Role
 ↓
Permissions
 ↓
S3
```

The application running on EC2 can use the role's temporary credentials.

---

# 8. IAM Role vs IAM User

| IAM User                                | IAM Role                                   |
| --------------------------------------- | ------------------------------------------ |
| Represents an identity                  | Represents assumable permissions           |
| Can have long-lived credentials         | Uses temporary credentials when assumed    |
| Often used for specific identities      | Commonly used by AWS services/applications |
| Can have access keys                    | Typically provides temporary credentials   |
| Password may be used for console access | No permanent password                      |

### Important

For applications running on AWS, prefer **IAM Roles** over storing long-lived access keys in application code.

---

# 9. IAM Policies

An **IAM Policy** is a document that defines permissions.

It specifies things such as:

* Effect
* Action
* Resource
* Conditions

Example:

```json id="q2j6hb"
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::my-bucket/*"
}
```

This means the identity can read objects from the specified S3 bucket.

---

# 10. Effect

A policy can generally contain:

```text id="7c1h8h"
Allow
Deny
```

Example:

```json id="w5z7n5"
{
  "Effect": "Allow"
}
```

A `Deny` explicitly blocks an action.

### Important rule

An **explicit Deny overrides an Allow**.

For example:

```text id="akm3a7"
Allow s3:GetObject
        +
Deny s3:GetObject
        ↓
      DENIED
```

---

# 11. Actions

The `Action` specifies what operation is being allowed or denied.

Examples:

```text id="3b9d8x"
ec2:StartInstances
ec2:StopInstances
s3:GetObject
s3:PutObject
s3:DeleteObject
```

The general format is:

```text id="avj4a6"
service:operation
```

For example:

```text id="d0s7n6"
s3:GetObject
```

means the `GetObject` operation in the S3 service.

---

# 12. Resources

The `Resource` specifies which AWS resource the permission applies to.

Example:

```json id="h4d2fz"
"Resource": "arn:aws:s3:::my-bucket/*"
```

This refers to objects inside the bucket.

Instead of giving access to everything:

```text id="m0kzrq"
*
```

we should restrict access to the required resource whenever possible.

---

# 13. Conditions

Policies can contain conditions that make permissions more specific.

For example, access can be restricted based on:

* IP address
* AWS Region
* Request conditions
* Tags
* MFA-related conditions

Example concept:

```text id="13n6dr"
Allow S3 access
      ↓
Only when condition is satisfied
```

Conditions are useful for implementing more precise security controls.

---

# 14. ARN — Amazon Resource Name

An **ARN** uniquely identifies an AWS resource.

Example:

```text id="4t4x1s"
arn:aws:s3:::my-bucket
```

General structure:

```text id="8w7b5q"
arn:partition:service:region:account-id:resource
```

For example:

```text id="9u7p0w"
arn:aws:ec2:ap-south-1:123456789012:instance/i-123456
```

The exact ARN format depends on the AWS service.

---

# 15. Identity-Based Policies

Identity-based policies are attached to:

* Users
* Groups
* Roles

Example:

```text id="9g0b4k"
IAM User
   ↓
Policy
   ↓
S3 permissions
```

The policy describes what that identity can do.

---

# 16. Resource-Based Policies

A resource-based policy is attached directly to a resource.

Examples include:

* S3 bucket policies
* SQS policies
* SNS policies

Example:

```text id="8u3f7r"
S3 Bucket
   ↓
Bucket Policy
   ↓
Who can access this bucket?
```

This is different from an IAM identity policy.

---

# 17. Trust Policy

A **trust policy** defines **who or what is allowed to assume an IAM role**.

Example:

```text id="w1v5ma"
EC2
 ↓
Trust Policy
 ↓
Allowed to assume Role
```

A role therefore has two important concepts:

```text id="b8u2r7"
IAM Role
│
├── Trust Policy
│     ↓
│   Who can assume me?
│
└── Permission Policy
      ↓
    What can I do?
```

This distinction is very important.

---

# 18. EC2 IAM Role Example

Suppose an EC2 application needs to read files from S3.

Without a role, someone might be tempted to put access keys inside the application:

```text id="j6i7v3"
EC2
 ↓
Access Key + Secret Key
 ↓
S3
```

This is not a good approach.

Instead:

```text id="1c2l9y"
EC2
 ↓
IAM Role
 ↓
S3 Permission
 ↓
S3
```

AWS provides temporary credentials to the application through the role.

---

# 19. IAM Access Keys

Access keys are credentials used for programmatic access.

They consist of:

```text id="s8xv7g"
Access Key ID
Secret Access Key
```

They may be used by:

* AWS CLI
* SDKs
* Applications
* Terraform

### Important security rule

Never put access keys directly into:

```text
GitHub
Git repositories
Source code
Public files
README files
```

For production workloads, prefer temporary credentials and role-based authentication where possible.

---

# 20. MFA — Multi-Factor Authentication

**MFA** adds an additional authentication factor.

Instead of only:

```text id="g5jv5a"
Password
```

we use:

```text id="g7d1o0"
Password
+
MFA code/device
```

MFA provides stronger protection for important identities.

The AWS account root user should have MFA enabled.

---

# 21. Root User

When an AWS account is created, it has a **root user**.

The root user has extremely powerful permissions.

It should generally **not be used for everyday AWS operations**.

Instead:

```text id="l1fl8e"
Root User
     ↓
Account setup / specific account-level tasks

IAM / Identity Center
     ↓
Daily AWS operations
```

The root user's credentials should be strongly protected.

---

# 22. Least Privilege

The principle of least privilege means:

> Give an identity only the permissions it actually needs.

Bad:

```json id="t5f5gk"
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

This effectively gives extremely broad permissions.

Better:

```json id="n5t2la"
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject"
  ],
  "Resource": "arn:aws:s3:::my-bucket/*"
}
```

The second example provides much narrower access.

---

# 23. AWS STS

**AWS Security Token Service (STS)** provides temporary security credentials.

These credentials can include:

* Access key ID
* Secret access key
* Session token

They have a limited lifetime.

Example:

```text id="xj8kqo"
User / Service
      ↓
     STS
      ↓
Temporary Credentials
      ↓
AWS Resources
```

IAM roles commonly rely on STS to provide temporary credentials.

---

# 24. IAM and Terraform

Terraform needs permission to create and manage AWS resources.

For example:

```text id="t0yyw2"
Terraform
    ↓
AWS Provider
    ↓
IAM Authentication
    ↓
AWS API
    ↓
EC2 / S3 / VPC / RDS
```

Terraform can authenticate using AWS credentials configured through supported mechanisms such as:

* Environment variables
* AWS CLI configuration
* IAM roles
* Federated/temporary credentials
* Other AWS-supported authentication methods

---

# 25. Terraform IAM Resources

Terraform provides resources for managing IAM.

Common examples:

```text id="y0z1dy"
aws_iam_user
aws_iam_group
aws_iam_role
aws_iam_policy
aws_iam_policy_attachment
aws_iam_role_policy
aws_iam_instance_profile
```

Example IAM role:

```hcl id="q0l6v7"
resource "aws_iam_role" "ec2_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}
```

The trust policy above allows EC2 to assume the role.

---

# 26. IAM Role for EC2 — Terraform Flow

A typical setup looks like:

```text id="2j5xk8"
Terraform
   |
   +── IAM Role
   |
   +── IAM Policy
   |
   +── Instance Profile
   |
   └── EC2
          |
          ↓
         S3
```

The **instance profile** is the mechanism used to associate an IAM role with an EC2 instance.

---

# 27. AWS CLI and IAM

Check your AWS identity:

```bash id="vqf5i8"
aws sts get-caller-identity
```

This is a very useful command.

It shows information about the identity currently being used by the AWS CLI.

Configure AWS CLI credentials:

```bash id="0ry0o3"
aws configure
```

You may be prompted for:

```text
AWS Access Key ID
AWS Secret Access Key
Default region
Default output format
```

For production environments, use more secure temporary/federated authentication where possible.

---

# 28. IAM Policy Evaluation — Basic Idea

When AWS evaluates a request, it considers applicable policies.

A simplified model is:

```text id="x4o7d0"
Request
   ↓
Authentication
   ↓
Applicable Policies
   ↓
Explicit Deny?
   ├── Yes → DENY
   └── No
        ↓
     Allow?
     ├── Yes → ALLOW
     └── No  → DENY
```

The key rule is:

> **Explicit Deny overrides Allow.**

---

# 29. Common IAM Mistakes

### 1. Using root for everyday work

Avoid this.

### 2. Giving `AdministratorAccess` unnecessarily

Only provide broad permissions when genuinely required.

### 3. Hardcoding access keys

Never commit credentials to GitHub.

### 4. Giving `*` permissions unnecessarily

Prefer specific actions and resources.

### 5. Confusing trust policies and permission policies

Remember:

```text id="s9b4qf"
Trust Policy
→ Who can assume the role?

Permission Policy
→ What can the role do?
```

### 6. Forgetting MFA

Protect sensitive identities with MFA.

---

# 30. IAM Best Practices

* Protect the root user.
* Enable MFA.
* Follow least privilege.
* Prefer roles and temporary credentials.
* Avoid hardcoded credentials.
* Regularly review permissions.
* Remove unused credentials.
* Use groups or centralized identity management where appropriate.
* Restrict resources and actions instead of using `*`.
* Monitor and audit AWS activity.

---

# 31. IAM in a Real Application

Consider an application running on EC2 that needs to upload images to S3.

```text id="s4m2hk"
                   AWS
                    |
              IAM Role
                    |
            s3:PutObject
                    |
                    ↓
EC2 Application ─────────→ S3
```

The application does not need to know an AWS password or store long-lived credentials.

The role provides the required permissions.

---

# 32. Quick Revision

| Concept         | Meaning                             |
| --------------- | ----------------------------------- |
| IAM             | Controls AWS access                 |
| Authentication  | Determines who you are              |
| Authorization   | Determines what you can do          |
| User            | AWS identity                        |
| Group           | Collection of users                 |
| Role            | Assumable identity with permissions |
| Policy          | Defines permissions                 |
| Action          | Operation being allowed/denied      |
| Resource        | AWS resource affected               |
| ARN             | AWS resource identifier             |
| Trust Policy    | Defines who can assume a role       |
| MFA             | Additional authentication factor    |
| STS             | Provides temporary credentials      |
| Least Privilege | Give only required permissions      |

---

# 33. Most Important IAM Relationships

```text id="m6br3k"
                    IAM
                     |
          ┌──────────┼──────────┐
          ↓          ↓          ↓
        Users      Groups      Roles
          |          |          |
          └──────────┼──────────┘
                     ↓
                  Policies
                     ↓
                Permissions
                     ↓
              AWS Resources
```

For an EC2 application:

```text id="8t7x3z"
EC2
 ↓
IAM Role
 ↓
Permission Policy
 ↓
S3
```

---

# 34. Key Things to Remember

```text id="4q7k2p"
IAM = Access Control

User  = Identity
Group = Collection of Users
Role  = Assumable Identity
Policy = Permissions

Authentication = Who are you?
Authorization  = What can you do?

Trust Policy
→ Who can assume a role?

Permission Policy
→ What can the role do?

Least Privilege
→ Give only required permissions

MFA
→ Additional security

STS
→ Temporary credentials
```

### One-line definition

> **AWS IAM is a service that securely manages identities and permissions, controlling who can access AWS resources and what actions they are allowed to perform.**
