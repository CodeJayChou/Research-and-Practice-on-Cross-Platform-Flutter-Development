import { buildApp } from './app.js';
import { loadAppConfig } from './config/app-config.js';

const config = loadAppConfig();
const app = await buildApp({ config });

let isShuttingDown = false;

async function shutdown(signal: NodeJS.Signals): Promise<void> {
  if (isShuttingDown) {
    return;
  }
  isShuttingDown = true;
  app.log.info({ signal }, 'Shutting down');
  await app.close();
}

process.once('SIGINT', () => void shutdown('SIGINT'));
process.once('SIGTERM', () => void shutdown('SIGTERM'));

try {
  await app.listen({ host: config.host, port: config.port });
} catch (error) {
  app.log.error(error, 'Unable to start server');
  process.exitCode = 1;
  await app.close();
}
