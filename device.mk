#
# Copyright 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/google/walleye

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi

PRODUCT_HARDWARE := walleye

# To build walleye specific modules e.g. librecovery_ui_walleye.
PRODUCT_SOONG_NAMESPACES += device/google/walleye

DEVICE_PACKAGE_OVERLAYS += device/google/walleye/overlay

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=420

# Audio XMLs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_tavil.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_tavil.xml \
    $(LOCAL_PATH)/configs/audio/audio_platform_info_tavil.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info_tavil.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml

# Bug 62375603
PRODUCT_PROPERTY_OVERRIDES += audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1

# Whether by default, the eSIM system UI, including that in SUW and Settings, will be shown.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += esim.enable_esim_system_ui_by_default=false

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# Enable SM log mechanism by default
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.smlog_switch=1 \
    ro.radio.log_prefix="modem_log_" \
    ro.radio.log_loc="/data/vendor/modem_dump"

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.logging.userdebug.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).logging.rc
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.logging.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).logging.rc
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init-walleye.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init-$(PRODUCT_HARDWARE).rc \
    $(LOCAL_PATH)/rootdir/etc/init.walleye.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_HARDWARE).usb.rc \
    $(LOCAL_PATH)/rootdir/etc/init.insmod.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.cfg \
    $(LOCAL_PATH)/rootdir/etc/init.insmod_charger.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod_charger.cfg

# Input device files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/synaptics_dsxv26.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/synaptics_dsxv26.idc

include device/google/wahoo/device.mk

PRODUCT_COPY_FILES += \
    device/google/walleye/configs/nfc/libnfc-nxp.muskie.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf

PRODUCT_COPY_FILES += \
    device/google/walleye/configs/thermal/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf \
    device/google/walleye/configs/thermal/thermal-engine-vr.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine-vr.conf

# Thermal HAL
PRODUCT_COPY_FILES += \
    device/google/walleye/configs/thermal/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

PRODUCT_COPY_FILES += \
    device/google/walleye/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Wifi configuration file
PRODUCT_COPY_FILES += \
    device/google/walleye/configs/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/qca_cld/WCNSS_qcom_cfg.ini

#IMU calibration
PRODUCT_PROPERTY_OVERRIDES += \
  persist.config.calibration_fac=/persist/sensors/calibration/calibration.xml

# NFC/camera interaction workaround - DO NOT COPY TO NEW DEVICES
PRODUCT_PROPERTY_OVERRIDES += \
    ro.camera.notify_nfc=1

PRODUCT_CHECK_ELF_FILES := true
