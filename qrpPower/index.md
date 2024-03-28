# qrpPower
### En RDE historie https://www.fihl.net/qrpPower/ 
### By Christen Fihl, [OZ1AAB](https://www.fihl.net/oz1aab/)

[xxxx](/qrpPower/)

## So far
* 
*  code is [here](https://github.com/Fihl/xxxxxxxxx)

## Picts
![asdasda](https://www.fihl.net/qrpPower/picts/xxx.png)



Strøm

Hvert forår hiver jeg radioen med ud i haven, for at lege med forskellige dimser. 
Måske FT857D sammen med CW udstyr og loop antenner. 
Eller små QRP style som QRPLabs QCX eller (tr)uSDX, og så en længde tråd i en fiskestang efter en ATU100 autotuner. 
Alt dette skal have strøm, men ikke nødvendigvis i de store mængder. 
Jeg kunne trække en forlænger til stikkontakten, og så også slæbe en PSU med ud. Men egentligt synes jeg at det er en del af oplevelsen at være lidt selvkørende. 
Nu har jeg endda fået et ”skur” at være i…  Og antenne er 3 meter væk, i flagstangen, så det…
 

Følgende snak er lidt om mine strøm tanker gennem tiden. 

Kravene er generelt som: 
1) 5 Volt USB agtigt. 
2) Og 12 Volt, som typisk skal være 13,8 Volt. Og her går jeg endda langt over ud fra tanke at fx min FT857D er beregnet til bil montage, og som sådan skal kunne overleve de 15Volt der tit er der. 

Powerbank og små 12 Volt celler
  ((Billede 1))
En powerbank med USB. Denne skal kunne fungere selvom strømtrækket kun er få mA. Mange powerbanks lukker ned når de tror man ikke laver noget, og det bliver man hurtigt træt af. 
På billedet er en 3S1P pakke fra LiitoKala. (3 i serie, 1 i parallel). 70,- kroner incl Li-Ion 12.6V lader (3 * 4.2 Volt). 
Disse 12 Volt er fin til QRP dimserne. Yaesu radioen synes jeg dog trækker for meget ved RX, og ved TX ved 5 Watt er virkningsgraden ikke god. 
8 gange mere bang for the buck…
   ((Billede 2))
Denne 4S6P har 24 elementer mod 3 i forrige. Altså 8 gange så mange Watt-Timer. 
Og med 6 elementer i parallel, så klarer den også flere Ampere i forbrug, ved sending. 
Den skal så lades med 16,8 Volt (4 * 4,2 Volt). 
Og som sådan, så er den leverede spænding derfor også 16,8 Volt, max. 
Denne kører jeg direkte ind i Yaesu FT859D radioen. 
Der er BMS indbygget  LiitoKala pakken, men dog synes jeg ledningerne ud af pakken er alt for tynde. 
Det viste røde panel er mine spæde forsøg på at lave forplader med resin 3D printeren. Eller hele kasser. Men resultaterne bliver for skrøbelige, så jeg er pt på at laserskære i birkfiner. 

Så derfor bruger jeg nu færdige og kraftige batteripakker.
Brandfaren, og andre hensyn taget i betragtning, og lettere opladning, og hyldevare her i huset, og …
Derfor vælger jeg nu at bruge færdige adaptorer der tillader mig at bruge de batterier jeg allerede har liggende til håndværktøjet. Der findes mange præferencer og farver bland hobbyfolket, og pro’s. Selv er jeg på Ryobi holdet, med 18 og 36 Volts udstyr. 

I en 36 Volts 4Ah pakke er der ret så mange Wh (142 Wh)
  ((Billede 6))

Det er her meget lettere at udregne hvad man faktisk kan trække ud af sådanne kommercielle batterier. Den viste 142Wh kan jeg i min plæneklipper tømme på ca 15 minutter, før den selv slår fra. 
142 Wh giver 10 Ah ved 13.8 Volt. 
Og 10 Ah er det samme som 10 A konstant i 1 time for at tømme den. 
Nu da jeg kan tømme batteriet på 15 minutter i plæneklipperen, så må det være tilladt at trække 40 A fra denne batteripakke, stadig ved 13.8 Volt. 
Altså med en BUCK konverter ind imellem. Buck konverteren kan sænke spændingen fra 36 Volt til 13.8 Volt (en faktor 2,6), hvorfor strømtrækket ud af pakken er sænket med tilsvarende 2,6. De 40 A ved 13.8 Volt er derfor de mere beskedne 15 A ud af pakken. 
Kontrol: 15 A * 36 Volt * ¼ time = 135 Wh

18 Volt princip
Selvom nytårstesten siger at QRP er op til 99 Watt, så synes jeg faktisk det er sjovere med max 10 Watt som QRP. 
Og jeg har fundet en del 18 Volts dimser der passer på Ryobi, der pt er min favorit farve i værkstedet. 
Der er adaptere til alle andre mærker på AliExpress og eBay, og der må I selv søge.
Specs siger 18 Volt, og fx med den viste 4 Ah pakke giver dette 72 Wh, det halve af 36 Volt batteriet fra før. 
Derfor burde jeg kunne trække 20A i et kvarter, ved 13,8 Volt, det halve at forrige beregning. 
Eller 10A i en halv time. Eller 2,5 A i 2 timer. 
Men dette har jeg ikke efterprøvet endnu, da det stadig er vinter her …

Den simple 18 Volt’r
  ((Billede 4))
Denne er plain simpel, med to tråde ud fra batteri kontakterne. No questions asked, og ingen sikringer. Men der er dog så BMS indbygget i selve Ryobi batteriet, som også slår fra når der overbelastes. 
Jeg tror batteriet er et 5S batteri, og 5*4.2 = 21. Derfor kommer max spænding op på 21 Volt, og derfor har jeg en buck konverter ind imellem. 
Buck konverteren klarer også 36 Volt batteriet, og håndterer 600 Watt (ifølge websiden) 

Også simpel, med USB
  ((Billede 3))
Denne har USB med 5 Volt ved 2 Ampere (måske hver, ellers i alt). Og den har et DC stik med direkte forbindelse til batteripolerne, også helt uden sikring! 
Så her skal der også en buck konverter imellem for at komme på 13,8 Volt. 
230V til skovturen
  ((Billede 5))
Som rosinen, så kan man da også få 230V til barbermaskinen, eller andet op til 200 Watt. Denne har også almindelig USB, og en USB-c. 

Dette er mit setup for tiden, at køre på færdigkøbte batterier. 
Brænder hytten ned, så kan jeg give skylden på Ryobi, og skal ikke kæmpe med forsikringen om ansvaret. 
Altid godt at have batterier og adaptere på lager. Be prepared.

73 de OZ1AAB, 
Christen Fihl 
Ølstykke

 
Referencer:
QRP labs QCX	https://www.qrp-labs.com/qcx.html
(tr)uSDX	https://dl2man.de/
Lille LiitoKala 3S1P	https://www.aliexpress.com/item/32381410408.html
Stor LiitoKala 4S6P	https://www.aliexpress.com/item/4000317583239.html
Ryobi, simpel adapter	https://www.aliexpress.com/item/1005004072825802.html
Ryobi, USB powerbank	https://www.aliexpress.com/item/1005004879566505.html
Ryobi, USB + 230Volt 200W	https://www.aliexpress.com/item/1005006040621483.html
Buck konverter	https://www.aliexpress.com/item/1005005225240004.html

