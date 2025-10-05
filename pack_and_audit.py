#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gera dois ficheiros dentro de SCRIPT/:
1) lib_dump.txt  -> todo o código .dart da pasta lib/ num único ficheiro,
                    inserindo '---' antes de cada class/abstract class/mixin/enum/extension
                    e separadores por ficheiro.
2) audit_report.md -> relatório com:
   - Icons/CupertinoIcons usados diretamente (em vez de AppIcons)
   - Texto hardcoded (sem AppLocalizations.of/context.l10n)
   - Cores hardcoded (Colors.* / Color(0x...)) fora de core/theme

"""

from __future__ import annotations
import re
from pathlib import Path

# ---------- Config ----------
LIB_DIRNAME = "lib"
OUT_DIRNAME = "SCRIPT"
DUMP_FILENAME = "lib_dump.txt"
AUDIT_FILENAME = "audit_report.md"

IGNORE_FILES = {
    #"finance_hub_screen.dart",
}
IGNORE_DIRS = {".git", "build", ".dart_tool"}
IGNORE_GENERATED_SUFFIXES = (".g.dart", ".freezed.dart", ".gen.dart")

# Para o audit de cores, não queremos acusar dentro do tema:
COLOR_IGNORE_PREFIX = "lib/core/theme/"

# ---------- Regex ----------
CLASS_RE = re.compile(r"^\s*(?:abstract\s+class|class|mixin|extension|enum)\s+\w+", re.MULTILINE)

ICON_RE = re.compile(r'\b(?:Icons|CupertinoIcons)\s*\.\s*[A-Za-z0-9_]+')
COLOR_RE = re.compile(r'(?:\bColors\.[A-Za-z_]+\b|Color\(\s*0x[0-9A-Fa-f]{6,8}\s*\))')

# props típicas com strings literais
TEXT_PROPS = r'(?:Text|title|subtitle|label|tooltip|hintText|helperText|buttonText|message|content|header|footer|semanticLabel)'
L10N_MARK = re.compile(r'AppLocalizations\.of|context\.l10n')
LIT_RE = re.compile(rf'\b{TEXT_PROPS}\s*:\s*([\'"])(.+?)\1')

# ---------- Helpers ----------
def is_generated(name: str) -> bool:
    return name.endswith(IGNORE_GENERATED_SUFFIXES)

def list_dart_files(lib_root: Path) -> list[Path]:
    files: list[Path] = []
    for p in lib_root.rglob("*.dart"):
        if any(part in IGNORE_DIRS for part in p.parts):
            continue
        if is_generated(p.name):
            continue
        if p.name in IGNORE_FILES:
            continue
        files.append(p)
    return sorted(files, key=lambda x: x.as_posix())

def insert_class_separators(src: str) -> str:
    # Insere uma linha '---' antes de cada declaração de classe/mixin/enum/extension
    out_lines = []
    lines = src.splitlines()
    for i, line in enumerate(lines):
        if CLASS_RE.match(line):
            out_lines.append('---')
        out_lines.append(line)
    return "\n".join(out_lines) + ("\n" if not src.endswith("\n") else "")

def ensure_out_dir(root: Path) -> Path:
    out_dir = root / OUT_DIRNAME
    out_dir.mkdir(parents=True, exist_ok=True)
    return out_dir

def rel(root: Path, p: Path) -> str:
    try:
        return p.relative_to(root).as_posix()
    except Exception:
        return p.as_posix()

# ---------- Dump ----------
def make_dump(root: Path) -> Path:
    lib_root = root / LIB_DIRNAME
    assert lib_root.is_dir(), f"Não encontrei a pasta '{LIB_DIRNAME}/' na raiz: {root}"

    out_dir = ensure_out_dir(root)
    dump_path = out_dir / DUMP_FILENAME

    files = list_dart_files(lib_root)

    with dump_path.open("w", encoding="utf-8") as w:
        for i, f in enumerate(files, 1):
            header = f"// FILE: {rel(root, f)}"
            if i > 1:
                w.write("\n---\n")   # separador entre ficheiros
            w.write(header + "\n")
            try:
                src = f.read_text(encoding="utf-8", errors="ignore")
            except Exception as e:
                w.write(f"// [ERRO a ler ficheiro]: {e}\n")
                continue
            w.write(insert_class_separators(src))
    return dump_path

# ---------- Audit ----------
def audit_repo(root: Path) -> Path:
    lib_root = root / LIB_DIRNAME
    out_dir = ensure_out_dir(root)
    report_path = out_dir / AUDIT_FILENAME

    icon_hits: dict[str, list[tuple[int, str]]] = {}
    color_hits: dict[str, list[tuple[int, str]]] = {}
    text_hits: dict[str, list[tuple[int, str]]] = {}

    for f in list_dart_files(lib_root):
        relpath = rel(root, f)
        src = f.read_text(encoding="utf-8", errors="ignore")
        lines = src.splitlines()

        # Icons
        if relpath != "lib/core/theme/icons.dart":
            for i, line in enumerate(lines, 1):
                if ICON_RE.search(line):
                    icon_hits.setdefault(relpath, []).append((i, line.strip()))

        # Colors (ignorar o próprio tema)
        if not relpath.startswith(COLOR_IGNORE_PREFIX):
            for i, line in enumerate(lines, 1):
                if COLOR_RE.search(line) and "Theme.of" not in line and "colorScheme" not in line:
                    color_hits.setdefault(relpath, []).append((i, line.strip()))

        # Hardcoded text (ignorar linhas que já usam l10n)
        if "core/l10n" not in relpath:
            for i, line in enumerate(lines, 1):
                if L10N_MARK.search(line):
                    continue
                m = LIT_RE.search(line)
                if m:
                    txt = m.group(2).strip()
                    # filtrar valores triviais (#, números, só pontuação, etc.)
                    if len(txt) >= 2 and not re.fullmatch(r'[#\d\s\-\+%/.,:]+', txt):
                        text_hits.setdefault(relpath, []).append((i, line.strip()))

    # escrever relatório
    with report_path.open("w", encoding="utf-8") as w:
        def section(title: str, data: dict[str, list[tuple[int,str]]]):
            if not data:
                return
            w.write(f"\n## {title}\n")
            for relp in sorted(data.keys()):
                w.write(f"\n**{relp}**\n")
                for ln, line in data[relp]:
                    w.write(f"- L{ln}: `{line}`\n")

        w.write("# Audit FootyStar\n")
        w.write("_Gerado automaticamente. Ignorado: cores dentro de lib/core/theme/._\n")

        section("1) Icons diretos (usar AppIcons)", icon_hits)
        section("2) Cores hardcoded (usar Theme.of(context).colorScheme.* ou tokens do tema)", color_hits)
        section("3) Texto hardcoded (usar l10n)", text_hits)

        if not icon_hits and not color_hits and not text_hits:
            w.write("\nSem findings\n")

    return report_path

# ---------- Main ----------
def main():
    root = Path.cwd()
    # tenta detetar a raiz (onde existe lib/)
    if not (root / LIB_DIRNAME).is_dir():
        # se o script estiver dentro de subpasta, usa a pasta-mãe que tenha lib/
        for parent in root.parents:
            if (parent / LIB_DIRNAME).is_dir():
                root = parent
                break
    assert (root / LIB_DIRNAME).is_dir(), "Corre este script a partir (ou dentro) da raiz do projeto (onde existe a pasta lib/)."

    dump_path = make_dump(root)
    report_path = audit_repo(root)

    print(f"=> Dump escrito em:   {dump_path}")
    print(f"=> Audit escrito em:  {report_path}")

if __name__ == "__main__":
    main()
