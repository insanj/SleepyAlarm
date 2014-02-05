THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = SleepyAlarm
SleepyAlarm_FILES = SleepyAlarm.xm
SleepyAlarm_FRAMEWORKS = UIKit
SleepyAlarm_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"