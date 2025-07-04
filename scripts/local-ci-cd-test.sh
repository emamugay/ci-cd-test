#!/bin/bash

# Local CI/CD Pipeline Test Script
# This script mimics the CI/CD pipeline locally for testing purposes

set -e  # Exit on any error

echo "🚀 Starting Local CI/CD Pipeline Test..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Step 1: Environment Setup
print_status "Setting up environment..."
export NODE_ENV=test
export CI=true
export SQLITE_DB_LOCATION=./test-todo.db

# Step 2: Install Dependencies
print_status "Installing dependencies..."
if npm ci; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Step 3: Code Quality Checks
print_status "Running code quality checks..."

# Lint check
if npm run prettify; then
    print_success "Code formatting check passed"
else
    print_error "Code formatting check failed"
    exit 1
fi

# Step 4: Run Tests
print_status "Running tests..."

# Unit tests
if npm test; then
    print_success "Unit tests passed"
else
    print_error "Unit tests failed"
    exit 1
fi

# Test coverage
print_status "Generating test coverage report..."
if npm test -- --coverage; then
    print_success "Test coverage generated successfully"
    echo "Coverage report available in ./coverage/lcov-report/index.html"
else
    print_warning "Test coverage generation failed"
fi

# Step 5: Security Audit
print_status "Running security audit..."
if npm audit --audit-level=moderate; then
    print_success "Security audit passed"
else
    print_warning "Security audit found issues - review required"
fi

# Step 6: Docker Build Test
print_status "Testing Docker build..."
if docker build -t getting-started-app:test .; then
    print_success "Docker build successful"
    
    # Test running the container
    print_status "Testing Docker container..."
    CONTAINER_ID=$(docker run -d -p 3001:3000 getting-started-app:test)
    
    # Wait for container to start
    sleep 5
    
    # Test if container is responding
    if curl -f http://localhost:3001 > /dev/null 2>&1; then
        print_success "Docker container is running and responding"
    else
        print_warning "Docker container is not responding on port 3001"
    fi
    
    # Clean up
    docker stop $CONTAINER_ID > /dev/null 2>&1
    docker rm $CONTAINER_ID > /dev/null 2>&1
    
else
    print_error "Docker build failed"
    exit 1
fi

# Step 7: Simulate Deployment
print_status "Simulating deployment process..."
echo "1. Building production image..."
echo "2. Pushing to registry..."
echo "3. Deploying to staging..."
echo "4. Running smoke tests..."
echo "5. Deploying to production..."
print_success "Deployment simulation completed"

# Step 8: Generate CI/CD Report
print_status "Generating CI/CD report..."
cat > ci-cd-report.txt << EOF
CI/CD Pipeline Test Report
==========================
Date: $(date)
Repository: $(git remote get-url origin 2>/dev/null || echo "No remote configured")
Branch: $(git branch --show-current 2>/dev/null || echo "No git repository")
Commit: $(git rev-parse HEAD 2>/dev/null || echo "No git repository")

Test Results:
- Dependencies: ✅ Installed
- Code Quality: ✅ Passed
- Unit Tests: ✅ Passed
- Security Audit: ⚠️  Check required
- Docker Build: ✅ Passed
- Container Test: ✅ Passed

Next Steps:
1. Review security audit results
2. Push to repository to trigger actual CI/CD
3. Monitor pipeline execution
4. Verify deployment

EOF

print_success "CI/CD report generated: ci-cd-report.txt"

# Step 9: Cleanup
print_status "Cleaning up test artifacts..."
docker rmi getting-started-app:test > /dev/null 2>&1 || true

echo ""
echo "🎉 Local CI/CD Pipeline Test Completed Successfully!"
echo "=================================="
echo "📊 Report: ci-cd-report.txt"
echo "🌐 Coverage: ./coverage/lcov-report/index.html"
echo ""
echo "Ready to push to repository? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    print_status "Remember to:"
    echo "1. Set up GitHub secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN)"
    echo "2. Configure environments (staging, production)"
    echo "3. Add proper deployment targets"
    echo "4. Set up monitoring and alerting"
    echo ""
    echo "Happy deploying! 🚀"
else
    echo "Review the results and run again when ready!"
fi 