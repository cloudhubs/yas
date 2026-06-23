import { unstable_v2_createSession } from 'openclaude/sdk';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// cwd = synthetic-data/ so openclaude discovers skills in .claude/skills/
const cwdPath    = resolve(__dirname, '..');
// target-path = yas/ root (the system to analyze)
const targetPath = resolve(__dirname, '../..');
// output-path = synthetic-data/output/
const outputPath = resolve(__dirname, '../output');

console.log(`[generate] target : ${targetPath}`);
console.log(`[generate] output : ${outputPath}`);
console.log(`[generate] cwd    : ${cwdPath}`);

const session = unstable_v2_createSession({
  cwd: cwdPath,
  canUseTool: () => Promise.resolve({ behavior: 'allow' }),
});

const prompt =
  `/generate-synthetic-data --target-path ${targetPath} --output-path ${outputPath}`;

for await (const message of session.sendMessage(prompt)) {
  if ('content' in message && typeof message.content === 'string') {
    process.stdout.write(message.content);
  }
}

session.close();
