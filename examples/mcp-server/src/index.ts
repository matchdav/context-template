import Fastify from 'fastify';
import websocket from 'fastify-websocket';
import { loadIndex } from './lib/indexLoader.js';
import { registerArtifactEndpoints } from './endpoints/artifacts.js';
import { registerHealthEndpoint } from './endpoints/health.js';
import { registerContextEndpoint } from './endpoints/context.js';
import { registerSearchEndpoint } from './endpoints/search.js';
import { registerTasksEndpoint } from './endpoints/tasks.js';

async function main() {
  const fastify = Fastify({ logger: true });
  fastify.register(websocket);

  const index = await loadIndex('.context/index/combined.json');
  fastify.decorate('mcpIndex', index);

  registerArtifactEndpoints(fastify);
  registerHealthEndpoint(fastify);
  registerContextEndpoint(fastify);
  registerSearchEndpoint(fastify);
  registerTasksEndpoint(fastify);

  const port = process.env.PORT ? Number(process.env.PORT) : 3333;
  await fastify.listen({ port, host: '0.0.0.0' });
  console.log(`MCP server listening on port ${port}`);
}

main().catch(err => {
  console.error('Server failed to start', err);
  process.exit(1);
});
