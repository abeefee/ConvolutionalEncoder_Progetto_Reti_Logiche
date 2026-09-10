# 🔍 Codificatore Convoluzionale - Progetto RL 2021/22

*You can read this also in [English](README.md)*

> **Academic Note:** Questo progetto è stato sviluppato come Prova Finale per il corso di *Reti Logiche* presso il Politecnico di Milano (Anno Accademico 2021/22), da Alberto Biffi e Giovanni Mattia Codemo, ottenendo una valutazione finale di **29/30**.

### Descrizione del progetto
Il progetto consiste nella progettazione e descrizione in VHDL (sintetizzata tramite Xilinx Vivado Webpack) di un componente hardware che si interfaccia con una memoria RAM a blocchi.

Il sistema legge una sequenza continua di **W** byte (la cui lunghezza **W** è memorizzata all'indirizzo 0), li serializza in un flusso continuo di bit **U** e applica un codice convoluzionale a tasso **1/2**. Il flusso codificato risultante **Y** viene riconvertito in parole da 8 bit e salvato a partire dall'indirizzo di memoria 1000.

### Caratteristiche Tecniche & Sfide Affrontate
* **Macchina a Stati Finiti (FSM):** Implementata mediante un'architettura sincrona a processo singolo gestita da un segnale di clock (i_clk) e un reset (i_rst).
* **Logica Convoluzionale:** Sfrutta registri di scorrimento per implementare la struttura del codificatore a tasso 1/2, generando coppie di bit alternati (**{1k}, P_{2k}**).
* **Gestione del Protocollo di Memoria:** Gestisce i segnali di controllo (o_en, o_we, o_address) per coordinare le operazioni di lettura e scrittura con la RAM.
* **Supporto a Stream Multipli:** In grado di elaborare più flussi consecutivi a seguito di nuove attivazioni del segnale i_start, senza la necessità di un reset completo tra un'esecuzione e l'altra.

### Tecnologie e Risultati di Sintesi
* **Linguaggio:** VHDL (IEEE 1164 standard)
* **Strumento di Sintesi:** Xilinx Vivado Webpack (Target FPGA: Artix-7 xc7a200tfbg484-1)
* **Utilizzo delle Risorse:** 
  * **LUT:** 71
  * **Flip-Flop (FF):** 93
  * **Latch:** 0
* **Prestazioni Temporali:** Rispetta pienamente il vincolo sul periodo di clock di 100 ns, registrando uno slack post-sintesi pari a 95.850 ns.


### Struttura della Repository
`src/`: Contiene il file sorgente VHDL principale (project_reti_logiche.vhd).

`docs/`: Include la relazione ufficiale del progetto (Relazione.pdf) e le specifiche/regole originali.

`tests/`: Contiene i testbench di simulazione.