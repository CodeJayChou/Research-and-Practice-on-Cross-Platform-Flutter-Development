export type NodeEnvironment = 'development' | 'test' | 'production';

export interface AppConfig {
  readonly nodeEnv: NodeEnvironment;
  readonly host: string;
  readonly port: number;
  readonly corsOrigin: string;
  readonly logLevel: string;
}

export function loadAppConfig(
  environment: NodeJS.ProcessEnv = process.env,
): AppConfig {
  const rawPort = environment.PORT ?? '3000';
  const port = Number.parseInt(rawPort, 10);

  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error(`PORT must be an integer between 1 and 65535; got ${rawPort}`);
  }

  const rawNodeEnv = environment.NODE_ENV ?? 'development';
  if (!isNodeEnvironment(rawNodeEnv)) {
    throw new Error(`Unsupported NODE_ENV: ${rawNodeEnv}`);
  }

  return {
    nodeEnv: rawNodeEnv,
    host: environment.HOST ?? '0.0.0.0',
    port,
    corsOrigin: environment.CORS_ORIGIN ?? '*',
    logLevel: environment.LOG_LEVEL ?? 'info',
  };
}

function isNodeEnvironment(value: string): value is NodeEnvironment {
  return value === 'development' || value === 'test' || value === 'production';
}
