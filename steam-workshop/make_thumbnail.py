#!/usr/bin/env python3
"""Build thumbnail.png from the four bundled mods' own thumbnails.

A 2x2 grid of their previews (each already carries its own title and BEFORE / AFTER
labels) with an ALL-IN-ONE band between the two rows, quantised
to 256 colours so that the 1280x1280 image stays under Steam's 1 MB limit. The source
repositories must sit next to this one.

Usage: steam-workshop/make_thumbnail.py
"""
import pathlib
from PIL import Image, ImageDraw, ImageFont

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT.parent
FB = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
CREAM = (245, 238, 220)
SIZE, CELL, GAP, BAND = 1280, 590, 10, 100
MARGIN = (SIZE - 2 * CELL - GAP) // 2
GOLD = (222, 190, 120)
DARK = (18, 16, 14)
TILES = ["ck3-lowspec-terrain-fix", "ck3-lowspec-real-snow", "ck3-lowspec-water", "ck3-zoom-transition-fix"]


def main():
    out = Image.new("RGB", (SIZE, SIZE), DARK)
    for i, repo in enumerate(TILES):
        x = MARGIN + (i % 2) * (CELL + GAP)
        y = (i // 2) * (CELL + BAND)
        tile = Image.open(SRC / repo / "thumbnail.png").convert("RGB")
        out.paste(tile.resize((CELL, CELL), Image.LANCZOS), (x, y))
    d = ImageDraw.Draw(out)
    d.line([0, CELL + 4, SIZE, CELL + 4], fill=GOLD, width=4)
    d.line([0, CELL + BAND - 5, SIZE, CELL + BAND - 5], fill=GOLD, width=4)
    font = ImageFont.truetype(FB, 64)
    text = "ALL-IN-ONE"
    tw = d.textlength(text, font=font)
    d.text(((SIZE - tw) / 2, CELL + 14), text, font=font, fill=CREAM)
    out = out.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.FLOYDSTEINBERG)
    out.save(ROOT / "thumbnail.png", optimize=True)
    out.resize((200, 200), Image.LANCZOS).convert("RGB").save(ROOT / "steam-workshop" / "thumbnail-200px.png", optimize=True)


if __name__ == "__main__":
    main()
