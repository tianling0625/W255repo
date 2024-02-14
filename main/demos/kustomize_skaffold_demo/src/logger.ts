import { AppConfig } from './config'
const winston = require('winston')
const { LoggingWinston } = require('@google-cloud/logging-winston')

const level = () => {
  return AppConfig.nodeEnvironment === 'production' ? 'warn' : 'debug'
}

const levels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4,
}

const colors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'white',
}

winston.addColors(colors)

const format = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss:ms' }),
  winston.format.colorize({ all: true }),
  winston.format.printf(
    (info: any) => `${info.timestamp} ${info.level}: ${info.message}`
  )
)

const transports = [
  new winston.transports.Console(),
]

if (AppConfig.enableCloudLogging === true) {
  // Google cloud logging
  const loggingWinston = new LoggingWinston()
  transports.push(loggingWinston)
}

const Logger = winston.createLogger({
  level: level(),
  levels,
  format,
  transports,
})

export default Logger
