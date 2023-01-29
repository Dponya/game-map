# game-map

A simple service that consists of a PHP backend that generates a game map with random entities and a simple client that renders svg circles on the document by coordinates received from the backend.

# How to run

First of all, ensure that docker is installed on your system, then:

Just run services via `docker-compose`. Client will run on `localhost:8000`, server on `localhost:4000`.

```bash
docker-compose up
```

After that, open the browser and look up `localhost:8000/index.html`.