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
Schematic of the timer design for measuring playtime in minutes and seconds. 
![image](https://github.com/user-attachments/assets/5b6d5d80-12ac-4ba3-bab7-55673a7db901)

#### Simulation
![image](https://github.com/user-attachments/assets/4415f52f-59e8-4cbd-a26f-d592962f4106)
![image](https://github.com/user-attachments/assets/d098789d-ccac-4182-b0be-075da53e008d)
![image](https://github.com/user-attachments/assets/ee8a0eda-792b-4cc2-ae3c-f5297e7885bf)

#### Clock enable
---


#### **Counter**
---

#### **Top level**
---



## Score

## Displaying data - 7 Segment Driver
