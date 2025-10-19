#!/usr/bin/env node

/**
 * Generate a JSON file with random fields
 */

// Helper function to generate random string
function randomString(length = 10) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

// Helper function to generate random email
function randomEmail() {
  const domains = ['example.com', 'test.org', 'sample.net', 'demo.io'];
  const name = randomString(8).toLowerCase();
  const domain = domains[Math.floor(Math.random() * domains.length)];
  return `${name}@${domain}`;
}

// Helper function to generate random UUID
function randomUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Generate random data
const randomData = {
  id: randomUUID(),
  name: `${randomString(6)} ${randomString(8)}`,
  email: randomEmail(),
  age: Math.floor(Math.random() * 80) + 18,
  isActive: Math.random() > 0.5,
  balance: Math.round((Math.random() * 10000) * 100) / 100,
  address: {
    street: `${Math.floor(Math.random() * 9999) + 1} ${randomString(6)} Street`,
    city: randomString(8),
    state: randomString(2).toUpperCase(),
    zipCode: String(Math.floor(Math.random() * 90000) + 10000),
    coordinates: {
      latitude: Math.round((Math.random() * 180 - 90) * 10000) / 10000,
      longitude: Math.round((Math.random() * 360 - 180) * 10000) / 10000
    }
  },
  preferences: {
    theme: Math.random() > 0.5 ? 'dark' : 'light',
    notifications: Math.random() > 0.3,
    language: ['en-US', 'es-ES', 'fr-FR', 'de-DE'][Math.floor(Math.random() * 4)],
    timezone: ['America/New_York', 'Europe/London', 'Asia/Tokyo', 'Australia/Sydney'][Math.floor(Math.random() * 4)]
  },
  hobbies: ['reading', 'gaming', 'cooking', 'traveling', 'photography', 'music', 'sports', 'art']
    .sort(() => 0.5 - Math.random())
    .slice(0, Math.floor(Math.random() * 5) + 2),
  scores: Array.from({length: 5}, () => Math.floor(Math.random() * 100) + 1),
  metadata: {
    createdAt: new Date(Date.now() - Math.floor(Math.random() * 365 * 24 * 60 * 60 * 1000)).toISOString(),
    lastUpdated: new Date().toISOString(),
    version: Math.floor(Math.random() * 10) + 1,
    tags: ['premium', 'verified', 'beta-tester', 'new', 'active']
      .sort(() => 0.5 - Math.random())
      .slice(0, Math.floor(Math.random() * 3) + 1)
  },
  randomString: randomString(20),
  randomNumber: Math.floor(Math.random() * 100000),
  randomFloat: Math.round(Math.random() * 1000 * 1000) / 1000,
  randomBoolean: Math.random() > 0.5,
  nullValue: Math.random() > 0.8 ? null : randomString(5)
};

// Output the JSON
console.log(JSON.stringify(randomData, null, 2));