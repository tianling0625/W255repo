import express, { Request, Response } from 'express'
import store from './redis-store'

export interface Model {
  version: string;
  description: string;
}


const router = express.Router()

router.get('/:id', async (req: Request, res: Response) => {
  const model = await store.get(req.params.id)
  if (!model) {
    return res.status(404).send({error: `Model '${req.params.id}' does not exist`})
  }

  res.status(200).send(model)
})

router.put('/:id', async (req: Request, res: Response) => {
  const model: Model = req.body
  const result = store.set(req.params.id, JSON.stringify(model))
  res.status(200).send(result)
})

export default router
