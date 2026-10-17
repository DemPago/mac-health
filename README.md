# mac-health

[![CI](https://github.com/DemPago/mac-health/actions/workflows/ci.yml/badge.svg)](https://github.com/DemPago/mac-health/actions/workflows/ci.yml)

Un check rapido e leggibile delle prestazioni del tuo Mac: RAM, swap, CPU e disco in un colpo d'occhio. Zero dipendenze, un solo comando.

Pensato per sviluppatori che si ritrovano il Mac lento e vogliono capire **in 2 secondi** cosa sta succedendo — e magari avere dati oggettivi da mostrare a chi assegna l'hardware.

![demo](https://github.com/DemPago/mac-health/releases/download/v1.1.0/demo.gif)

## Caratteristiche

- **Zero dipendenze** — usa solo tool nativi macOS (`awk`, `sysctl`, `vm_stat`, `ps`, `df`, `memory_pressure`). Niente `bc`, niente installazioni.
- **Intel + Apple Silicon** — rileva automaticamente il chip.
- **Verdetto automatico** — ti dice a colori se il sistema è sano, sotto carico o critico.
- **Aggregazione intelligente** — somma la RAM di tutti i processi della stessa app (es. i 66 processi di Chrome).
- **Output JSON** (`--json`) — integrabile in script e automazioni.
- **Exit codes** — `0` sano, `1` warning, `2` critico. Utile per alert automatici.
- **Soglie configurabili** — sovrascrivibili via variabili d'ambiente, senza modificare lo script.
- **shellcheck-clean** — codice validato. CI su ogni push.

## Installazione

### Via Homebrew (consigliato)

```sh
brew tap dempago/tap
brew trust dempago/tap   # richiesto da Homebrew per i tap di terze parti
brew install mac-health
```

### Manuale

Installa in `~/bin` (funziona sia su Intel che Apple Silicon):

```sh
mkdir -p ~/bin
curl -fsSL https://raw.githubusercontent.com/DemPago/mac-health/main/bin/mac-health -o ~/bin/mac-health
chmod +x ~/bin/mac-health
# assicurati che ~/bin sia nel PATH:
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

## Uso

```sh
mac-health              # report leggibile a colori
mac-health --json       # output JSON
mac-health --no-color   # senza colori
mac-health --fast       # salta system_profiler (più veloce, utile in CI)
mac-health --quiet      # nessun output, solo exit code
mac-health --watch 5    # aggiorna ogni 5 secondi (Ctrl+C per uscire)
mac-health --help       # aiuto
```

### Salvare uno storico

I colori si disattivano automaticamente quando l'output non è un terminale, quindi puoi loggare pulito:

```sh
mac-health >> ~/mac-health.log
```

### Usarlo in automazioni

```sh
# alert se il Mac è sotto carico
mac-health --fast --quiet || echo "Attenzione: Mac sotto carico (exit $?)"

# parsing JSON
mac-health --fast --json | jq '.verdict, .swap_used_gb'
```

### Soglie configurabili

Le soglie di warning/critico sono sovrascrivibili via variabili d'ambiente:

| Variabile | Default | Significato |
|---|---|---|
| `MAC_HEALTH_SWAP_WARN` | `2` | GB swap per livello warning |
| `MAC_HEALTH_SWAP_CRIT` | `6` | GB swap per livello critico |
| `MAC_HEALTH_MEM_WARN` | `40` | % memoria libera per warning |
| `MAC_HEALTH_MEM_CRIT` | `20` | % memoria libera per critico |
| `MAC_HEALTH_LOAD_WARN` | `1.5` | load/core per warning |

```sh
# abbassa la soglia critica swap a 4 GB
MAC_HEALTH_SWAP_CRIT=4 mac-health
```

## Come leggere i risultati

| Metrica | Cosa indica |
|---|---|
| **Memoria libera** | Percentuale di RAM disponibile. Sotto il 20% = problemi (configurabile). |
| **Memoria compressa** | RAM che il sistema comprime per non finire lo spazio: sintomo di saturazione. |
| **Swap usato** | RAM "parcheggiata" sul disco perché la memoria è finita. È la **causa n.1 della lentezza**. Sopra i 6 GB = critico (configurabile). |
| **Carico CPU** | Load average a 1, 5 e 15 minuti normalizzato per core. Sopra 1.5× = warning. |
| **Top app per RAM** | Quali app pesano di più (spoiler: spesso il browser). I valori sono RSS — le pagine condivise tra processi vengono conteggiate più volte. |

### E se lo swap è alto?

Lo swap significa che il Mac usa il disco (lento) come RAM di emergenza. Rimedi:
1. Chiudi i tab del browser inutili (Chrome è tipicamente il maggior consumatore).
2. Chiudi le app che non stai usando.
3. Riavvia per azzerare lo swap.
4. Se succede sempre: la RAM è insufficiente per il tuo carico di lavoro.

## Requisiti

macOS (qualsiasi versione recente, Intel o Apple Silicon). Nessun'altra dipendenza.

## Sviluppo

Per rigenerare la GIF demo (richiede `asciinema` e `agg`):

```sh
brew install asciinema agg
asciinema rec -c "mac-health" --overwrite demo.cast
agg --theme dracula --font-size 20 demo.cast demo.gif
```

## Licenza

MIT — vedi [LICENSE](LICENSE).
