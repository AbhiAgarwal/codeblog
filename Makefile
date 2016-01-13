all:
	git submodule foreach git pull origin master
build:
	hugo --theme=cocoa
server:
	hugo server --theme=cocoa --buildDrafts --watch