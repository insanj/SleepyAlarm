TARGET =: clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SleepyAlarmPrefs 
SleepyAlarmPrefs_FILES = SLListController.xm $(wildcard *.m)
SleepyAlarmPrefs_INSTALL_PATH = /Library/PreferenceBundles
SleepyAlarmPrefs_FRAMEWORKS = UIKit Twitter CoreGraphics MessageUI QuartzCore
SleepyAlarmPrefs_PRIVATE_FRAMEWORKS = Preferences BulletinBoard

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SleepyAlarmPrefs.plist$(ECHO_END)
