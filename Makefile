.RECIPEPREFIX +=
EXECUTABLE_NAME = Mothership-CLI
APP_NAME = mothership
INSTALL_PATH = /usr/local/bin/$(APP_NAME)

update:
	swift package --enable-prefetching update

build:
	swift build

install:
	cp -f .build/x86_64-apple-macosx10.10/debug/$(EXECUTABLE_NAME) $(INSTALL_PATH)

uninstall:
	rm -f $(INSTALL_PATH)
