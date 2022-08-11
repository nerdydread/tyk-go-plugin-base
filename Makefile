###############################################################################
#
# Makefile for project lifecycle
#
###############################################################################

# Default task: sets up development environment
install: up build

### PROJECT ###################################################################

# Builds the Go plugin
build: go-build restart-gateway

# Builds production-ready plugin bundle
bundle: go-bundle restart-gateway

# Outputs the project logs
logs: docker-logs

# Brings up the project
up: docker-up docker-status

# Brings down the project
down: docker-down docker-status

# Cleans the project
clean: go-clean

# Gets the status of the docker containers
status: docker-status

### DOCKER ####################################################################

# Gets the status of the running containers
.PHONY: docker-status
docker-status:
	docker-compose ps

# Gets the container logs
.PHONY: docker-logs
docker-logs:
	docker-compose logs -t --tail="all"

# Bring docker containers up
.PHONY: docker-up
docker-up:
	docker-compose up -d --remove-orphans tyk-dashboard

# Bring docker containers down
.PHONY: docker-down
docker-down:
	docker-compose down --remove-orphans

### Tyk Go Plugin ########################################################################

# Builds Go plugin and moves it into local Tyk instance
go-build: build-example build-example2 build-example3

# Builds example.go
.PHONY: build-example
build-example:
	/bin/sh -c "cd ./go/src/example && go mod tidy && go mod vendor"
	docker-compose run --rm -v `pwd`/go/src/example:/plugin-source tyk-plugin-compiler example.so
	mv -f ./go/src/example/example.so ./tyk/middleware/example.so

# Builds example2.go
.PHONY: build-example2
build-example2:
	/bin/sh -c "cd ./go/src/example2 && go mod tidy && go mod vendor"
	docker-compose run --rm -v `pwd`/go/src/example2:/plugin-source tyk-plugin-compiler example2.so
	mv -f ./go/src/example2/example2.so ./tyk/middleware/example2.so

# Builds example3.go
.PHONY: build-example3
build-example3:
	/bin/sh -c "cd ./go/src/example3 && go mod tidy && go mod vendor"
	docker-compose run --rm -v `pwd`/go/src/example3:/plugin-source tyk-plugin-compiler example3.so
	mv -f ./go/src/example3/example3.so ./tyk/middleware/example3.so

# Builds production-ready Go plugin bundle as non-root user, using Tyk Bundler tool
.PHONY: go-bundle
go-bundle: go-build
	docker-compose run --rm --user=1000 --entrypoint "bundle/bundle-entrypoint.sh" tyk-gateway

# Cleans application files
.PHONY: go-clean
go-clean:
	-rm -rf ./go/src/vendor
	-rm -f ./go/src/example/example.so
	-rm -f ./go/src/example2/example2.so
	-rm -f ./go/src/example3/example3.so
	-rm -f ./tyk/middleware/example.so
	-rm -f ./tyk/middleware/example2.so
	-rm -f ./tyk/middleware/example3.so
	-rm -f ./tyk/bundle/example/bundle.zip
	-rm -f ./tyk/bundle/example/example.so
	-rm -f ./tyk/bundle/example2/bundle.zip
	-rm -f ./tyk/bundle/example2/example2.so
	-rm -f ./tyk/bundle/example3/bundle.zip
	-rm -f ./tyk/bundle/example3/example3.so

# Restarts the Tyk Gateway to instantly load new iterations of the Go plugin
.PHONY: restart-gateway
restart-gateway:
	-docker-compose restart tyk-gateway