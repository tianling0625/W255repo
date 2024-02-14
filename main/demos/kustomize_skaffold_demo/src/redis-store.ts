
import { AppConfig } from './config'
import Redis, { RedisOptions } from 'ioredis'
import * as fs from 'fs'

const redisOptions: RedisOptions = {
  retryStrategy(times: number) {
    return Math.min(times * 50, 2000)
  },
}

if (AppConfig.redisCaCert) {
  redisOptions['tls'] = { ca: fs.readFileSync(AppConfig.redisCaCert) }
}

// init redis
const redis = new Redis(AppConfig.redisUri, redisOptions)
export default redis
