# VHDL project - Časovač na intervalový (kruhový) trénink

### Členové týmu

* Radim Pařízek 
* Martin Mička 
* Jakub Pachel 

## Teoretický popis

Cílem tohoto projektu bylo vytvořit časovač pro kruhový trénink. Tento časovač by měl být navržen na vývojové desce XILINX Nexys A7 (Artix-7 50T),
která využívá vysokokapacitní FPGA. Pro návrh tothoto časovače využijeme z hardwarových součástek 4 místný sedmisegmentový displej, tlačítka a přepínače.
Tato deska bude naprogramována v programovacím jazyku VHDL.

Časovač bude umožňovat nastavení počtu kol, délky cvičícího kola a také délku pauzy mezi koly. Pro toto nastavování budem používat přepínače. Jeden z přepínačů přepne zařízení do módu nastavování. A pomocí dalších tří přepínačů si vyberem co chceme nastavovat. Nastavování bude pomocí levého a pravého tlačítka. Prostřední tlačítko bude sloužit k resetu. Pomocí vrchního tlačítka se bude spouštět odpočet a spodním tlačítkem se odpočet pausne.

## Hardware popis

Z hardwarových součástek využíváme 4 přepínače, 5 tlačítek a 4 sedmisegmentové displeje. PřepínaČ úplně v pravo je určen pro přepnutí do módu nastavování, Přepínač první z leva je pro přepnutí do nastavování délky doby tréninku, přpínač druhý z leva je úrčen pro nastavování délky doby pauzy a třetí z leva je pro nastavování počtu kol. Nastavovánní tedy probíhá pomocí levého a pravého tlačítka. Problém u těchto tlačítek je, že při stisknutí tlačítka nastane takzvaný zákmit, což by znamenalo že po jednom stisknutí tlačítka by se přičetlo mnohonásobně víc sekund v nastavování. Tudíž je potřeba tyto zákmity softwarově ošetřit.

## Software popis


Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders. 

 Ve scriptu [stop_watch]() pokud nejsme ve stavu nastavování a zároveň nejsme ve stavu nastavování a zároveň neskončil čas posledního kola tak každou vteřinu odečteme 1 vteřinu od odpočtu dokud 

![diagram](https://user-images.githubusercontent.com/61315339/235538320-8d389bdf-28bb-4661-9fe9-6571cd6a70f4.png)


### Simulace komponentů

Write descriptive text and simulation screenshots of your components.

## Návod k použití

* Nastavení parametrů pro časovač na kruhový trenink.

  * Nejdříve je potřeba přepnout přepínač do módu nastavování. Tím že přepínač úplně v pravo (viz obrázek `SET` ) posuneme směrem k tlačítkům.
  Když jsme v módu nastavování můžeme pomocí nasledujících odrážek nastavit co budeme nastavovat:
    * Pro nastavování délky doby tréninku posuneme tlačítko které je nejvíce v pravo (viz obrázek `TRAIN` ) směrem k displeji.
    * Pro nastavování délky doby pauzy mezi tréninkem posuneme tlačítko které je druhé z leva (viz obrázek `BREAK` ) směrem k displeji.
    * Pro nastavování počtu kol tréninků  posuneme tlačítko které je třetí z leva (viz obrázek `REPS` ) směrem k displeji.
  * Když máte vybráno co chcete nastavovat (počet opakování / délku pauzy / délku kola tréninku ). Tak můžete tyto hodnoty měnit pomocí levého a pravého tlačítka.
    * Po stisknutí levého tlačítka (viz obrázek `DOWN` ) se hodnota o jednu jednotku zmenší.   
    * A po stisknutí pravého tlačítka (viz obrázek `UP` ) se hodnota zvětší o jednu jednotku.
* Pro přepnutí do modu kde bude běžet časovač posuňte přepínač úplně v pravo (viz obrázek `SET`) směrem od tlačítek.
  * Pro supštění časovače zmáčkněte tlačítko start které je úmístěno mezi tlačítky nahoře A(viz obrázek `START` ).
  * Pro zastavení časovače zmáčkněte tlačítko stop které je úmístěno mezi tlačítky dole (viz obrázek `STOP`)
  * Jestli chcete jet celý trénink od znova stiskněte tlačítko reset které je umístěno mezi tlačítky přesně uprostřed (viz obrázek `RESET`).
  
  .





<img width="606" alt="manual" src="https://user-images.githubusercontent.com/61315339/235537917-ad89aa39-6605-4a73-b41e-47314a45cf56.png">

* Veškeré data se zobrazují na levém 4 místném sedmisegmentovém displeji. A to jak v módu nastavování tak v módu zobrazování časovače.
  * Vlevo se zobrazuje stav (viz obrázek `STATE` ) 
  * NA druhém sedmisegmentovém displeji zleva se zobrazují minuty (viz obrázek `MINUTES` ) 
  * NA dvouch sedmisegmentových displejích zprava se zobrazují sekundy (viz obrázek `SECONDS` ) 

<img width="606" alt="manual02" src="https://user-images.githubusercontent.com/61315339/235627124-21bb6ee8-45e6-429f-8687-c69112487200.png">

## References

1. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
2. ...
