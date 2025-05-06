docker:
	docker build -t rascript-audit .

reset:
	docker container prune -f && docker image rm -f rascript-audit && docker system prune -af

run:
	docker run -i -t rascript-audit /bin/sh