# 🐳 Docker Hub CI/CD Setup Guide

## Step 1: Create Docker Hub Access Token

Your Docker Hub username: **magscy**

### Create Access Token:
1. **Go to:** [https://hub.docker.com/settings/security](https://hub.docker.com/settings/security)
2. **Click:** "New Access Token"
3. **Token name:** `github-actions-cicd`
4. **Permissions:** Select **"Read, Write, Delete"**
5. **Click:** "Generate"
6. **⚠️ COPY THE TOKEN** (you can't see it again!)

## Step 2: Add GitHub Secrets

### Go to GitHub Secrets:
1. **Visit:** [https://github.com/emamugay/ci-cd-test/settings/secrets/actions](https://github.com/emamugay/ci-cd-test/settings/secrets/actions)
2. **Click:** "New repository secret"

### Add These Two Secrets:

#### Secret 1:
- **Name:** `DOCKERHUB_USERNAME`
- **Value:** `magscy`

#### Secret 2:
- **Name:** `DOCKERHUB_TOKEN`
- **Value:** `[paste your access token here]`

## Step 3: Test the Complete Pipeline

Once secrets are set up, trigger the pipeline:

```bash
git add .
git commit -m "Set up automated Docker Hub deployment"
git push origin main
```

## What Will Happen:

### ✅ CI Pipeline (Automatic):
- ✅ Run tests on Node.js 16, 18, 20
- ✅ Code formatting checks
- ✅ Security audit
- ✅ Build Docker image

### ✅ CD Pipeline (After CI succeeds):
- ✅ **Staging:** Build and push `magscy/my-cicd-app:staging`
- ✅ **Staging:** Deploy to staging environment
- ✅ **Staging:** Run smoke tests
- ✅ **Production:** Build and push `magscy/my-cicd-app:latest`
- ✅ **Production:** Deploy to production (requires manual approval)

## Your Docker Hub Repository:
- **Public URL:** [https://hub.docker.com/r/magscy/my-cicd-app](https://hub.docker.com/r/magscy/my-cicd-app)
- **Pull command:** `docker pull magscy/my-cicd-app:latest`

## Current Images Available:
- ✅ `magscy/my-cicd-app:latest` (manually pushed)
- ✅ `magscy/my-cicd-app:v1.0` (manually pushed)

## Next Images (Automated):
- 🔄 `magscy/my-cicd-app:staging` (CI/CD will create)
- 🔄 `magscy/my-cicd-app:[commit-sha]` (CI/CD will create) 