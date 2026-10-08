# Steam Workshop publishing kit

Everything needed for the Steam Workshop and Paradox Mods listings. Nothing here ships with the mod
itself — the mod is `descriptor.mod`, `thumbnail.png`, `gfx/` and `common/` in the repository root.

| File | Where it goes |
| --- | --- |
| `description-en.txt` | Workshop item description (BBCode) |
| `description-ru.txt` | Russian version of the same description |
| `description-paradoxmods-en.txt` | same text without BBCode, for the Paradox Mods site |
| `description-paradoxmods-ru.txt` | Russian version without BBCode |
| `short-description-en.txt` | Launcher / Paradox Mods short description, under 200 chars |
| `short-description-ru.txt` | Russian short description, under 200 chars |
| `make_thumbnail.py` | rebuilds `thumbnail.png` from the four bundled mods' thumbnails |

The Paradox Mods files are **generated** from the Steam ones by `tools/bbcode_to_plain.py`;
edit the BBCode version and re-run it rather than editing them directly.

**Do not use `[code]` in the Steam files.** Steam has no inline code tag — it renders `[code]` as a
full-width block. Identifiers are written as plain text instead.

## Listing metadata

* **Title:** All-in-One Map Pack Without Advanced Shaders
* **Tags:** Fixes, Graphics, Utilities — same as `descriptor.mod`
* **Version:** 1.0.0, `supported_version="1.20.*"`
* **Visibility:** public
* **Collections:** none. The vanilla collection lists the four separate mods; the pack is offered
  as an option in their descriptions and in the guide.

The Russian description must stay under Steam's 8000 **byte** limit (Cyrillic is two bytes per
character); a longer text fails silently and the page keeps showing English.

## Preview image on Steam

The launcher picks up `thumbnail.png` from the mod root (next to `descriptor.mod`), which is what
`picture="thumbnail.png"` in the descriptor points at. Images added to the item's gallery on the
website do not replace it. After changing it, re-run `install.sh` and upload again from the launcher.

## Rebuilding the thumbnail

`make_thumbnail.py` puts the four source repositories' `thumbnail.png` files into a 2x2 grid with an
ALL-IN-ONE band between the rows, 1280x1280, quantised to 256 colours so that it stays under Steam's
1 MB limit (about 470 KB). The image is rebuilt from raw pixels and carries no metadata; verify a
replacement with

    python3 -c "from PIL import Image; im=Image.open('thumbnail.png'); print(len(im.getexif()), im.info)"
