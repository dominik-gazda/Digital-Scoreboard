# Digital-Scoreboard
Digital scoreboard with timer for your preferred sport

## INPUTS SECTION
## SCORE COUNTERS
## TIMER
This is a digital timer designed for a scoreboard, displaying the current time across four 4-bit outputs. A clock enable block generates timing pulses from a 100 MHz clock, maintaining a 1-second interval for counting. The counters are cascaded to handle digit overflows automatically, while a pause toggle and reset input allow user control. The timer outputs the current time through four independent 4-bit signals, which are then connected to a multiplexer for further processing. 

<img width=80% height=80% src="https://github.com/user-attachments/assets/5b6d5d80-12ac-4ba3-bab7-55673a7db901">\
_Schematic of timer design._

#### INPUTS:
- **CLK100MHZ** – Main clock input running at 100 MHz.
- **BTNC** – Reset button input; resets the entire timer when pressed. 
- **BTNU** – Pause button input; toggles the timer between active and paused states.

#### OUTPUTS:
- **COUNT0** – 4-bit output representing units of seconds (0–9).
- **COUNT1** – 4-bit output representing tens of seconds (0–5).
- **COUNT2** – 4-bit output representing units of minutes (0–9).
- **COUNT3** – 4-bit output representing tens of minutes (0–9).
- **PAUSE_STATE** – Output indicating whether the timer is currently paused.

Maximum counting time is set to 99 minutes 59 seconds, after overflowing timer automatically pause.  

### Simulation of digital timer 

<img width=80% height=80% src="https://github.com/user-attachments/assets/7842978e-9953-4b33-93db-feb2377a95bc">\
_Note: Cursor indicates time of 53 minutes and 23 seconds._ 

At the beginning, when the `reset` button is pressed, all counters are set to zero. The timer uses four counters in total: `count0`, `count2`, and `count3`, which count from 0 to 9, while `count1` counts the tens of seconds (from 0 to 5). Each time `count0` overflows, it increments `count1` by one. Similarly, when `count1` overflows, it increments `count2`, and so on. When the `pause` button is pressed, it remains high until pressed again (`pause_state`), pausing the counting process. During the pause, all counters hold their last value. After the pause button is pressed again, the timer resumes counting and will automatically pause when it reaches the limit of 99 minutes and 99 seconds, without the requirement of pressing the pause button. The `clk` ensures that each increment of the counter takes exactly one second.


### Simulations of components in digital timer

Digital timer consist of five components:
- `clock_enable`,
- `pause_toggle`,
- `enable_logic`,
- `counter` and `counter_des`
---
#### clock_enable
A `pulse` is generated every second, synchronized with the rising edge of the clock.

<img width=80% height=80% src="https://github.com/user-attachments/assets/d8c5e9e6-fce9-4680-88f8-d72387ee9a7e">
---

#### pause_toggle
This component toggles the `pause_out` signal based on the `btn_pause` input. It detects when the button is pressed to switch between paused and active state, holding the state until the button is pressed again.

<img width=80% height=80% src="https://github.com/user-attachments/assets/1a5bc372-2564-4614-9072-24e384f9456c">

---

#### enable_logic
Enable logic controls the `enable_out` and `auto_pause` signals based on several inputs. It activates `enable_out` when the `pulse` is active and neither `pause` nor `auto_pause` is triggered. The `auto_pause` signal is set when `carry3` is high (indicating the last counter overflow) and can be reset by the `rst` input. The state of `auto_pause` remains until a reset or overflow happens.

<img width=80% height=80% src="https://github.com/user-attachments/assets/b357a521-029a-4c5c-816f-47949b865cd9">

---

#### counter (counter0,2,3)
This component is a 4-bit counter that increments on each clock cycle when enabled (`en`). When it reaches 9, it overflows, resets to 0, and generates a `carry` signal. The counter can be reset using the `rst` input. The current value is output as the `count` signal, and the `carry` signal indicates an overflow.\

<img width=80% height=80% src="https://github.com/user-attachments/assets/80b64a36-96e1-43eb-bb8e-a1eba22586b7">

---

#### counter_des (counter1)
`counter_des` works same way as the counter, but it overflows after reaching a value of 5 (:59 seconds --> :00 seconds)\

<img width=80% height=80% src="https://github.com/user-attachments/assets/51e5e277-ee3a-443f-9d79-f8386234a7f4">

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




