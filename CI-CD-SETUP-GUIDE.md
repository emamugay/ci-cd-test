# CI/CD Setup Guide: From Zero to Production

This guide will help you implement a complete CI/CD pipeline for your Node.js application using the Kaizen approach - small, incremental improvements that compound over time.

## 🎯 What You'll Achieve

By the end of this guide, you'll have:
- ✅ Automated testing on every code change
- ✅ Automated Docker image building
- ✅ Staging and production deployment pipelines
- ✅ Security scanning and quality checks
- ✅ Rollback capabilities
- ✅ Monitoring and notifications

## 📋 Prerequisites

- [x] Node.js application (✅ You have this!)
- [x] Docker installed
- [x] GitHub repository
- [x] Docker Hub account (free)
- [ ] Basic understanding of Git

## 🚀 Phase 1: Local CI/CD Testing (Start Here!)

### Step 1: Test Your Local Pipeline

```bash
# Navigate to your application directory
cd day1/getting-started-app

# Make the script executable and run it
chmod +x scripts/local-ci-cd-test.sh
npm run ci:local
```

**What this does:**
- Installs dependencies
- Runs code quality checks
- Executes all tests
- Builds Docker image
- Generates coverage report

**Expected outcome:** All steps should pass ✅

### Step 2: Fix Any Issues

If any step fails, fix it before proceeding:

```bash
# Fix code formatting
npm run lint:fix

# Run tests individually
npm run test:unit
npm run test:integration

# Check security issues
npm run security:audit
```

## 🔧 Phase 2: GitHub Actions Setup

### Step 1: Create GitHub Repository

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit with CI/CD pipeline"

# Add GitHub remote (replace with your username/repo)
git remote add origin https://github.com/YOUR_USERNAME/getting-started-app.git
git push -u origin main
```

### Step 2: Configure GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Add these secrets:

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `DOCKERHUB_USERNAME` | your-dockerhub-username | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | your-dockerhub-token | Docker Hub access token |

**To get Docker Hub token:**
1. Go to [Docker Hub](https://hub.docker.com)
2. Account Settings → Security → New Access Token
3. Copy the token and paste it in GitHub secrets

### Step 3: Create Environment Protection

1. Go to **Settings** → **Environments**
2. Create two environments:
   - `staging` (no protection rules)
   - `production` (add protection rules):
     - ✅ Required reviewers (add yourself)
     - ✅ Wait timer: 10 minutes
     - ✅ Deployment branches: `main` only

### Step 4: Test the Pipeline

```bash
# Make a small change to trigger the pipeline
echo "# CI/CD Pipeline Enabled" >> README.md
git add README.md
git commit -m "Enable CI/CD pipeline"
git push origin main
```

**What happens:**
1. GitHub Actions triggers CI pipeline
2. Runs all tests and checks
3. Builds Docker image
4. Deploys to staging (automatically)
5. Waits for approval for production
6. Deploys to production (after approval)

## 📊 Phase 3: Monitoring & Metrics

### Step 1: Set Up Basic Monitoring

Add a health check endpoint to your application:

```javascript
// Add to src/index.js
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: process.env.npm_package_version || '1.0.0'
    });
});
```

### Step 2: Create Monitoring Dashboard

Track these key metrics:

| Metric | What to Track | How to Measure |
|--------|---------------|----------------|
| **Build Success Rate** | % of successful builds | GitHub Actions success rate |
| **Build Duration** | Time from commit to deployment | GitHub Actions workflow duration |
| **Test Coverage** | Code coverage percentage | Jest coverage reports |
| **Deployment Frequency** | How often you deploy | Count of successful deployments |
| **Lead Time** | Commit to production time | Time tracking in pipeline |
| **Mean Time to Recovery** | Time to fix failures | Incident response time |

### Step 3: Set Up Notifications

Add Slack/Discord notifications (optional):

```yaml
# Add to your GitHub Actions workflow
- name: Notify Success
  uses: 8398a7/action-slack@v3
  with:
    status: success
    channel: '#deployments'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
  if: always()
```

## 🔄 Phase 4: Advanced CI/CD Features

### Step 1: Add Feature Flags

```javascript
// Create src/featureFlags.js
const featureFlags = {
    newFeature: process.env.FEATURE_NEW_FEATURE === 'true',
    betaFeature: process.env.FEATURE_BETA === 'true'
};

module.exports = featureFlags;
```

### Step 2: Implement Blue-Green Deployment

```bash
# Create deployment scripts
mkdir -p scripts/deployment
```

```bash
# scripts/deployment/blue-green-deploy.sh
#!/bin/bash
echo "Implementing blue-green deployment..."
# Your blue-green deployment logic here
```

### Step 3: Add Canary Releases

```yaml
# Add to .github/workflows/cd.yml
canary-deploy:
  runs-on: ubuntu-latest
  steps:
    - name: Deploy 10% traffic
      run: |
        echo "Deploying to 10% of users..."
        # Your canary deployment logic
```

## 🏆 Phase 5: Best Practices & Optimization

### Daily Kaizen Practices

1. **Review CI/CD Metrics Daily** (2 minutes)
   ```bash
   # Check yesterday's builds
   gh run list --limit 10
   ```

2. **Monitor Test Coverage Weekly** (5 minutes)
   ```bash
   npm run test:coverage
   # Goal: Maintain >80% coverage
   ```

3. **Security Audit Monthly** (10 minutes)
   ```bash
   npm run security:audit
   npm run security:check
   ```

### Performance Optimization

1. **Cache Dependencies**
   ```yaml
   # Already included in your workflows
   - uses: actions/setup-node@v3
     with:
       cache: 'npm'
   ```

2. **Parallel Testing**
   ```bash
   # Run tests in parallel
   npm run test:unit & npm run test:integration
   ```

3. **Docker Layer Caching**
   ```yaml
   # Already included in your workflows
   cache-from: type=gha
   cache-to: type=gha,mode=max
   ```

## 🎯 Success Metrics

Track your progress with these goals:

| Timeframe | Goal | Current | Target |
|-----------|------|---------|---------|
| **Week 1** | Pipeline setup | ❌ | ✅ |
| **Week 2** | First successful deployment | ❌ | ✅ |
| **Month 1** | 5 deployments completed | 0 | 5 |
| **Month 2** | 90% build success rate | 0% | 90% |
| **Month 3** | <10 min deployment time | ∞ | <10 min |

## 🔧 Troubleshooting Common Issues

### Issue 1: Pipeline Fails on First Run

**Solution:**
```bash
# Check logs in GitHub Actions tab
# Common fixes:
npm run ci:local  # Test locally first
```

### Issue 2: Docker Build Fails

**Solution:**
```bash
# Test Docker build locally
npm run docker:build
npm run docker:test
```

### Issue 3: Tests Pass Locally but Fail in CI

**Solution:**
```bash
# Set CI environment locally
export CI=true
npm run test:ci
```

### Issue 4: Deployment Permissions

**Solution:**
1. Check GitHub secrets are set correctly
2. Verify Docker Hub token has push permissions
3. Check environment protection rules

## 📈 Next Steps

Once your basic pipeline is working:

1. **Add Integration Tests**
   ```bash
   mkdir -p src/__tests__/integration
   ```

2. **Implement Database Migrations**
   ```bash
   # Add migration scripts to your pipeline
   ```

3. **Set Up Monitoring**
   ```bash
   # Add application performance monitoring
   ```

4. **Create Documentation**
   ```bash
   # Document your deployment process
   ```

## 🎉 Congratulations!

You now have a production-ready CI/CD pipeline! Remember:

- 🔄 **Continuous Improvement**: Review and optimize regularly
- 📊 **Measure Everything**: Track metrics to improve
- 🚀 **Deploy Frequently**: Small, frequent deployments are safer
- 🛡️ **Security First**: Regular audits and updates
- 📝 **Document Changes**: Keep your team informed

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Jest Testing Guide](https://jestjs.io/docs/getting-started)
- [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist/)

---

**Happy Deploying! 🚀**

Remember: The best CI/CD pipeline is the one that works reliably and improves over time. Start simple, measure results, and enhance gradually. 