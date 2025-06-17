# 🚀 EngageIQ – Multi-Tenant SaaS Demo

Welcome to the EngageIQ MVP demo! This project showcases the foundation for a multi-tenant, AI-powered sales enablement platform built entirely on **AWS-native infrastructure**, with support for:

* 🧠 Chat-based interaction (stubbed LLM response)
* 📂 Secure file uploads
* 🧍 User-aware chat history
* 🔐 Org-level data isolation
* 🌐 Static frontend via CloudFront

---

## 🔧 Tech Stack

| Layer            | Tech Used                           |
| ---------------- | ----------------------------------- |
| Frontend Hosting | **S3 + CloudFront**                 |
| Backend API      | **FastAPI (Python)** via App Runner |
| File Storage     | **S3** with tenant-based prefixes   |
| Auth (stubbed)   | **Cognito** (to be re-enabled)      |
| Infra as Code    | **Terraform**                       |
| CI/CD            | **GitHub Actions** (planned)        |

---

## 🌍 Live Demo Flow

1. Open the CloudFront URL to access the **frontend**.
2. Enter a **user name** and **message** to interact with the backend.
3. Get a **simulated AI response** and view chat history by user/org.
4. Upload a file to see **mock S3 integration**.
5. Chat history auto-refreshes with timestamps and names.

---

## 🧪 API Endpoints

| Endpoint        | Method | Description                                                    |
| --------------- | ------ | -------------------------------------------------------------- |
| `/chat`         | POST   | Accepts `{org_id, user_id, message}` and returns mock response |
| `/chat-history` | GET    | Returns full chat history for current tenant                   |
| `/upload-file`  | POST   | Accepts file upload and returns S3 mock URL                    |

---

## 🏗️ Tenant Simulation

* All requests require `org_id` (e.g. `"demo-org"`)
* Each message includes a `user_id` (e.g. `"Alice"`)
* Data is isolated in-memory by org for the demo
* Future upgrade: DynamoDB with PK = `ORG#<id>`

---

## 🛠️ Setup & Deployment (Local)

1. Clone the repo
2. Start backend:

```bash
uvicorn api:router --reload
```

3. Open `index.html` in browser (or serve via Python/Live Server)
4. Interact with `/chat` and `/upload-file` endpoints

---

## 🚀 Deployment Strategy (Prod)

1. **Frontend**

   * Upload `index.html` to S3
   * Connect S3 to CloudFront with ACM TLS
2. **Backend**

   * Deploy FastAPI as App Runner service (via container image)
3. **Infra**

   * Use Terraform to manage S3, CloudFront, App Runner
4. **Auth**

   * Plug in Cognito JWT parsing for `org_id`, `user_id`

---

## ✅ Completed Features

* [x] Chat with per-user, per-org memory
* [x] Upload files to S3 (mocked response)
* [x] Multi-tenant data separation
* [x] Styled frontend hosted on CloudFront
* [x] Live backend via App Runner
* [x] Terraform modules for infra setup

---

## 🧠 Future Enhancements

* Replace stubbed LLM with OpenAI/GPT integration
* Move in-memory chat to **DynamoDB**
* Enable **Cognito**-based login and token extraction
* Add **RAG document ingestion + response scoring**
* Connect **CI/CD pipeline via GitHub Actions**
* Custom subdomains per org (`org.engageiq.tech`)

---

## 📸 Screenshots

> Include here:
>
> * Screenshot of CloudFront UI
> * Screenshot of response + history
> * Upload result mock
>   (optional for final delivery)

---

## 🤝 Credits

Built by **Muhammad Hassaan Javed**
For the **EngageIQ Platform Demo – June 2025**