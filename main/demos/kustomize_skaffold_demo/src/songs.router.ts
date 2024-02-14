import express, { Request, Response } from 'express'
import * as SongModel from './Song'
import Logger from './logger'

const router = express.Router()

router.get('/:id', async (req: Request, res: Response) => {
  try {
    const [rows] = await SongModel.getById(req.params.id)
    res.status(200).send(rows)

  } catch (err) {
    Logger.error(err)
    res.status(500).send({error: 'ooops !'})
  }
})

router.put('/:id', async (req: Request, res: Response) => {
  const obj: SongModel.Song = req.body
  try {
    await SongModel.save([obj])
    res.status(200).send(obj)
  } catch (err) {
    Logger.error(err)
    res.status(500).send({error: 'ooops !'})
  }
})

export default router
