
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

adb:
	adb connect 192.168.1.28:44783

all:
	flutter run --dart-define=API_KEY=${GOOGLE_API_KEY}