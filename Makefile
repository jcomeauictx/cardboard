# https://wiki.debian.org/AndroidTools/IntroBuildingApps
REAL_ANDROID_SDK ?= /usr/lib/android-sdk
ANDROID_SDK_ROOT := sdk
LICENSES = $(wildcard $(ANDROID_SDK_ROOT)/licenses/*-license)
NDK := $(ANDROID_SDK_ROOT)/ndk
export
all: install $(NDK) accept hellocardboard-android.apk
install:
	sudo apt install git make android-sdk android-sdk-platform-23
accept: android-sdk-licenses $(ANDROID_SDK_ROOT)/licenses
	[ "$(LICENSES)" ] || cp -a $</*-license $(word 2, $+)
android-sdk-licenses:
	git clone https://github.com/Shadowstyler/android-sdk-licenses.git
hellocardboard-android.apk: gradlew
	./$< build
tmp work $(ANDROID_SDK_ROOT):
	mkdir $@
env:
	$@
$(NDK): $(ANDROID_SDK_ROOT)
	[ -d "$@" ] || sudo mount -t overlay overlay \
	 -olowerdir=$(REAL_ANDROID_SDK),upperdir=tmp,workdir=work \
	 $(ANDROID_SDK_ROOT)
