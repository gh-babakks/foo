#!/usr/bin/env node

const https = require('https');

/**
 * Sample issues data for demonstration (when API access is not available)
 */
const sampleIssues = [
  {
    number: 12,
    title: "foo",
    body: "bar",
    user: { login: "babakks" },
    created_at: "2025-07-30T12:01:31Z",
    comments: 0,
    html_url: "https://github.com/gh-babakks/foo/issues/12"
  }
];

/**
 * Displays issues in a formatted way
 */
function displayIssues(issues, isDemo = false) {
  console.log('\n📋 Open Issues for gh-babakks/foo\n');
  if (isDemo) {
    console.log('(Demo mode - showing sample data due to network restrictions)');
  }
  console.log('='.repeat(50));
  
  if (issues.length === 0) {
    console.log('🎉 No open issues found!');
  } else {
    issues.forEach((issue, index) => {
      console.log(`\n${index + 1}. Issue #${issue.number}`);
      console.log(`   Title: ${issue.title}`);
      console.log(`   Author: ${issue.user.login}`);
      console.log(`   Created: ${new Date(issue.created_at).toLocaleDateString()}`);
      console.log(`   Comments: ${issue.comments}`);
      if (issue.body && issue.body.trim()) {
        console.log(`   Description: ${issue.body.substring(0, 100)}${issue.body.length > 100 ? '...' : ''}`);
      }
      console.log(`   URL: ${issue.html_url}`);
    });
  }
  
  console.log('\n' + '='.repeat(50));
  console.log(`Total open issues: ${issues.length}`);
}

/**
 * Fetches and displays open issues from the GitHub repository
 */
async function showOpenIssues() {
  const owner = 'gh-babakks';
  const repo = 'foo';
  const apiUrl = `/repos/${owner}/${repo}/issues?state=open`;
  
  const options = {
    hostname: 'api.github.com',
    path: apiUrl,
    method: 'GET',
    headers: {
      'User-Agent': 'foo-issues-viewer',
      'Accept': 'application/vnd.github.v3+json'
    }
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        try {
          const issues = JSON.parse(data);
          
          if (res.statusCode !== 200) {
            console.error(`Error: ${res.statusCode} - ${issues.message || 'Failed to fetch issues'}`);
            console.log('\nFalling back to demo mode...');
            displayIssues(sampleIssues, true);
            resolve();
            return;
          }

          displayIssues(issues, false);
          resolve();
        } catch (error) {
          console.log('Network access restricted. Running in demo mode...');
          displayIssues(sampleIssues, true);
          resolve();
        }
      });
    });

    req.on('error', (error) => {
      console.log('Network access not available. Running in demo mode...');
      displayIssues(sampleIssues, true);
      resolve();
    });

    req.setTimeout(5000, () => {
      req.destroy();
      console.log('Request timeout. Running in demo mode...');
      displayIssues(sampleIssues, true);
      resolve();
    });

    req.end();
  });
}

// Run the function if this script is executed directly
if (require.main === module) {
  showOpenIssues().catch(console.error);
}

module.exports = { showOpenIssues };