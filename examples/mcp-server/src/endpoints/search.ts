import { FastifyInstance } from 'fastify';

export function registerSearchEndpoint(app: FastifyInstance) {
  app.get('/search', async (req, reply) => {
    // @ts-ignore
    const index = app.mcpIndex;
    const { q } = req.query as { q?: string };
    if (!q) return reply.send([]);
    const needle = q.toLowerCase();
    const results = index.chunks
      .filter(c => c.content.toLowerCase().includes(needle))
      .slice(0, 10)
      .map(c => ({ chunkId: c.chunkId, artifactPath: c.artifactPath, snippet: c.content.substring(0, 160) }));
    reply.send(results);
  });
}
