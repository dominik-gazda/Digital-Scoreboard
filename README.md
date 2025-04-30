# Digital-Scoreboard
Digital scoreboard with timer for your preferred sport
![image](https://github.com/user-attachments/assets/854290e6-9fcd-4b49-a915-b066e36d47ce)


https://github.com/user-attachments/assets/b2d13675-147e-4c68-bfc5-1ffb16f01535

## INPUTS SECTION
The inputs section is only a _debouncer block_ consisting of 6 D-latches and one AND gate.
It's purpouse is to delay the input signal from the buttons, which have a heavy load of jitter signal.

_RTL Schematic_
![image](https://github.com/user-attachments/assets/a18fb523-01ff-4802-bd25-72c33bf544ef)

**Simulation**
![image](https://github.com/user-attachments/assets/802121aa-aedd-4885-b96f-5ebe7343d429)

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
This component is a 4-bit counter that increments on each clock cycle when enabled (`en`). When it reaches 9, it overflows, resets to 0, and generates a `carry` signal. The counter can be reset using the `rst` input. The current value is output as the `count` signal, and the `carry` signal indicates an overflow.

<img width=80% height=80% src="https://github.com/user-attachments/assets/80b64a36-96e1-43eb-bb8e-a1eba22586b7">

---

#### counter_des (counter1)
`counter_des` works same way as the counter, but it overflows after reaching a value of 5 (:59 seconds --> :00 seconds)

<img width=80% height=80% src="https://github.com/user-attachments/assets/51e5e277-ee3a-443f-9d79-f8386234a7f4">


## SCORE COUNTERS

This is a digital score counter designed for a two-team scoreboard, managing values through two 4-bit outputs (`cnt1_out`, `cnt2_out`). The counters are paired per team, with each pair combining to represent scores up to 99. Overflow handling ensures seamless rollover to 00 after reaching the maximum value. Score adjustments cascade through counters, and the final values are transformed into 7-segment display signals using a multiplexer. Both teams’ counters operate independently, with their states preserved until manually reset or overflowed.

![top level synlogic a counter logic](https://github.com/user-attachments/assets/2b7f7cea-5691-4e7c-9d1b-a8a68f66db96)
_Schematic of Score Counter design._

#### INPUTS:
- **CLK** - Main clock input running at 100 MHz.
- **RST** - Reset button input; resets the score of both teams when pressed.
- **SW** - Switch input, when the switch is set to 0, pressing the BTN adds the score, when is set to 1 score gets decresed by pressing BTN
- **BTN** - Button input, by pressing it will increse or decrese value of score of one of the teams. Each team have its own button

#### OUTPUTS:
- **cnt1_out** - 4-bit output represents units of the team's score 
- **cnt2_out** - 4-bit output represents tens of the team's score

### SyncLogic 
![schema sync logic](https://github.com/user-attachments/assets/2a308dca-5c14-4cb1-9069-99d8d839f995)
_Schematic of Sync Logic design._

`SyncLogic` is necessary to ensure that the button (`BTN`) and switch (`SW`) inputs are correctly captured on the clock edge (`CLK`). This prevents problems such as unstable signals and random errors when reading the inputs. For the button, it also stores the current (`BTN_SYNC`) and previous (`BTN_PREV`) states, allowing detection of a new press. The switch (`SW`) is also synchronized (`SW_SYNC`) to ensure that its position changes are reliably read.


### Simulation of Sync Logic
![Snímek obrazovky 2025-04-28 195340](https://github.com/user-attachments/assets/39668b53-e66d-49c9-b8b0-059721fc0536)

At the beginning, all signals are in an idle state (0). At 50 ns, the button (`BTN`) is pressed, and on the next clock edge at 60 ns, `BTN_SYNC` updates to 1. The button is released at 70 ns, and at 80 ns, `BTN_SYNC` returns to 0 while `BTN_PREV` updates to 1. The switch (`SW`) is turned on between 90–100 ns, and `SW_SYNC` updates to 1 at 100 ns. After `SW` returns to 0 at 140 ns, `SW_SYNC` also resets to 0 at 150 ns. Finally, at 160 ns, the button is pressed again, and at 170 ns, `BTN_SYNC` reflects the change while `BTN_PREV` shows the previous state.


### Counter Logic:
`counterLogic` is needed to count operation based on the synchronized button and switch inputs. It increments or decrements the counter values according to the switch setting (`SW_SYNC`) when a button press (`BTN_SYNC`) is detected.


### Simulation of Counter Logic
![Snímek obrazovky 2025-04-28 185355](https://github.com/user-attachments/assets/94f15315-7e41-4e9c-abb6-494948c82583)

When the button (`BTN_SYNC`) is pressed while the switch (`SW_SYNC`) is set for counting up. Therefore, with each rising edge of the clock (`CLK`), the first counter (`CNT1_OUT`) increments by 1, starting from 0. When `CNT1_OUT` exceed more then 9 come into oveflow it resets to 0 and the second counter (`CNT2_OUT`) increments by 1. When we change (`SW_SYNC`) to 1 walue starts decresing to 0.


### Simulation of Overflowed CNT1_OUT
![přetečení counteru 1](https://github.com/user-attachments/assets/9dce0cf3-b1c1-47ae-9871-bbfaa7d8d70f)
This simulation shows what happends when `CNT1_OUT` overflow.


### Simulation Decresing CNT1_OUT and CNT2_OUT after overflow
![odčítání s přetečením ](https://github.com/user-attachments/assets/ffe77bd1-d16e-4c51-b09e-247583d1bc5b)
This simulation shows `CNT1_OUT` overrflows to `CNT2_OUT`, then we set `SW` on (1) to decrese values back to 0.


### Simulation with using RST button
![restart ](https://github.com/user-attachments/assets/7d65bf1f-c73f-4efd-9b2a-c57a1c3665d2)
This simulation show what happends when we set `RST` to (1). In the moment on next rising edge of `CLK` are values of `CNT1_OUT` and `CNT2_OUT` is immediately sett to 0.


## OUTPUT SECTION
It's main purpouse is to display the data comming from counters to 7 Segment Displays.
The output section consists of _2 main elements:_ **Multiplexer** and **StateMachine**
Then there are _3 support elements:_ `Toggler`, `ClockEnable` and `bin2Seg`
### Main elements:
#### **State Machine:**
_RTL SCHEMATIC_
![SCH_stateMachine](https://github.com/user-attachments/assets/38a8e297-a9c3-4852-b8f7-2b267aeaaec7)


#### INPUTS:
- **RST** - Global reset
- **CLK** - 100MHz clock
- **EN**  - Event each 150us
   
#### OUTPUTS:
- **stateM**  - Multiplexer switch signal
- **stateA**  - Segment anodes control
- **stateDP** - 7 Decimal points control

#### INTERNAL SIGNALS:
- `currentPos`
- `nextPos`

This block is **responsible for multiplexing** the _7 segment_ display trough the _8 to 1 multiplexer_
It relies on the `clockEnable` block as it's `en` input. it cycles trough it's predefined states `POS0 > POS7`, it changes the state on every `EN` event.

![SM_multiplex_0](https://github.com/user-attachments/assets/0cd92251-c3b6-4c42-9668-b2330da2ed0f)


The states of the FSM are stored in the internal signals `currentPos` and `nextPos`.
According to the `currentPos` signal, the outputs are then set.

#### Simulation
![SIM_stateMachine](https://github.com/user-attachments/assets/674893f3-4481-4f1a-9080-34706f7b2bda)

#### **Multiplexer**:

_RTL SCHEMATIC_
![SCH_8to1Multiplex](https://github.com/user-attachments/assets/0c6d76c4-8f5a-4b98-a6a6-c0ca1a23c8d4)

#### INPUTS:
- `counter0` - Input from corresponding counters
- `counter1`
- `counter2`
- `counter3`
- `counter4`
- `counter5`
- `counter6`
- `counter7`
- `switch`    - Select input from StateMachine

#### OUTPUTS:
- `output`    - Output counters data to bin2seg

_This block is a simple multiplexer._

#### Simulation
![SIM_8to1Multiplex](https://github.com/user-attachments/assets/9f3d17fc-f20d-48a6-9503-88437e37a881)

#### Toggler:

**RTL SCHEMATIC**
![SCH_toggler](https://github.com/user-attachments/assets/ce96e6f7-7da8-4e23-9643-3239686ccc38)

#### INPUTS:
- `clk`
- `rst`
- `clk_500`
- `pause`

#### OUTPUTS:
- `outp`

This block interfaces with the _clear_ input of the _bi2seg_ block, if the input signal `pause` is high, it generates a "clock" signal on it's output `outp`, the frequency of the clock is dependant on the `clk_500` input, this has the practical effect of blinking the whole 7 segment display. 

#### Simulation

![SIM_toggler](https://github.com/user-attachments/assets/4f7636aa-7f65-4e02-94f2-b671230939d8)

# Disclaimer
This project was created using `Vivado Version: 2024.2`
During the creation of this project, Generative Artificial Inteligence has been used for code autocompletition (Github Copilot), and references.

# Team members and their respective work:
- **Gazda**: Time counters section
- **Dzurus**: Output section, Debouncing, Top Level
- **Gomba, Hedbavny**: Score counters section

