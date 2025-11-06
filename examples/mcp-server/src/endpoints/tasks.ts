import { FastifyInstance } from 'fastify';
import { promises as fs } from 'fs';

function extractTasks(content: string) {
  const lines = content.split(/\r?\n/);
  return lines
    .filter(l => /^\s*[-*]\s*\[[ xX]\]/.test(l))
    .map(l => {
      const checked = /\[[xX]\]/.test(l);
      return { raw: l.trim(), done: checked };
    });
}

export function registerTasksEndpoint(app: FastifyInstance) {
  app.get('/tasks/open', async (_req, reply) => {
    // @ts-ignore
    const index = app.mcpIndex;
    const taskArtifacts = index.artifacts.filter(a => a.type === 'tasks');
    const open: Array<{ artifact: string; raw: string }> = [];
    for (const art of taskArtifacts) {
      try {
        const data = await fs.readFile(art.path, 'utf-8');
        const tasks = extractTasks(data);
        tasks.filter(t => !t.done).forEach(t => open.push({ artifact: art.path, raw: t.raw }));
      } catch (e) {
        // ignore file read errors for now
      }
    }
    reply.send(open);
  });
}
