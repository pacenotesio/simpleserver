envfile = ./env.txt

include $(envfile)
export

up:
	docker-compose up -d

down:
	docker-compose down
