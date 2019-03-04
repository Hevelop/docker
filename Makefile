CURRENT_BRANCH = 1.8
CURRENT_VERSION = 1.8.4
PREVIOUS_BRANCH = 1.7
PREVIOUS_VERSION = 1.7.3
PHP_VERSION = 7.2

COMPOSER_VERSION ?= $(CURRENT_VERSION)
COMPOSER_INSTALLER_URL ?= https://raw.githubusercontent.com/composer/getcomposer.org/cb19f2aa3aeaa2006c0cd69a7ef011eb31463067/web/installer
COMPOSER_INSTALLER_HASH ?= 48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5

.PHONY = all build test template

all: build test

build:
	docker build --no-cache --tag composer:php-$(PHP_VERSION)-$(CURRENT_BRANCH) --build-arg PHP_VERSION=$(PHP_VERSION) --tag composer:php-$(PHP_VERSION)-$(CURRENT_VERSION) --tag composer:php-$(PHP_VERSION)-1 --tag composer:php-$(PHP_VERSION)-latest $(CURRENT_BRANCH)
	docker build --no-cache --tag composer:php-$(PHP_VERSION)-$(PREVIOUS_BRANCH) --build-arg PHP_VERSION=$(PHP_VERSION) --tag composer:php-$(PHP_VERSION)-$(PREVIOUS_VERSION) $(PREVIOUS_BRANCH)

test:
	docker run --rm --tty composer:php-$(PHP_VERSION)-latest --no-ansi | grep 'Composer version $(CURRENT_VERSION)'
	docker run --rm --tty composer:php-$(PHP_VERSION)-1 --no-ansi | grep 'Composer version $(CURRENT_VERSION)'
	docker run --rm --tty composer:php-$(PHP_VERSION)-$(CURRENT_BRANCH) --no-ansi | grep 'Composer version $(CURRENT_VERSION)'
	docker run --rm --tty composer:php-$(PHP_VERSION)-$(PREVIOUS_BRANCH) --no-ansi | grep 'Composer version $(PREVIOUS_VERSION)'

template:
	@sed --env 's@%COMPOSER_VERSION%@$(COMPOSER_VERSION)@' \
	    --env 's@%COMPOSER_INSTALLER_URL%@$(COMPOSER_INSTALLER_URL)@' \
	    --env 's@%COMPOSER_INSTALLER_HASH%@$(COMPOSER_INSTALLER_HASH)@' \
	    Dockerfile.template
