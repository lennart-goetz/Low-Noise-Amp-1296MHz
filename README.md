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
-  1st Amp: SKY67151-396LF
-  Bandpass: CBP-1320Q+
-  2nd Amp: PGA-103+

## HF Relais
As I mentioned before it is necessary to protect the LNA from the transmitting power. Therefore we need HF Relais which disconnect the LNA from the coaxial cable while the System is sending power to the antenna. The requirements for the relais are quite high. We need RF power of around 500W (which is a lot) and isolation between the two path of 70dB or more.

The gold standard in professional mobile Networks are "Spinner" Relais. However, those weight ~ 1.2kg, are very big, hard to find and the price is not publicly available. 

Therefore we will use the Radiall R570022000. That is a smaller and less pricy Relais which can handle our system requirements. 

## Bias T
As the Circuit in "Systemskizze.png" suggests, the Sequencer will feed DC into the coaxial cable. The DC will switch on the Relais and deliver power to the LNA. Therefore we need a Bias-T near the antenna to seperate the HF signal and the DC power. That Bias-T has to handle the full Transmit power of around 500 Watts. Just like the Relais, this is a very specific system requirement. Luckily there are parts available for HAM-Radio Community, which we can use in our System. 

We decided to use the following Bias-T:
23cm 600W Bias Tee 1240 to 1320MHz Outdoor from Antenna Amplifiers
