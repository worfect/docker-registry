init: d-down-clear d-pull d-build d-up

d-up:
	docker-compose up -d

d-down:
	docker-compose down --remove-orphans

d-down-clear:
	docker-compose down -v --remove-orphans

d-pull:
	docker-compose pull

d-build:
	docker-compose build

deploy:
	ssh ${HOST} -p ${PORT} 'rm -rf registry && mkdir registry'
	scp -P ${PORT} docker-compose.yml ${HOST}:registry/docker-compose.yml
	scp -P ${PORT} -r docker ${HOST}:registry/docker
	scp -P ${PORT} ${HTPASSWD_FILE} ${HOST}:registry/htpasswd
	ssh ${HOST} -p ${PORT} 'cd registry && echo "COMPOSE_PROJECT_NAME=registry" >> .env'
	ssh ${HOST} -p ${PORT} 'cd registry && docker-compose down --remove-orphans'
	ssh ${HOST} -p ${PORT} 'cd registry && docker-compose pull'
	ssh ${HOST} -p ${PORT} 'cd registry && docker-compose up -d'