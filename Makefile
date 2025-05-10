SHELL := /bin/bash
export GAME_ID := 4111
export RASCRIPT_FILE := "tmp/Test File.rascript"
export IMG_NAME := rascript-audit-img
export REPORT := true
export SEVERITY := test

docker:
	docker build -t $(IMG_NAME) .

reset:
	docker container prune -f && docker image rm -f $(IMG_NAME) && docker system prune -af

run:
	docker container rm -f $(IMG_NAME)
	rm -rf $(RASCRIPT_FILE)
	mkdir -p tmp
	wget -O $(RASCRIPT_FILE) https://raw.githubusercontent.com/joshraphael/ra$(GAME_ID)/refs/heads/main/$(GAME_ID).rascript
	rm -rf container_home
	mkdir -p container_home
	docker run -v "/var/run/docker.sock":"/var/run/docker.sock" --name $(IMG_NAME) -e GAME_ID=$(GAME_ID) -e REPORT=$(REPORT) -e SEVERITY=$(SEVERITY) -e RASCRIPT_FILE=$(RASCRIPT_FILE) --mount type=bind,src=.,dst=/app/rascript -i --entrypoint=/app/entry.sh $(IMG_NAME)
	docker cp $(IMG_NAME):/app/home.txt container_home/
	docker cp $(IMG_NAME):/app/copy.sh container_home/
	GAME_ID=$(GAME_ID) REPORT=$(REPORT) bash container_home/copy.sh
	rm -rf container_home/home.txt
	rm -rf container_home/copy.sh

debug:
	docker container rm -f $(IMG_NAME)
	docker run -v "/var/run/docker.sock":"/var/run/docker.sock" --name $(IMG_NAME) -e GAME_ID=$(GAME_ID) -e REPORT=$(REPORT) -e SEVERITY=$(SEVERITY) -e RASCRIPT_FILE=$(RASCRIPT_FILE) --mount type=bind,src=.,dst=/app/rascript -it --rm --entrypoint sh $(IMG_NAME)