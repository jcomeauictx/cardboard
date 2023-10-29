# https://wiki.debian.org/AndroidTools/IntroBuildingApps
#REAL_ANDROID_SDK ?= /usr/lib/android-sdk
REAL_ANDROID_SDK ?= $(HOME)/Downloads/adt-bundle-linux-x86_64-20130717/sdk
ANDROID_SDK_ROOT := android-sdk
LICENSES = $(wildcard $(ANDROID_SDK_ROOT)/licenses/*-license)
NDK := $(ANDROID_SDK_ROOT)/ndk
OVLTMP := overlay.tmp
OVLWRK := overlay.work
APP := hellocardboard-android
DEBUGLIBS := $(APP)/build/intermediates/cmake/debug/obj/armeabi-v7a/
LIBCARDBOARD := $(DEBUGLIBS)/libcardboard_jni.so
RELEASE := $(APP)/build/outputs/apk/release
DEBUG := $(APP)/build/outputs/apk/debug
APK := $(DEBUG)/$(APP)-debug.apk
UNSIGNED := $(RELEASE)/$(APP)-release-unsigned.apk
SDKMANAGER := $(ANDROID_SDK_ROOT)/tools/bin/sdkmanager.commandlinetools
export
all: install $(NDK) accept $(APK)
install:
	sudo apt install git make android-sdk android-sdk-platform-23
accept: android-sdk-licenses $(ANDROID_SDK_ROOT)/licenses
	yes | $(SDKMANAGER) --sdk_root=$(ANDROID_SDK_ROOT) --licenses
	[ "$(LICENSES)" ] || sudo cp -a $</*-license $(word 2, $+)
android-sdk-licenses:
	git clone https://github.com/Shadowstyler/android-sdk-licenses.git
$(LIBCARDBOARD): gradlew
	./$< sdk:assemble
$(APK): gradlew $(LIBCARDBOARD)
	./$< build
$(OVLTMP) $(OVLWRK) $(ANDROID_SDK_ROOT):
	mkdir $@
env:
	$@
$(NDK): $(ANDROID_SDK_ROOT) $(OVLTMP) $(OVLWRK)
	[ -d "$@" ] || sudo mount -t overlay overlay \
	 -olowerdir=$(REAL_ANDROID_SDK),upperdir=$(OVLTMP),workdir=$(OVLWRK) \
	 $(ANDROID_SDK_ROOT)
umount: $(ANDROID_SDK_ROOT)
	sudo umount $<
tasks projects: gradlew
	./$< $@
clean: gradlew umount
	./$< $@
apkinstall: $(APK)
	adb install $<
