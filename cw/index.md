# CWC, CWComfort, a morse keyer with lazy attitude
### My morse keyer, the one without timing hassels
### By Christen Fihl, [OZ1AAB](https://www.fihl.net/oz1aab/)

## Why
Years ago I gave myself the task of making a morse coding device, that is anything but a plain keyboard. 
Could have been a braille typewriter machine, having some 7 keys. 
But having a lot of morse kind of devices already, I stayed on the side swiping things. 

Having tried the iambic mode, I realised that the timing part of "put a dash into the dots at the right time" was the hard one. And when typed and transmitted goes 1-to-1, i.e. you hear what you send, it would be even harder to transmit on different speeds. 
Using iambic, the timing in putting a dash into the L, **. _ . .** would be different using speed 12 and 18. 
I also wanted the correct letter spacing, and maybe even word spacing (well that did call for some timing stuff)

## My mantra/dogmas 
* The CWComfort mode as like a keyboard, not related to the output beeing CW
* A single paddle keyer is "enough", but iambic keyer can be used anyway, but without iambic 
* Not much timing involved
* Can be used/manipulated at higher speed than actual transmission, ie always manipulate at speed 18 if you like, as transmit is exactly as configured
* Would also be a nice helper for CW training, having USB connection, keying directly into a Notepad/TextEdit,..
* Output is plain on-off keying the transmitter

## Implementation, physical
* An Arduino Uno is pleanty of intelligence
* Arduino Leonardo is as tiny as it gets, with added features as USB keyboard (USB HID interface)
* The program can be configured with transmit speed, and to add extra (Farnsworth) spacing. Even when keying is done in ones normal (higher) speed


## Implementation, the one timing that really needs to be there
Pressing dih or dah button will make 1, and max 2 dih/dah's. The *shortdelay* determines when you get 2.

After same *shortdelay* without any dih/dah, you will get a letter space.

After a longer *shortdelay* without any dih/dah, you get the word spacing

## Examples of keying
| | Nomenklatur | Comment |
|----|----------------|----------------|
|dih | i | short press dih | 
|dah | a | short press dah |
|dih dih | I | longer press dih |
|dah dah | A | longer press dah |
| shortdelay | - | at least *shortdelay* |
| the long shortdelay | -- |  **a longer** *shortdelay* |


| L | Morse | How it's keyed | alternative |
|---|--------|-------|---|
| M | _ _ | aa | A |
| S | . . . | iI | Ii |
| L | . _ . . | iaI | iaii |
| V | . . . - | iIa | Iia |
| 1 | . _ _ _ _ | iAA | |
| 2 | . . _ _ _ | IAa | IaA or iiaA or .. |
| CQ | _ . _ . / _ _ . _ | aiai-Aia |  |

Hello World = 
II-i-iaI-iaI-aA -- iA-aA-iai-iaI-aI

Only timing is - and --, and you just key as fast as you like. 

### CWComfort vs Iambic
| VS | CWComfort | Iambic | |
|----|-----------|--------|------------|
|wpm | ok        | bad    | Iambic forces you to track wpm used |
|counting| ok    | bad    | Iambic forces you to "insert dot on correct timing" |
|release| ok     | bad    | Bad as you also have to release inserted key on right timing |
| A     | easy   | easy   | Iambic still needs timimg to release dah|
| C     | easy, but more keys | easy, but timing sucks | Iambic still needs timimg to release on **last** dah |
| 2     | easy   | tough  | remember to release after 3 times dah, and timing depends on wpm |


## Refs
[ ![AliExpress](https://www.fihl.net/cw/picts/leonardo.png "Buy a Leonardo unit") ](https://www.aliexpress.com/item/32617886318.html)

Mouser: https://www.mouser.dk/ProductDetail/DFRobot/DFR0816?qs=Li%252BoUPsLEnv9dhK52gqzSQ%3D%3D
