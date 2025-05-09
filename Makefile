SHELL := /bin/bash
export GAME_ID := 4111
export REPO_DIR := /app/rascript
export RASCRIPT_FILE := "tmp/Test File.rascript"
export REPO_NAME := rascript-audit-img

docker:
	docker build -t $(REPO_NAME) .

reset:
	docker container prune -f && docker image rm -f $(REPO_NAME) && docker system prune -af

run:
	docker container rm -f $(REPO_NAME)
	rm -rf $(RASCRIPT_FILE)
	mkdir -p tmp
	wget -O $(RASCRIPT_FILE) https://raw.githubusercontent.com/joshraphael/ra$(GAME_ID)/refs/heads/main/$(GAME_ID).rascript
	rm -rf container_home
	mkdir -p container_home
	docker run -v "/var/run/docker.sock":"/var/run/docker.sock" --name $(REPO_NAME) -e GAME_ID=$(GAME_ID) -e REPO_DIR=$(REPO_DIR) -e RASCRIPT_FILE=$(RASCRIPT_FILE) --mount type=bind,src=.,dst=$(REPO_DIR) -it $(REPO_NAME)
	docker cp $(REPO_NAME):/app/home.txt container_home/
	docker cp $(REPO_NAME):/app/copy.sh container_home/
	GAME_ID=$(GAME_ID) bash container_home/copy.sh

debug:
	docker container rm -f $(REPO_NAME)
	docker run -v "/var/run/docker.sock":"/var/run/docker.sock" --name $(REPO_NAME) -e GAME_ID=$(GAME_ID) -e REPO_DIR=$(REPO_DIR) -e RASCRIPT_FILE=$(RASCRIPT_FILE) --mount type=bind,src=.,dst=$(REPO_DIR) -it --rm --entrypoint sh $(REPO_NAME)