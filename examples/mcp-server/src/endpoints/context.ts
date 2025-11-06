import { FastifyInstance } from 'fastify';
import { promises as fs } from 'fs';

export function registerContextEndpoint(app: FastifyInstance) {
  app.get('/context', async (_req, reply) => {
    try {
      const raw = await fs.readFile('context.json', 'utf-8');
      // @ts-ignore
      const index = app.mcpIndex;
      reply.send({ context: JSON.parse(raw), counts: { artifacts: index.artifacts.length, chunks: index.chunks.length } });
    } catch (e) {
      reply.code(500).send({ error: 'Failed to load context.json' });
    }
  });
}
