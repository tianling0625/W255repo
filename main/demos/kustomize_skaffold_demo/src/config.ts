export namespace AppConfig {
  export const appName = 'Test'
  export const listenPort: number = parseInt(process.env.LISTEN_PORT || '8080')
  export const nodeEnvironment: string = process.env.NODE_ENV || 'development'
  export const enableCloudLogging: boolean = /true/i.test(
    process.env.ENABLE_CLOUD_LOGGING || 'false'
  )

  // Redis configuration
  export const redisUri = process.env.REDISURI
  export const redisCaCert = process.env.REDIS_CACERT

  // Spanner configuration
  export const spannerInstance = process.env.SPANNER_INSTANCE
  export const spannerDb = process.env.SPANNER_DB
};
