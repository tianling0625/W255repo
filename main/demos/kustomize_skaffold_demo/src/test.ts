import express from 'express'
import Logger from './logger'
import { AppConfig } from './config'
import modelRouter from './models.router'
import songsRouter from './songs.router'

const app = express()
app.use(express.json())
app.use('/api/v1/models', modelRouter)
app.use('/api/v1/songs', songsRouter)


app.listen(AppConfig.listenPort, () => {
  Logger.warn(`Listening on port ${AppConfig.listenPort}`)
})
