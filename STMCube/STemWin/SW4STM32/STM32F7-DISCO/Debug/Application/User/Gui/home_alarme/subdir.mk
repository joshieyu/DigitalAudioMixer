################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/jyepi/OneDrive/Desktop/Mixer\ Project/STMCube/STemWin/Gui/Core/home_alarme/home_alarm_win.c 

OBJS += \
./Application/User/Gui/home_alarme/home_alarm_win.o 

C_DEPS += \
./Application/User/Gui/home_alarme/home_alarm_win.d 


# Each subdirectory must supply rules for building sources it contributes
Application/User/Gui/home_alarme/home_alarm_win.o: C:/Users/jyepi/OneDrive/Desktop/Mixer\ Project/STMCube/STemWin/Gui/Core/home_alarme/home_alarm_win.c Application/User/Gui/home_alarme/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m7 -std=gnu11 -g3 -DSTM32F746xx -DUSE_HAL_DRIVER -DUSE_STM32746G_DISCOVERY -c -I../../../Gui/STemWin_Addons -I../../../Gui/Target -I../../../Config -I../../../Core/Inc -I../../../Utilities/CPU -I../../../Drivers/CMSIS/Device/ST/STM32F7xx/Include -I../../../Drivers/STM32F7xx_HAL_Driver/Inc -I../../../Drivers/STM32F7xx_HAL_Driver/Inc/Legacy -I../../../Drivers/BSP/STM32746G-Discovery -I../../../Drivers/BSP/Components -I../../../Drivers/BSP/Components/Common -I../../../Middlewares/ST/STM32_USB_Host_Library/Core/Inc -I../../../Middlewares/ST/STM32_USB_Host_Library/Class/MSC/Inc -I../../../Middlewares/ST/STM32_USB_Device_Library/Class/MSC/Inc -I../../../Middlewares/Third_Party/LwIP/src/include/ -I../../../Middlewares/Third_Party/LwIP/system -I../../../Middlewares/Third_Party/LwIP/system/OS -I../../../Middlewares/ST/STemWin/inc -I../../../Middlewares/Third_Party/FatFs/src -I../../../Middlewares/Third_Party/FatFs/src/drivers -I../../../Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1 -I../../../Middlewares/Third_Party/FreeRTOS/Source/include -I../../../Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS -I../../../Modules/Common -I../../../Modules/audio_player -I../../../Modules/audio_recorder -I../../../Modules/videoplayer -I../../../Modules/vnc_server -I../../../Drivers/CMSIS/Include -Os -ffunction-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Application/User/Gui/home_alarme/home_alarm_win.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Application-2f-User-2f-Gui-2f-home_alarme

clean-Application-2f-User-2f-Gui-2f-home_alarme:
	-$(RM) ./Application/User/Gui/home_alarme/home_alarm_win.cyclo ./Application/User/Gui/home_alarme/home_alarm_win.d ./Application/User/Gui/home_alarme/home_alarm_win.o ./Application/User/Gui/home_alarme/home_alarm_win.su

.PHONY: clean-Application-2f-User-2f-Gui-2f-home_alarme

