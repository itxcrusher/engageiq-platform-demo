## 🧠 **EngageIQ MVP Architecture Overview**

This architecture represents the full-stack MVP deployment of the **EngageIQ multi-tenant AI SaaS platform** — designed for scalability, security, and seamless integration with the AI logic layer.

---

### 🌐 **Edge & Routing Layer**

* **Route 53** handles DNS resolution for the primary domain (`*.engageiq.tech`)
* **CloudFront** provides global CDN delivery with edge caching for static assets and API requests
* **ACM (TLS)** ensures HTTPS across all endpoints, including frontend and backend traffic

---

### 🔐 **Authentication Layer (Cognito)**

* **Cognito Hosted UI** authenticates users and issues **JWTs** containing `org_id`, `user_id`, and role claims
* After successful login, users are **redirected** to the frontend with the token
* Tokens are used to securely identify and route tenant-specific data and actions

---

### 🧱 **App Hosting Layer (VPC & App Runner)**

* **App Runner** hosts the backend **FastAPI service** using **public networking mode**
* Resides within a **multi-AZ VPC**, with public subnets (future NAT gateways supported if needed)
* App Runner scales automatically based on incoming requests

---

### 📦 **Frontend (SPA) Hosting Layer**

* **React frontend** is deployed to an **S3 bucket** (SPA Bucket), versioned per deployment
* Served through CloudFront with proper MIME types, CORS settings, and cache invalidation
* Hosted on the same domain structure for unified routing

---

### 🧬 **Data Layer**

* **DynamoDB** stores:

  * **Chat memory**: keyed by `PK = USER#<id>`, `SK = MSG#<timestamp>`
  * **File metadata**: `PK = ORG#<id>`, `SK = FILE#<filename>`
* Data is tenant-scoped and isolated through partition key strategy — enabling secure per-org access control
* **S3** stores files with prefixing strategy (`/org-id/filename.ext`) to maintain per-org logical separation

---

### 🔁 **CI/CD & Infrastructure as Code**

* **GitHub Actions** used for:

  * Code testing + deployment
  * Terraform plan/apply via OIDC (no AWS keys)

* **Terraform Cloud** provisions:

  * App Runner
  * S3 buckets
  * CloudFront distribution
  * DynamoDB table
  * VPC & related networking

* Invalidation of CloudFront cache triggered after frontend deploy

* Secrets and config values are stored in **AWS Secrets Manager**

---

### 🧪 **Observability & Secrets**

* **CloudWatch Logs** and **Metrics** are configured to capture:

  * App Runner logs
  * Backend API traffic
  * Upload events
* **Secrets Manager** stores:

  * API tokens
  * JWT verification keys
  * Future third-party credentials (e.g., OpenAI keys)

---

### 🔐 **Security Design Highlights**

* TLS enforced via CloudFront
* Least privilege IAM enforced for App Runner and Terraform deployments
* Org-level isolation in both storage and logic
* Secrets encrypted at rest and accessed securely at runtime
* Designed for **ISO 27001 alignment** and future compliance expansion

---

### 📈 **Scalability & Future Extensions**

This architecture is built for growth. Future additions like:

* **Subdomain per tenant**
* **OpenAI/Claude LLM integration**
* **Custom admin panels**
* **Self-service onboarding flows**
* **Analytics dashboards**
* **RAG ingestion + vector search**

…can all be integrated **without rearchitecting the platform**.