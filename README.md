# Low-Noise-Amp-1296MHz

This project is part of my Bachelors Thesis to finish my degree in electrical engineering.

At our institution we already have a parabolic antenna for 23cm waves installed. In the future we aim to do a "moon bounce".
That means sending a singnal to the moon and receiving the reflected signal again. This is a known challenge amongst HAM Radion Community. It is known to be challenging due to the high path los.(250dB)
It is necessary to transmit with a very high power, and the receiver needs to add very little noise to the very small signal received back from the moon.

My main task is to design and build a Low Noise Amplifier that should me mounted on the roof near the antenna.

To protect the LNA when transmitting, we will use coaxial Relais and a Sequencer. These will disconnect the LNA from the Signal path to the antenna.
Please take a look at "Systemskizze.png" for a more detailed layout.

![Systemskizze](images/Systemskizze.png)

## LNA Topologie and parts

To ensure a good Noise-Figure (NF) we decided to build a LNA with a cascaded design of two amplifiers. The first Amp is optimized for a low noise figure, while the other amplifier can be optimized to reach the desired signal gain.
Inbetween the two amplifiers it is recommended to place a Bandpassfilter to remove interference and prevent Oscillations in the circuit.

We went with the following Options

- 1st Amp: SKY67151-396LF
- Bandpass: CBP-1320Q+
- 2nd Amp: PGA-103+

## HF Relais

As I mentioned before it is necessary to protect the LNA from the transmitting power. Therefore we need HF Relais which disconnect the LNA from the coaxial cable while the System is sending power to the antenna. The requirements for the relais are quite high. We need RF power of around 500W (which is a lot) and isolation between the two path of 70dB or more.

The gold standard in professional mobile Networks are "Spinner" Relais. However, those weight ~ 1.2kg, are very big, hard to find and the price is not publicly available.

Therefore we will use the Radiall R570022000. That is a smaller and less pricy Relais which can handle our system requirements.

## Bias T

As the Circuit in "Systemskizze.png" suggests, the Sequencer will feed DC into the coaxial cable. The DC will switch on the Relais and deliver power to the LNA. Therefore we need a Bias-T near the antenna to seperate the HF signal and the DC power. That Bias-T has to handle the full Transmit power of around 500 Watts. Just like the Relais, this is a very specific system requirement. Luckily there are parts available for HAM-Radio Community, which we can use in our System.

We decided to use the following Bias-T:
23cm 600W Bias Tee 1240 to 1320MHz Outdoor from Antenna Amplifiers

## Update 24.03.2026

After simulation the RF Signal, the Schematic and PCB were designed. The following features were added to the final Design:

![Circuit Diagramm Version 1](images/Schaltplan.jpg)

### power supply

There are two possibilities to supply the ICs with 5V. The obvious one is to configure the LDO for 5V and directly connect it to the ICs with some Capacitors. The second option is to configure it to a higher voltage and place Resistors in series. The voltage drop over the resistors will bring the voltage back down to 5V. The theoretical advantage of this is, that the resistors form low pass filters with the capacitors. However, this brings the risk of the voltage droping more when the current rises. (more voltage drop across the resistor, therefore less voltage for the IC)
To try both configurations, the Design has some Resistors which can be bridged or left open, to configure it accordingly. Please refer to the Datasheet of the LDO for more information. Once the PCB arrives, I will test which option brings better results.

### waveguides

In RF PCB Design it is very important to know the exact layer stack that the manufacturer uses. However, our supplier only has a defined layer stacks for 4 Layers or more. Due to that, my Design is a 4 Layer PCB. The Components have to be on the top (or bottom) layer, and the ground layer should be directly underneath. The distance between the signal layer and the ground layer is very small in that case. In my case it is 0.14mm.

The SKY67151 and the CBP-1320Q+ are both designed for grounded coplanar wave guide transmission line. I used the internal Altium Layer stack manager to calculate the track with for that wave guide. Unfortunately the small distance between signal Layer and ground plane results in a very thin track width. In my case the track width is 0.207mm and 0.127mm gap to the ground planes.

That brings the issue, that the 0402 components (Resistors, Capacitors...) are quite a lot bigger than the track itself. This results in a change of impedance as the signals hits the component. To encounter this Problem I applied to measures:

- Tapering: slowly increasing the width of the track to decrease the parasitc impedance
- ground cutout: The "big" pads of the 0402 components have a bigger capacitance against ground than they are supposed to. A cutout in the ground plane reduces the effective area of the pad against ground and brings the capacitance down.

![PCB Design Version 1](images/PCB1.png)