# https://wiki.debian.org/AndroidTools/IntroBuildingApps
REAL_ANDROID_SDK ?= /usr/lib/android-sdk
ANDROID_SDK_ROOT := android-sdk
LICENSES = $(wildcard $(ANDROID_SDK_ROOT)/licenses/*-license)
NDK := $(ANDROID_SDK_ROOT)/ndk
OVLTMP := overlay.tmp
OVLWRK := overlay.work
export
all: install $(NDK) accept hellocardboard-android.apk
install:
	sudo apt install git make android-sdk android-sdk-platform-23
accept: android-sdk-licenses $(ANDROID_SDK_ROOT)/licenses
	[ "$(LICENSES)" ] || sudo cp -a $</*-license $(word 2, $+)
android-sdk-licenses:
	git clone https://github.com/Shadowstyler/android-sdk-licenses.git
hellocardboard-android.apk: gradlew
	#./$< assemble
	gradle assemble
$(OVLTMP) $(OVLWRK) $(ANDROID_SDK_ROOT):
	mkdir $@
env:
	$@
$(NDK): $(ANDROID_SDK_ROOT) $(OVLTMP) $(OVLWRK)
	[ -d "$@" ] || sudo mount -t overlay overlay \
	 -olowerdir=$(REAL_ANDROID_SDK),upperdir=$(OVLTMP),workdir=$(OVLWRK) \
	 $(ANDROID_SDK_ROOT)
