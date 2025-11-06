import { FastifyInstance } from 'fastify';

export function registerArtifactEndpoints(app: FastifyInstance) {
  app.get('/artifacts', async (req, reply) => {
    // @ts-ignore
    const index = app.mcpIndex;
    reply.send(index.artifacts);
  });

  app.get('/artifacts/:id', async (req, reply) => {
    // @ts-ignore
    const index = app.mcpIndex;
    const { id } = req.params as { id: string };
    const artifact = index.artifacts.find(a => a.id === id);
    if (!artifact) return reply.code(404).send({ error: 'Not found' });
    // naive: read file content directly
    try {
      const content = await (await import('fs')).promises.readFile(artifact.path, 'utf-8');
      reply.send({ ...artifact, content });
    } catch (e) {
      reply.code(500).send({ error: 'Failed to read artifact' });
    }
  });
}
