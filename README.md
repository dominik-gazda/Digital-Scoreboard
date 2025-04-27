# Digital-Scoreboard
Digital scoreboard with timer for your preferred sport

## INPUTS SECTION
## SCORE COUNTERS
## 4-BIT TIMERS

This is a digital timer designed for a scoreboard, counting seconds and minutes, with the current time displayed across four 4-bit outputs. A clock enable block generates timing pulses from a 100 MHz clock, ensuring the counting speed is maintained at 1-second intervals. The counters are cascaded to handle digit overflows automatically, while a pause toggle and reset input allow the user to control the timer’s operation. The timer outputs the current time through four independent 4-bit signals, which are then connected to a multiplexer for further processing. The design outputs the current time value and indicates whether the timer is paused for further use in main design.   

#### INPUTS:
- **CLK100MHZ** – Main clock input running at 100 MHz.
- **BTNC** – Reset button input; resets the entire timer when pressed. 
- **BTNU** – Pause button input; toggles the timer between running and paused states.

#### OUTPUTS:
- **COUNT0** – 4-bit output representing units of seconds (0–9).
- **COUNT1** – 4-bit output representing tens of seconds (0–5).
- **COUNT2** – 4-bit output representing units of minutes (0–9).
- **COUNT3** – 4-bit output representing tens of minutes (0–9).
- **PAUSE_STATE** – Output indicating whether the timer is currently paused.

Maximum counting time set in code is 99 minutes 59 seconds, after overflowing timer automatically pause.  

Schematic of design
<img width=75% height=75% src="https://github.com/user-attachments/assets/5b6d5d80-12ac-4ba3-bab7-55673a7db901">

#### Simulations of Digital Timer 

For better understanding of the simulation and since it's difficult to showcase the entire process at once, it is divided into three images. The first image shows the entire process from start to finish.


<img width=75% height=75% src="https://github.com/user-attachments/assets/7842978e-9953-4b33-93db-feb2377a95bc">
_Note: Cursor indicates time of 53 minutes and 23 seconds._ 


At the beginning, when the `reset` button is pressed, all counters are set to zero. The timer uses four counters in total: `count0`, `count2`, and `count3`, which count from 0 to 9, while `count1` counts the tens of seconds (from 0 to 5). Each time count0 overflows, it increments count1 by one. Similarly, when count1 overflows, it increments count2, and so on. When the `pause` button is pressed, it remains high until pressed again (`pause_state`), pausing the counting process. During the pause, all counters hold their last value. After the pause button is pressed again, the timer resumes counting and will automatically pause when it reaches the limit of 99 minutes and 99 seconds, without the requirement of pressing the pause button. The `clk` ensures that each increment of the counter takes exactly one second.



## OUTPUT SECTION
It's main purpouse is to display the data comming from counters to 7 Segment Displays.
The output section consists of _2 main elements:_ **Multiplexer** and **StateMachine**
Then there are _3 support elements:_ **Toggler**, **ClockEnable** and **bin2Seg**
### Main elements:
#### **State Machine:**
**RTL SCHEMATIC**
![SCH_stateMachine](https://github.com/user-attachments/assets/38a8e297-a9c3-4852-b8f7-2b267aeaaec7)

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

![SM_multiplex_0](https://github.com/user-attachments/assets/0cd92251-c3b6-4c42-9668-b2330da2ed0f)


The states of the FSM are stored in the internal signals _currentPos_ and _nextPos_.
According to the _currentPos_ signal, the outputs are then set.

**SIMULATION**
![SIM_stateMachine](https://github.com/user-attachments/assets/674893f3-4481-4f1a-9080-34706f7b2bda)

#### **Multiplexer:**

**RTL SCHEMATIC**
![SCH_8to1Multiplex](https://github.com/user-attachments/assets/0c6d76c4-8f5a-4b98-a6a6-c0ca1a23c8d4)

INPUTS:
- counter0 # input from corresponding counters
- counter1
- counter2
- counter3
- counter4
- counter5
- counter6
- counter7
- switch    # select input from StateMachine

OUTPUTS:
- output    # output counters data to bin2seg

This block is a simple multiplexer.

**SIMULATION**
![SIM_8to1Multiplex](https://github.com/user-attachments/assets/9f3d17fc-f20d-48a6-9503-88437e37a881)

#### **Toggler:**

**RTL SCHEMATIC**
![SCH_toggler](https://github.com/user-attachments/assets/ce96e6f7-7da8-4e23-9643-3239686ccc38)

INPUTS:
- clk
- rst
- clk_500
- pause

OUTPUTS:
- outp

This block interfaces with the _clear_ input of the _bi2seg_ block, if the input signal _pause_ is high, it generates a "clock" signal on it's output _outp_, the frequency of the clock is dependant on the _clk_500_ input, this has the practical effect of blinking the whole 7 segment display. 

**SIMULATION**

![SIM_toggler](https://github.com/user-attachments/assets/4f7636aa-7f65-4e02-94f2-b671230939d8)




## Timer
This is a digital timer designed for a scoreboard, counting seconds and minutes, with the current time displayed across four 4-bit outputs. A clock enable block generates timing pulses from a 100 MHz clock, ensuring the counting speed is maintained at 1-second intervals. The counters are cascaded to handle digit overflows automatically, while a pause toggle and reset input allow the user to control the timer’s operation. The timer outputs the current time through four independent 4-bit signals, which are then connected to a multiplexer for further processing. The design outputs the current time value and indicates whether the timer is paused for further use in main design.   

<img width=75% height=75% src="https://github.com/user-attachments/assets/5b6d5d80-12ac-4ba3-bab7-55673a7db901">

Digital timer consist of clock_enable, pause_toggle, counter and counter_des


Maximum counting time set in code is 99 minutes 59 seconds, after overflowing timer automatically pause.  

#### INPUTS:
- **CLK100MHZ** – Main clock input running at 100 MHz.
- **BTNC** – Reset button input; resets the entire timer when pressed. 
- **BTNU** – Pause button input; toggles the timer between running and paused states.

#### OUTPUTS:
- **COUNT0** – 4-bit output representing units of seconds (0–9).
- **COUNT1** – 4-bit output representing tens of seconds (0–5).
- **COUNT2** – 4-bit output representing units of minutes (0–9).
- **COUNT3** – 4-bit output representing tens of minutes (0–9).
- **PAUSE_STATE** – Output indicating whether the timer is currently paused.

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
