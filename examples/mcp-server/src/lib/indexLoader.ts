import { promises as fs } from 'fs';

export interface MCPIndex {
  artifacts: Array<{ id: string; path: string; type: string; title: string; updated: string }>;
  chunks: Array<{ chunkId: string; artifactPath: string; content: string }>;
}

export async function loadIndex(path: string): Promise<MCPIndex> {
  try {
    const raw = await fs.readFile(path, 'utf-8');
    const parsed = JSON.parse(raw);
    if (!parsed.artifacts || !parsed.chunks) {
      return { artifacts: [], chunks: [] };
    }
    return parsed as MCPIndex;
  } catch (e) {
    return { artifacts: [], chunks: [] };
  }
}
