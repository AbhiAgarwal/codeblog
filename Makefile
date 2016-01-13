all:
	git submodule foreach git pull origin master
build:
	hugo --theme=abhicode
server:
	hugo server --theme=abhicode --buildDrafts --watch