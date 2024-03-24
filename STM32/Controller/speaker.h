#define F_CPU 32000000L
// #define TICK_FREQ_TIM2 4096L
// #define TICK_FREQ_TIM2 5120L
#define TICK_FREQ_TIM2 8192L

void InitTimer2(void);
void ToggleSpeaker(void);
float ChangeSpeakerRatio(float current_ratio);
void ConfigSpeaker(float ratio);