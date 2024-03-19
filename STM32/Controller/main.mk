SHELL=cmd
CC=arm-none-eabi-gcc # Need Added to Path
AS=arm-none-eabi-as # Need Added to Path
LD=arm-none-eabi-ld # Need Added to Path
CCFLAGS=-mcpu=cortex-m0 -mthumb -g

# Search for the path of the right libraries.  Works only on Windows.
GCCPATH=$(subst \bin\arm-none-eabi-gcc.exe,\,$(shell where $(CC)))
LIBPATH1=$(subst \libgcc.a,,$(shell dir /s /b "$(GCCPATH)*libgcc.a" | find "v6-m"))
LIBPATH2=$(subst \libc_nano.a,,$(shell dir /s /b "$(GCCPATH)*libc_nano.a" | find "v6-m"))
LIBSPEC=-L"$(LIBPATH1)" -L"$(LIBPATH2)"

OBJS=main.o startup.o serial.o UART2.o JDY40.o lcd.o adc.o speaker.o movement.o newlib_stubs.o

# Notice that floating point is enabled with printf (-u _printf_float)
main.hex: $(OBJS)
	$(LD) $(OBJS) $(LIBSPEC) -Os -u _printf_float -nostdlib -lnosys -lgcc -T ../Common/LDscripts/stm32l051xx.ld --cref -Map main.map -o main.elf
	arm-none-eabi-objcopy -O ihex main.elf main.hex
	@echo Success!

main.o: main.c speaker.h lcd.h adc.h movement.h JDY40.h UART2.h
	$(CC) -c $(CCFLAGS) main.c -o main.o

adc.o: adc.c adc.h
	$(CC) -c $(CCFLAGS) adc.c -o adc.o

lcd.o: lcd.c lcd.h
	$(CC) -c $(CCFLAGS) lcd.c -o lcd.o

speaker.o: speaker.c speaker.h
	$(CC) -c $(CCFLAGS) speaker.c -o speaker.o

movement.o: movement.c movement.h
	$(CC) -c $(CCFLAGS) movement.c -o movement.o

JDY40.o: JDY40.c JDY40.h UART2.h
	$(CC) -c $(CCFLAGS) JDY40.c -o JDY40.o

UART2.o: UART2.c UART2.h
	$(CC) -c $(CCFLAGS) UART2.c -o UART2.o

startup.o: ../Common/Source/startup.c
	$(CC) -c $(CCFLAGS) -DUSE_USART1 ../Common/Source/startup.c -o startup.o

serial.o: ../Common/Source/serial.c
	$(CC) -c $(CCFLAGS) ../Common/Source/serial.c -o serial.o

newlib_stubs.o: ../Common/Source/newlib_stubs.c
	$(CC) -c $(CCFLAGS) ../Common/Source/newlib_stubs.c -o newlib_stubs.o

clean:
	@del $(OBJS) 2>NUL
	@del main.elf main.hex main.map 2>NUL

Load_Flash: main.hex
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	@echo ..\stm32flash\stm32flash -w main.hex -v -g 0x0 ^^>loadf.bat
	@..\stm32flash\BO230\BO230 -b >>loadf.bat
	@loadf
	@echo cmd /c start putty.exe -sercfg 115200,8,n,1,N -serial ^^>sputty.bat
	@..\stm32flash\BO230\BO230 -r >>sputty.bat
	@sputty

putty:
	@taskkill /f /im putty.exe /t /fi "status eq running" > NUL
	@echo cmd /c start putty.exe -sercfg 115200,8,n,1,N -serial ^^>sputty.bat
	@..\stm32flash\BO230\BO230 -r >>sputty.bat
	@sputty

explorer:
	@explorer .

dummy: main.map main.hex
	@echo Hello from 'dummy' target...
