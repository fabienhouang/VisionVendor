
run:
	flutter run --no-build --dart-define=API_KEY=${GOOGLE_API_KEY}

run-web:
	flutter run -d web-server

build:
	flutter build --release

install:
	flutter install

get-pack:
	flutter packages get

upgrade-pack:
	flutter packages upgrade

doctor:
	flutter doctor

all:
	flutter run --dart-define=API_KEY=${GOOGLE_API_KEY}

release:
	flutter run --release --dart-define=API_KEY=${GOOGLE_API_KEY}