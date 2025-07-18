# Django + Vue + Nginx + Docker
A simple template to setup your next django & vue.js project and deploy it using docker-compose with CI/CD using github actions. To use this project simply create a django project named ``backend`` in the ``backend`` directory and copy your vue.js frontend to ``frontend`` directory. 

### Folder structure

```
├── docker-compose.yml
|
├── backend
│   ├── docker-entrypoint.sh
│   └── Dockerfile
|
├── frontend
│   └── Dockerfile
|
└── nginx
    ├── cert.pem
    ├── default.conf
    ├── Dockerfile
    └── key.pem
```
- ``backend``: Django application
- ``frontend``: Vue.js application
- ``nginx``: Nginx configuration and SSL certificates
- ``docker-compose.yml``: Docker Compose file to run the entire stack

### Usage
1. **Build and run the containers**:
   ```bash
   docker-compose up --build
   ```

2. **Access the applications**:
    - Django backend: [http://localhost:8000](http://localhost:8000
    - Vue.js frontend: [http://localhost:8080](http://localhost:8080)

3. **Stop the containers**:
    ```bash
    docker-compose down
    ```

### Redis
If you want to use Redis for caching or session management, you can uncomment the ``redis`` service from the `docker-compose.yml` file:

```yaml
  redis:
    image: redis:7
    volumes:
      - redis_data:/data
    healthcheck:
      test: [ "CMD", "redis-cli", "ping" ]
      interval: 5s
      timeout: 5s
      retries: 5
```

**Note**: Make sure to uncomment healthchecks and dependency links in the ``backend`` service if you enable Redis.

### Celery
If you want to use Celery for background tasks, you can uncomment the ``celery`` service from the `docker-compose.yml` file:

```yaml
  celery:
    build:
      context: ./backend
      dockerfile: Dockerfile
    command: celery -A backend worker -l INFO
    environment:
      - DJANGO_SETTINGS_MODULE=backend.settings
      - DATABASE_URL=postgres://USER:PASSWORD@postgres:5432/DATABASE
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - backend
      - redis
      - postgres
```

### SSL
If you want to use SSL, ensure you have your `cert.pem` and `key.pem` files in the `nginx` directory. The Nginx configuration is set up to use these files for HTTPS.

You could generate self-signed certificates for local development using the following command:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/key.pem -out nginx/cert.pem
``` 

### API Routes
- ``/`` - Vue.js frontend
- ``/api`` - Django API endpoint
- ``/admin`` - Django admin interface
- ``/static`` - Static files collected by Django
- ``/media`` - Media files uploaded by users
- ``/ws`` - WebSocket endpoint for real-time features (if implemented)

### Environment Variables
You can set environment variables for the Django backend in the `docker-compose.yml` file under the `backend` service. For example:

```yaml
environment:
    - DJANGO_SETTINGS_MODULE=backend.settings
    - DATABASE_URL=postgres://USER:PASSWORD@postgres:5432/DATABASE
    - REDIS_URL=redis://redis:6379/0
```

### CI/CD - Github Actions
Define the following secrets in your repository by navigating to ``Settings`` > ``Secrets and Variables`` > ``New Secret``.

```bash
SSH_HOST=
SSH_USER=
SSH_PASSWORD=
DEPLOY_PATH=
```

### Notes
- Ensure Docker and Docker Compose are installed on your machine.
- The Nginx configuration is set up to serve both the Django backend and Vue.js frontend
- SSL certificates are included for HTTPS support. Replace `cert.pem` and `key.pem` with your own certificates if needed.
