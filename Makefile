ARCHS = arm64
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SoulKnightPrequel

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GiamDoHoaSKP
GiamDoHoaSKP_FILES = Tweak.xm
GiamDoHoaSKP_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
