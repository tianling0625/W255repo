# ----- base build container ----
# Includes tooling so prod node dependencies can be built
FROM node:15-alpine AS baseBuilder
RUN apk update && apk add make g++ python3
# Create app directory
RUN mkdir -p /opt/api/dist

COPY package.json yarn.lock tsconfig.json  /opt/api/

WORKDIR /opt/api
RUN yarn install --production

# ----- Development container ----
# Extends base build with development dependencies
# and runs TSC to build the project
# build container
FROM baseBuilder as devel
# Install dev dependencies
ENV NODE_ENV=development
RUN yarn install
COPY src            /opt/api/src
RUN node_modules/.bin/tsc

WORKDIR /opt/api

# Start command
CMD [ "yarn", "run", "dev" ]

# ----- Production container ----
# Obtains node modules from base build
# Obtains TSC compiled app from devel container
FROM node:15-alpine as prod
ENV NODE_ENV=production
COPY --from=baseBuilder /opt/api/node_modules /opt/api/node_modules
COPY --from=devel /opt/api/dist /opt/api/dist

WORKDIR /opt/api

# Start command
CMD [ "node", "./dist/test.js" ]
