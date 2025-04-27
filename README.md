# Digital-Scoreboard
Digital scoreboard with timer for your preferred sport

## INPUTS SECTION
## SCORE COUNTERS
## TIME COUNTERS
## OUTPUT SECTION
It's main purpouse is to display the data comming from counters to 7 Segment Displays.
The output section consists of _2 main elements:_ **Multiplexer** and **StateMachine**
Then there are _3 support elements:_ **Toggler**, **ClockEnable** and **bin2Seg**
### Main elements:
#### State Machine:
INPUTS:
- RST    # global reset
- CLK    # 100MHz clock
- EN     # event each 150us   
OUTPUTS:
- stateM # multiplexer switch signal
- stateA # 7 segment anodes control
- stateDP    # 7 decimal points control
INTERNAL SIGNALS:
- currentPos
- nextPos
This block is **_responsible for multiplexing_** the _7 segment_ display trough the _8 to 1 multiplexer_
It relies on the _clockEnable_ block as it's **_en_** input. it cycles trough it's predefined states _POS0 > POS7_, it changes the state on every _EN_ event.

The states of the FSM are stored in the internal signals _currentPos_ and _nextPos_.
According to the _currentPos_ signal, the outputs are then set. 




## Timer
This is a digital timer designed for a scoreboard, counting seconds and minutes, with the current time displayed across four 4-bit outputs. A clock enable block generates timing pulses from a 100 MHz clock, ensuring the counting speed is maintained at 1-second intervals. The counters are cascaded to handle digit overflows automatically, while a pause toggle and reset input allow the user to control the timer’s operation. The timer outputs the current time through four independent 4-bit signals, which are then connected to a multiplexer for further processing. The design outputs the current time value and indicates whether the timer is paused for further use in main design.   

<img width=75% height=75% src="https://github.com/user-attachments/assets/5b6d5d80-12ac-4ba3-bab7-55673a7db901">

Digital timer consist of clock_enable, pause_toggle, counter and counter_des


Maximum counting time set in code is 99 minutes 59 seconds, after overflowing timer automatically pause.  

**INPUTS**:
CLK100MHZ – Main clock input running at 100 MHz.\\
BTNC – Reset button input; resets the entire timer when pressed. 
BTNU – Pause button input; toggles the timer between running and paused states.

**OUTPUTS**:
COUNT0 – 4-bit output representing units of seconds (0–9).

COUNT1 – 4-bit output representing tens of seconds (0–5).

COUNT2 – 4-bit output representing units of minutes (0–9).

COUNT3 – 4-bit output representing tens of minutes (0–9).

PAUSE_STATE – Output indicating whether the timer is currently paused (logic high or low).

#### Simulation
![image](https://github.com/user-attachments/assets/4415f52f-59e8-4cbd-a26f-d592962f4106)
This is simulation of entire timer 

![image](https://github.com/user-attachments/assets/54729408-4635-4a97-b20a-f1715cf2846c)
![image](https://github.com/user-attachments/assets/ee8a0eda-792b-4cc2-ae3c-f5297e7885bf)

### Clock enable
---

#### Simulation
### **Counters**
---
#### Simulation
### **Enable logic**
---
#### Simulation



## Score

## Displaying data - 7 Segment Driver
