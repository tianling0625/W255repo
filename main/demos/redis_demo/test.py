from datetime import timedelta

import numpy as np
import redis

r = redis.Redis()

cache_hit = 0
min = 1
max = 100
n = 10000
for i, key in enumerate(np.random.randint(min, max, n)):
    if r.get(int(key)):
        cache_hit += 1
    else:
        r.setex(f"{key}", timedelta(minutes=1), value="cached")
    if i % 100 == 0:
        print(i, cache_hit / (i + 1))
