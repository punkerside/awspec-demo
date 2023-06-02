PROJECT            = awspec
ENV                = demo
AWS_DEFAULT_REGION = us-east-1

DOCKER_UID         = $(shell id -u)
DOCKER_GID         = $(shell id -g)
DOCKER_USER        = $(shell whoami)

token:
	@rm -rf /tmp/token.txt
	@aws sts get-session-token --duration-seconds 3600 --output json --region "${AWS_DEFAULT_REGION}" > /tmp/token.txt

parse: token
	$(eval AWS_ACCESS_KEY_ID = $(shell cat /tmp/token.txt | jq -r .Credentials.AccessKeyId))
	$(eval AWS_SECRET_ACCESS_KEY = $(shell cat /tmp/token.txt | jq -r .Credentials.SecretAccessKey))
	$(eval AWS_SESSION_TOKEN = $(shell cat /tmp/token.txt | jq -r .Credentials.SessionToken))

test: parse
	@echo '${DOCKER_USER}:x:${DOCKER_UID}:${DOCKER_GID}::/app:/sbin/nologin' > passwd
	@docker run --rm -u "${DOCKER_UID}":"${DOCKER_GID}" -v "${PWD}"/passwd:/etc/passwd:ro -v "${PWD}":/app \
	  -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
	  -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
	  -e AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}" \
	  -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
	punkerside/titan-image-awspec:latest