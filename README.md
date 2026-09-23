# mac-health

Un check rapido e leggibile delle prestazioni del tuo Mac: RAM, swap, CPU e disco in un colpo d'occhio. Zero dipendenze, un solo comando.

Pensato per sviluppatori che si ritrovano il Mac lento e vogliono capire **in 2 secondi** cosa sta succedendo — e magari avere dati oggettivi da mostrare a chi assegna l'hardware.

```
  MAC HEALTH CHECK  —  23/09/2026 23:41
────────────────────────────────────────────
Macchina: MacBook Air | Apple M3 | 16 GB RAM
Acceso da: 1 day
Carico CPU: 2.57 su 8 core
────────────────────────────────────────────
Memoria libera: 40%  (buono)
Memoria compressa: 6.5 GB
Swap usato: 8.0 GB  (alto → causa lentezza)
────────────────────────────────────────────
Top 5 processi per CPU:
   58.4%  opencode
   19.7%  WindowServer
   ...
────────────────────────────────────────────
Top 6 app per RAM:
    5176 MB  (66 proc)  Google Chrome
     936 MB  ( 1 proc)  opencode
   ...
────────────────────────────────────────────
Disco libero: 40Gi  (usato 23%)
────────────────────────────────────────────
Verdetto: RAM sotto forte pressione. Chiudi app pesanti (browser!) o riavvia.
```

## Caratteristiche

- **Zero dipendenze** — usa solo tool nativi macOS (`awk`, `sysctl`, `vm_stat`, `ps`, `df`, `memory_pressure`). Niente `bc`, niente installazioni.
- **Intel + Apple Silicon** — rileva automaticamente il chip.
- **Verdetto automatico** — ti dice a colori se il sistema è sano, sotto carico o critico.
- **Aggregazione intelligente** — somma la RAM di tutti i processi della stessa app (es. i 66 processi di Chrome).
- **Output JSON** (`--json`) — integrabile in script e automazioni.
- **Exit codes** — `0` sano, `1` warning, `2` critico. Utile per alert automatici.
- **shellcheck-clean** — codice validato.

## Installazione

### Via Homebrew (consigliato)

```sh
brew tap dempago/tap
brew install mac-health
```

### Manuale

```sh
curl -o /usr/local/bin/mac-health https://raw.githubusercontent.com/DemPago/mac-health/main/bin/mac-health
chmod +x /usr/local/bin/mac-health
```

## Uso

```sh
mac-health              # report leggibile a colori
mac-health --json       # output JSON
mac-health --no-color   # senza colori
mac-health --help       # aiuto
```

### Salvare uno storico

I colori si disattivano automaticamente quando l'output non è un terminale, quindi puoi loggare pulito:

```sh
mac-health >> ~/mac-health.log
```

### Usarlo in automazioni (grazie agli exit codes)

```sh
mac-health --json > /dev/null || echo "Attenzione: il Mac è sotto carico"
```

## Come leggere i risultati

| Metrica | Cosa indica |
|---|---|
| **Memoria libera** | Percentuale di RAM disponibile. Sotto il 20% = problemi. |
| **Memoria compressa** | RAM che il sistema comprime per non finire lo spazio: sintomo di saturazione. |
| **Swap usato** | RAM "parcheggiata" sul disco perché la memoria è finita. È la **causa n.1 della lentezza**. Sopra i 6 GB = critico. |
| **Top app per RAM** | Quali app pesano di più (spoiler: spesso il browser). |

### E se lo swap è alto?

Lo swap significa che il Mac usa il disco (lento) come RAM di emergenza. Rimedi:
1. Chiudi i tab del browser inutili (Chrome è tipicamente il maggior consumatore).
2. Chiudi le app che non stai usando.
3. Riavvia per azzerare lo swap.
4. Se succede sempre: la RAM è insufficiente per il tuo carico di lavoro.

## Requisiti

macOS (qualsiasi versione recente, Intel o Apple Silicon). Nessun'altra dipendenza.

## Licenza

MIT — vedi [LICENSE](LICENSE).
