#include <EFM8LB1.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* Clock Frequency and Baud Rate */
// Baudrate of UART in BPS
#define SYSCLK 72000000
#define BAUDRATE 115200L
// Baudrate of UART in BPS
#define SARCLK 18000000L // SARCLK Frequency in Hz

#define MAX_16_BIT 65536.0 // 16-Bit Maximum Value
#define MAX_8_BIT 256.0 // 8-Bit Maximum Value

/* Define Pins */
#define EFM8_SIGNAL P1_0 // Signal to Measure

#define VSS 5 // The measured value of VSS in volts
#define VDD 3.3035 // The measured value of VDD in volts

void Timer3us(unsigned char us);
void waitms(unsigned int ms);