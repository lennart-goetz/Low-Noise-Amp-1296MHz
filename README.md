# Low-Noise-Amp-1296MHz
This project is part of my Bachelors Thesis to finish my degree in electrical engineering. 

At our institution we already have a parabolic antenna for 23cm waves installed. In the future we aim to do a "moon bounce". 
That means sending a singnal to the moon and receiving the reflected signal again. This is a known challenge amongst HAM Radion Community. It is known to be challenging due to the high path los.(250dB) 
It is necessary to transmit with a very high power, and the receiver needs to add very little noise to the very small signal received back from the moon. 

My main task is to design and build a Low Noise Amplifier that should me mounted on the roof near the antenna. 

To protect the LNA when transmitting, we will use coaxial Relais and a Sequencer. These will disconnect the LNA from the Signal path to the antenna. 
Please take a look at "Systemskizze.png" for a more detailed layout.

## LNA Topologie and parts
To ensure a good Noise-Figure (NF) we decided to build a LNA with a cascaded design of two amplifiers. The first Amp is optimized for a low noise figure, while the other amplifier can be optimized to reach the desired signal gain. 
Inbetween the two amplifiers it is recommended to place a Bandpassfilter to remove interference and prevent Oscillations in the circuit. 

We went with the following Options
1st Amp: SKY67151-396LF
Bandpass: CBP-1320Q+
2nd Amp: PGA-103+ 
