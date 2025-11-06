import { FastifyInstance } from 'fastify';

export function registerHealthEndpoint(app: FastifyInstance) {
  const started = Date.now();
  app.get('/health', async (_req, reply) => {
    // @ts-ignore
    const index = app.mcpIndex;
    reply.send({
      status: 'ok',
      uptimeSeconds: Math.floor((Date.now() - started) / 1000),
      artifacts: index.artifacts.length,
      chunks: index.chunks.length,
      timestamp: new Date().toISOString()
    });
  });
}
