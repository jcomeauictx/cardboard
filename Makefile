# https://wiki.debian.org/AndroidTools/IntroBuildingApps
ANDROID_SDK_ROOT ?= /usr/lib/android-sdk
export
all: install accept hellocardboard-android.apk
install:
	sudo apt install git make android-sdk android-sdk-platform-23
accept:
	git clone https://github.com/Shadowstyler/android-sdk-licenses.git
	sudo cp -a android-sdk-licenses/*-license $(ANDROID_SDK_ROOT)/licenses
hellocardboard-android.apk: gradlew
	./$< build
