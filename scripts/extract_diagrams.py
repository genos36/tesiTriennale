#!/usr/bin/env python3
"""
Estrae ed esporta come SVG i diagrammi dei casi d'uso, per il pattern:

    #let diagram=none
    #if utils.debug == true{
        diagram = utils.draw-uc-diagram(...)
    }
    #use-case(..., immagine: diagram, ...)

Approccio: per ogni file .typ prende TUTTO il codice prima della chiamata
#use-case(...) (import, variabili, il blocco #if di generazione), forza a
`true` qualunque condizione del tipo `if <qualcosa>.debug == true { ... }`
in modo che il diagramma venga sempre calcolato, poi compila quel codice da
solo con in coda `#diagram`, producendo un SVG standalone.

Se in un file non c'e' nessuna riassegnazione di `diagram` (resta `none`
per tutto il file), il file viene saltato: non ha un diagramma da esportare.

Uso:
    python3 extract_diagrams_v2.py <cartella-input> <cartella-output-svg> [--root <root-progetto>] [--typst <path-binario>]

--root e' importante quando nel progetto usi import "assoluti" tipo
"/content/chapters/.../utils.typ": va passato lo stesso root che usi per
compilare la tesi intera (la cartella che contiene "content/", "template/",
ecc.), altrimenti quegli import non si risolvono.
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path

USE_CASE_CALL_RE = re.compile(r'#use-case\s*\(')
# nomi delle funzioni che generano davvero il diagramma
DIAGRAM_FUNC_NAMES = ["draw-uc-diagram", "draw-uc-expansion"]
DIAGRAM_FUNC_RE = re.compile(
    r'(?:' + '|'.join(re.escape(n) for n in DIAGRAM_FUNC_NAMES) + r')\s*\('
)
# `if qualcosa.debug == true {`  oppure  `if qualcosa.debug {`
DEBUG_IF_RE = re.compile(r'if\s+[\w.\-]+\.debug(\s*==\s*true)?\s*\{')


def find_setup_code(text: str):
    """Tutto cio' che precede la prima chiamata #use-case( ... )."""
    m = USE_CASE_CALL_RE.search(text)
    if not m:
        return None
    return text[:m.start()]


def has_real_diagram(setup: str) -> bool:
    """True se nel codice di setup compare una chiamata a una delle
    funzioni note che generano il diagramma (draw-uc-diagram,
    draw-uc-expansion, ...)."""
    return bool(DIAGRAM_FUNC_RE.search(setup))


def force_debug_true(setup: str) -> str:
    return DEBUG_IF_RE.sub('if true {', setup)


def process_file(typ_path: Path, out_dir: Path, typst_bin: str, root_dir, page_width: str, top_margin: str, log):
    text = typ_path.read_text(encoding="utf-8")
    setup = find_setup_code(text)

    if setup is None:
        log.append((typ_path.name, "SKIP", "nessuna chiamata #use-case(...) trovata"))
        return
    if not has_real_diagram(setup):
        log.append((typ_path.name, "SKIP", "nessuna chiamata a draw-uc-diagram/draw-uc-expansion trovata"))
        return

    setup_forced = force_debug_true(setup)
    standalone = (
        setup_forced
        + f"\n#set page(width: {page_width}, height: auto, margin: (top: {top_margin}, rest: 0pt))\n"
        + "#diagram\n"
    )

    tmp_typ = typ_path.parent / f"_tmp_{typ_path.stem}.typ"
    out_svg = out_dir / f"{typ_path.stem}.svg"
    tmp_typ.write_text(standalone, encoding="utf-8")

    cmd = [typst_bin, "compile", "--format", "svg"]
    if root_dir:
        cmd += ["--root", str(root_dir)]
    cmd += [str(tmp_typ), str(out_svg)]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        stderr = result.stderr.strip()
        lines = stderr.splitlines()
        # la prima riga e' il messaggio vero (es. "error: file not found ...");
        # le righe successive sono contesto/posizione/puntatore, utili nel log
        # completo ma inutili come riassunto.
        first_msg = lines[0] if lines else "errore sconosciuto (nessun output su stderr)"

        log_path = out_dir / f"{typ_path.stem}.error.log"
        log_path.write_text(
            "=== comando ===\n" + " ".join(cmd) + "\n\n"
            "=== file standalone generato ===\n" + standalone + "\n\n"
            "=== stderr completo ===\n" + stderr + "\n",
            encoding="utf-8",
        )

        log.append((typ_path.name, "ERRORE", f"{first_msg}  [log: {log_path.name}]"))
    else:
        log.append((typ_path.name, "OK", f"-> {out_svg.name}"))
        tmp_typ.unlink(missing_ok=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("in_dir", type=Path)
    ap.add_argument("out_dir", type=Path)
    ap.add_argument("--root", type=Path, default=None,
                     help="root del progetto Typst (per gli import assoluti /content/...)")
    ap.add_argument("--typst", default="typst")
    ap.add_argument("--page-width", default="21cm",
                     help="larghezza fissa della pagina standalone (evita crash con contenuti a width: 100%% dentro pagine width:auto). Default: 21cm")
    ap.add_argument("--top-margin", default="4cm",
                     help="margine superiore della pagina standalone: assorbe elementi che 'sconfinano' sopra il box misurato (es. etichette posizionate con place() e dy negativo, come il nome del sistema). Default: 4cm")
    args = ap.parse_args()

    args.out_dir.mkdir(parents=True, exist_ok=True)

    log = []
    typ_files = sorted(args.in_dir.glob("*.typ"))
    for typ_path in typ_files:
        if typ_path.name.startswith("_tmp_"):
            continue
        process_file(typ_path, args.out_dir, args.typst, args.root, args.page_width, args.top_margin, log)

    name_w = max((len(n) for n, _, _ in log), default=20)
    print(f"{'File':<{name_w}} {'Esito':<8} Dettaglio")
    print("-" * (name_w + 50))
    for name, status, detail in log:
        print(f"{name:<{name_w}} {status:<8} {detail}")

    n_ok = sum(1 for _, s, _ in log if s == "OK")
    n_skip = sum(1 for _, s, _ in log if s == "SKIP")
    n_err = sum(1 for _, s, _ in log if s == "ERRORE")
    print(f"\nTotale: {n_ok} SVG generati, {n_skip} saltati, {n_err} errori.")


if __name__ == "__main__":
    main()
