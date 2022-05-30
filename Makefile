# https://wiki.debian.org/AndroidTools/IntroBuildingApps
ANDROID_SDK_ROOT ?= /usr/lib/android-sdk
LICENSES = $(wildcard $(ANDROID_SDK_ROOT)/licenses/*-license)
export
all: install accept hellocardboard-android.apk
install:
	sudo apt install git make android-sdk android-sdk-platform-23
accept: android-sdk-licenses $(ANDROID_SDK_ROOT)/licenses
	[ "$(LICENSES)" ] || sudo cp -a $</*-license $(word 2, $+)
android-sdk-licenses:
	git clone https://github.com/Shadowstyler/android-sdk-licenses.git
hellocardboard-android.apk: gradlew
	./$< build
env:
	$@
