all:
	git submodule foreach git pull origin master
build:
	hugo --theme=abhicode
serve:
	hugo server --theme=abhicode --buildDrafts --watch