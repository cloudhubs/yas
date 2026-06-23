import { readFileSync, existsSync, readdirSync, statSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const outputPath = resolve(__dirname, '../output');

const errors: string[] = [];

function check(condition: boolean, message: string): void {
  if (!condition) errors.push(message);
}

function fileContains(path: string, substring: string): boolean {
  return existsSync(path) && readFileSync(path, 'utf-8').includes(substring);
}

// flow-graph.mmd
const graphPath = `${outputPath}/flow-graph.mmd`;
check(existsSync(graphPath), 'flow-graph.mmd missing');
check(fileContains(graphPath, 'graph LR') || fileContains(graphPath, 'graph TD'), 'flow-graph.mmd missing graph directive');
check(fileContains(graphPath, '-->'), 'flow-graph.mmd has no edges');

// flow-matrix.md
const matrixPath = `${outputPath}/flow-matrix.md`;
check(existsSync(matrixPath), 'flow-matrix.md missing');
if (existsSync(matrixPath)) {
  const matrix = readFileSync(matrixPath, 'utf-8');
  check(matrix.includes('| Flow Name |'), 'flow-matrix.md missing required header columns');
  const dataRows = matrix.split('\n').filter(
    l => l.startsWith('|') && !l.includes('---') && !l.includes('Flow Name')
  );
  check(dataRows.length > 0, 'flow-matrix.md has no flow rows');
  const hasSuccess = dataRows.some(r => r.includes('success'));
  const hasUnauth  = dataRows.some(r => r.includes('unauthenticated') || r.includes('unauthorized'));
  check(hasSuccess, 'flow-matrix.md has no success scenario');
  check(hasUnauth,  'flow-matrix.md has no unauthenticated/unauthorized scenario');
}

// setup-auth.sh (if present — only for Keycloak systems)
const authScriptPath = `${outputPath}/setup-auth.sh`;
if (existsSync(authScriptPath)) {
  check(fileContains(authScriptPath, 'openid-connect/token'), 'setup-auth.sh missing Keycloak token call');
  check(fileContains(authScriptPath, 'create_user'), 'setup-auth.sh missing create_user calls');
}

// postman_seed.json
const postmanPath = `${outputPath}/postman_seed.json`;
check(existsSync(postmanPath), 'postman_seed.json missing');
if (existsSync(postmanPath)) {
  try {
    const postman = JSON.parse(readFileSync(postmanPath, 'utf-8'));
    check('info' in postman, 'postman_seed.json missing info field');
    check('item' in postman && Array.isArray(postman.item) && postman.item.length > 0, 'postman_seed.json has no items');
    check(
      postman.info?.schema === 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
      'postman_seed.json wrong schema version'
    );
  } catch {
    errors.push('postman_seed.json is not valid JSON');
  }
}

// docker-compose.test.yml
const composePath = `${outputPath}/docker-compose.test.yml`;
check(existsSync(composePath), 'docker-compose.test.yml missing');
check(fileContains(composePath, 'services:'), 'docker-compose.test.yml missing services block');
check(fileContains(composePath, 'image:'), 'docker-compose.test.yml missing image entries');
check(fileContains(composePath, 'healthcheck:'), 'docker-compose.test.yml missing healthcheck');

// seed SQL — at least one directory with seed.sql
const subdirs = existsSync(outputPath)
  ? readdirSync(outputPath).filter(f => statSync(`${outputPath}/${f}`).isDirectory())
  : [];
const seedDirs = subdirs.filter(d => d !== 'postgres-init');
check(seedDirs.length > 0, 'No seed directories found in output/ (excluding postgres-init)');
for (const svc of seedDirs) {
  const sqlPath = `${outputPath}/${svc}/seed.sql`;
  check(existsSync(sqlPath), `${svc}/seed.sql missing`);
  if (existsSync(sqlPath)) {
    const sql = readFileSync(sqlPath, 'utf-8');
    check(sql.includes('INSERT INTO'), `${svc}/seed.sql has no INSERT statements`);
    check(sql.includes('BEGIN;'), `${svc}/seed.sql missing transaction wrapper`);
  }
}

if (errors.length > 0) {
  console.error('\nValidation FAILED:');
  errors.forEach(e => console.error(`  ✗ ${e}`));
  process.exit(1);
} else {
  console.log('\nValidation PASSED — all output artifacts are well-formed.');
  process.exit(0);
}
