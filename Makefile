docker:
	docker build -t rascript-audit-img .

reset:
	docker container prune -f && docker image rm -f rascript-audit-img && docker system prune -af

run:
	docker run -i -t rascript-audit-img /bin/sh