#!/usr/bin/env node
// Example stub script for daily digest automation
const { execSync, spawnSync } = require('child_process');

function checkGhCli() {
	try {
		execSync('gh --version', { stdio: 'ignore' });
		return true;
	} catch (e) {
		return false;
	}
}

if (!checkGhCli()) {
	console.error('GitHub CLI (gh) is not installed. Please install it to run this script.');
	process.exit(1);
}

// Example: Fetch user info as a stub action
try {
	const result = spawnSync('gh', ['api', 'user'], { encoding: 'utf-8' });
	if (result.error) throw result.error;
	if (result.status !== 0) {
		console.error('Failed to fetch user info:', result.stderr);
		process.exit(result.status);
	}
	console.log('GitHub user info:', result.stdout);
} catch (err) {
	console.error('Error running gh CLI:', err);
	process.exit(1);
}
