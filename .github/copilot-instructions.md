# foo Repository

This is a minimal GitHub repository designed for testing GitHub workflows and npm package management automation. The repository contains GitHub Actions workflows for testing step execution patterns and artifact uploading.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Repository Setup and Dependencies
- Clone repository: `git clone <repository-url>`
- Navigate to repository: `cd foo`
- Initialize npm (if package.json doesn't exist): `npm init -y`
- Install dependencies: `npm install` -- takes <1 second, no dependencies currently. NEVER CANCEL.
- Node.js and npm are required and available in the environment

### Build and Test Commands
- Run npm test: `npm test` -- currently fails with "Error: no test specified" and exits with code 1
- No build process exists currently - this is a workflow testing repository
- No linting commands are configured
- No additional build tools or dependencies are required

### Repository Structure
```
/home/runner/work/foo/foo/
├── .github/
│   ├── workflows/
│   │   ├── manual-dispatch.yml    # Test job/step failure workflow
│   │   └── upload-artifact.yml    # Upload Hello World artifacts workflow
│   ├── PULL_REQUEST_TEMPLATE/
│   │   └── my-template.md         # PR template with "hey"
│   ├── dependabot.yml             # npm package management automation
│   └── pull_request_template.md   # Default PR template
├── README.md                      # Contains only "# foo"
└── package.json                   # Basic npm configuration (may need initialization)
```

### GitHub Workflows

#### Manual Dispatch Workflow (`manual-dispatch.yml`)
- Purpose: Tests step success/failure patterns with configurable timeouts
- Dispatch inputs:
  - `result_string`: Success pattern (T=pass, F=fail), default "TTTTT"
  - `sleep_timeout`: Sleep durations in seconds, default "10 10 10 10 10"
- Contains 3 job variants:
  - `normal`: Fails on first error
  - `continue-on-error`: Continues despite errors
  - `always-run`: Always runs all steps
- NEVER CANCEL: Each step can take 10+ seconds based on input timeouts

#### Upload Artifact Workflow (`upload-artifact.yml`)
- Purpose: Creates and uploads Hello World files as artifacts
- Triggers: Push to main branch or manual dispatch
- Creates artifacts: `hello-text`, `hello-zip`, `hello-directory`
- NEVER CANCEL: Artifact creation takes <1 second, upload timing varies

### Validation Scenarios

#### Test Workflow Logic Locally
Always test workflow logic before making changes:
```bash
# Test manual-dispatch workflow logic
export RESULT_STRING="TTTTT"
export SLEEP_TIMEOUTS="1 1 1 1 1"
eval 'play() { idx=$1; ts=( $SLEEP_TIMEOUTS ); sleep "${ts[$idx]}"; step_num=$((idx+1)); if [ "${RESULT_STRING:$idx:1}" = "T" ]; then echo "Step $step_num passed"; else echo "Step $step_num failed"; exit 1; fi; }'
for i in {0..4}; do echo "Running step $((i+1))..."; play $i; done
```

#### Test Artifact Creation
Always validate artifact workflows:
```bash
# Test artifact creation workflow logic
echo "Hello World!" > hello.txt
zip -q hello.zip hello.txt
echo "Hello World, again!" > hello2.txt
echo "Hello World, one more time!" > hello3.txt
mkdir -p hello_files
mv hello.txt hello2.txt hello3.txt hello_files/
ls -la hello_files/
# Clean up
rm -rf hello.zip hello_files/
```

#### Validate npm Functionality
Since dependabot.yml references npm packages:
```bash
# Ensure package.json exists
npm init -y
# Test basic npm operations
npm install  # Takes <1 second
npm test     # Currently fails as expected
```

## Common Patterns and Expectations

### Timing Expectations
- `npm init -y`: <1 second
- `npm install`: <1 second (no dependencies)
- `npm test`: <1 second (fails by design)
- Workflow step simulation: 1-10 seconds per step based on configuration
- Artifact creation: <1 second locally
- Git operations: <1 second

### Repository Purpose
This repository serves as:
1. GitHub Actions workflow testing environment
2. Artifact upload/download demonstration
3. npm/dependabot integration testing
4. PR template testing

### Key Validation Points
- Always test workflow logic locally before modifying workflows
- Verify npm functionality if adding dependencies
- Test artifact creation patterns when modifying upload workflows
- Validate PR templates are accessible and properly formatted

### Dependencies and Requirements
- Node.js (available in environment)
- npm (available in environment)
- zip utility (available in environment)
- Git (available in environment)
- No additional dependencies or build tools required

### Workflow Testing
When testing workflows:
1. Use manual dispatch with short timeouts for rapid iteration
2. Test failure scenarios using RESULT_STRING with "F" characters
3. Validate continue-on-error and always-run job behaviors
4. Check artifact upload success in GitHub Actions UI

### Git Operations
- Repository uses standard git workflows
- Main branch protection may be in place
- PR templates are configured and should be used
- Dependabot will create PRs for npm updates (when dependencies exist)

### Troubleshooting
- If npm operations fail, ensure package.json exists: `npm init -y`
- If workflows behave unexpectedly, test logic locally first
- Check GitHub Actions logs for workflow execution details
- Validate file permissions for script execution

## Important Notes
- This is a minimal testing repository, not a production application
- No application server or user interface exists to validate
- Focus validation on workflow execution and npm package management
- NEVER CANCEL workflow testing - steps complete quickly
- Always clean up temporary files created during testing