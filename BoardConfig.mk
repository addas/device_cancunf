#
# Copyright (C) 2024 ArrowOS
# Copyright (C) 2024 PixelOS
#
# SPDX-License-Identifier: Apache-2.0
#


DEVICE_PATH := device/motorola/cancunf
KERNEL_PATH := device/motorola/cancunf-kernel

# For building with aosp manifest
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_PREBUILT_ELF_FILES := true
BUILD_BROKEN_DUP_RULES := true

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot
BOARD_USES_RECOVERY_AS_BOOT := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := 
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# VINTF
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := cancunf
TARGET_NO_BOOTLOADER := true

# Board Info
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt

# Display
TARGET_SCREEN_DENSITY := 400

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/configs/mot_aids.fs

## vendor_boot modules
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules/modules.load.vendor_boot))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/modules/vendor_boot/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))

## recovery modules
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules/modules.load.recovery))
RECOVERY_MODULES := $(addprefix $(KERNEL_PATH)/modules/vendor_boot/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))

## Prevent duplicated entries (to solve duplicated build rules problem)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))

## vendor_dlkm modules
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/modules/modules.load.vendor_dlkm))
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/modules/vendor_dlkm/*.ko)


# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6855
PRODUCT_COPY_FILES += \
	$(DEVICE_PATH)/recovery/root/fstab.mt6855:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6855

TARGET_RECOVERY_INITRC := $(DEVICE_PATH)/recovery/root/init.recovery.mt6855.rc

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true
# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2024-09-01
# SKU
ODM_MANIFEST_SKUS += b d de dn e n
ODM_MANIFEST_B_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_b.xml
ODM_MANIFEST_D_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_d.xml
ODM_MANIFEST_DE_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_de.xml
ODM_MANIFEST_DN_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_dn.xml
ODM_MANIFEST_E_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_e.xml
ODM_MANIFEST_N_FILES := $(DEVICE_PATH)/configs/vintf/sku/manifest_n.xml




# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(DEVICE_PATH)/configs/vintf/device_framework_compatibility_matrix.xml \
    hardware/mediatek/vintf/mediatek_framework_compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml

# Kernel
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_OFFSET := 0x40000000
BOARD_KERNEL_PAGESIZE := 0x00001000
BOARD_TAGS_OFFSET := 0x47c80000
BOARD_RAMDISK_OFFSET := 0x66f00000
BOARD_RAMDISK_USE_LZ4 := true

BOARD_MKBOOTIMG_ARGS += \
    --dtb_offset $(BOARD_TAGS_OFFSET) \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_TAGS_OFFSET)

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_NO_KERNEL_OVERRIDE := true
TARGET_KERNEL_SOURCE := device/motorola/cancunf-kernel/kernel-headers

LOCAL_KERNEL := $(KERNEL_PATH)/$(BOARD_KERNEL_IMAGE_NAME)
PRODUCT_COPY_FILES += \
    $(KERNEL_PATH)/$(BOARD_KERNEL_IMAGE_NAME):kernel

#BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtb
#BOARD_MKBOOTIMG_ARGS += --dtb $(BOARD_PREBUILT_DTBIMAGE_DIR)/mt6855.dtb
#BOARD_USES_GENERIC_KERNEL_IMAGE := true


# Kernel Bases
BOARD_KERNEL_BASE := 0x00000000
BOARD_VENDOR_BASE := 0x40078000
# Kernel
BOARD_BOOTIMG_HEADER_VERSION := 3
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.bootdevice=11270000.ufshci buildvariant=user
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_KERNEL_ADDITIONAL_FLAGS := DTC_EXT=$(shell pwd)/prebuilts/misc/linux-x86/dtc/dtc
TARGET_KERNEL_CLANG_COMPILE := true
NEED_KERNEL_MODULE_RECOVERY := true

# Kernel - prebuilt
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_INCLUDE_DTB_IN_BOOTIMG := 
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_KERNEL_SEPARATED_DTBO := 
endif

BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)

BOARD_EROFS_PCLUSTER_SIZE := 262144
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_PRODUCT := product

BOARD_DTBOIMG_PARTITION_SIZE := 250768

BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := motorola_dynamic_partitions
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor vendor_dlkm product
BOARD_MOTOROLA_DYNAMIC_PARTITIONS_SIZE := 6471811072

BOARD_USES_METADATA_PARTITION := true


# Platform
BOARD_HAS_MTK_HARDWARE := true
TARGET_BOARD_PLATFORM := mt6855
TARGET_USES_UEFI := true

# Properties
BOARD_USES_SYSTEM_EXTIMAGE := true
BOARD_USES_PRODUCTIMAGE := true
BOARD_EXT4_SHARE_DUP_BLOCKS := true
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_ODM_DLKM_PROP += $(DEVICE_PATH)/odm_dlkm.prop
TARGET_VENDOR_DLKM_PROP += $(DEVICE_PATH)/vendor_dlkm.prop

# Workaround for error copying vendor files to recovery ramdisk
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4


TARGET_USERIMAGES_USE_F2FS := true

#BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888


BOARD_RECOVERY_IMAGE := $(DEVICE_PATH)/recovery.img

# AVB - Verified Boot
BOARD_AVB_VBMETA_SYSTEM := system product system_ext
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2
BOARD_AVB_BOOT_ROLLBACK_INDEX := 1


# Dynamic Partition sizes
BOARD_DYNAMIC_PARTITIONS_SIZE := 6471811072
BOARD_DYNAMIC_PARTITIONS_FILE_SYSTEM_TYPE := erofs

# Inherit the proprietary files
#include vendor/motorola/cancunf/BoardConfigVendor.mk
#include vendor/motorola/cancunf-motcamera/BoardConfigVendor.mk

# Wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_DRIVER_FW_PATH_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_FW_PATH_STA := "STA"
WIFI_DRIVER_FW_PATH_AP := "AP"
WIFI_DRIVER_FW_PATH_P2P := "P2P"
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wmtWifi"
WIFI_DRIVER_STATE_ON := "1"
WIFI_DRIVER_STATE_OFF := "0"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true



# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)



# TWRP Configuration
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true
TW_DEVICE_VERSION := v1_beta-bm0x
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
BOARD_HAS_NO_SELECT_BUTTON := true
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_EXCLUDE_TWRPAPP := true
TW_BACKUP_EXCLUSIONS := /data/fonts
TW_HAS_NO_RECOVERY_PARTITION := true
# Same as above, for CPU Temperature
TW_NO_CPU_TEMP := true

# Device
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_DEFAULT_BRIGHTNESS := 600
TW_MAX_BRIGHTNESS := 1200
TW_FRAMERATE := 120
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.usb0/lun.%d/file
TW_EXCLUDE_APEX := true

# Sepolicy
#include device/mediatek/sepolicy_vndr/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public


