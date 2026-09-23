"""Builds the Android launcher icons from assets/icon/app_icon.png.

The source is a 1254 px mockup: a rounded-square icon drawn on a dark backdrop.
We crop the square and produce
  - legacy icons (Android < 8): the rounded square as drawn, transparent corners
  - adaptive icon foreground (Android 8+): artwork scaled into the mask's safe
    zone, edges feathered into the icon's navy so no seam shows under any mask
  - a 512 px Play Store icon (upload it in Play Console)

Run from apps/mobile after replacing the source:  python tool/make_launcher_icons.py
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SRC = Path("assets/icon/app_icon.png")
RES = Path("android/app/src/main/res")
DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}

# Measured on the source: the drawn rounded square and its corner radius.
SQUARE = (80, 76, 1172, 1168)
CORNER = 210
# Inset crop that drops the square's glowing border (used for full-bleed art).
INNER = (122, 118, 1130, 1126)
NAVY = (13, 12, 42)
# Adaptive icons are 108 dp; the artwork square is drawn this big so the logo
# and wordmark stay inside the 66 dp safe circle.
ADAPTIVE_ART_DP = 61


def feathered(img: Image.Image, size: int, feather: int) -> Image.Image:
    """img resized to size, faded to NAVY over `feather` px at every edge."""
    art = img.resize((size, size), Image.LANCZOS)
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rectangle(
        (feather, feather, size - feather, size - feather), fill=255
    )
    mask = mask.filter(ImageFilter.GaussianBlur(feather / 2))
    out = Image.new("RGB", (size, size), NAVY)
    out.paste(art, (0, 0), mask)
    return out


def main() -> None:
    src = Image.open(SRC).convert("RGB")
    square = src.crop(SQUARE)
    inner = src.crop(INNER)

    # Legacy: the rounded square as designed.
    rounded_mask = Image.new("L", square.size, 0)
    ImageDraw.Draw(rounded_mask).rounded_rectangle(
        (0, 0, square.width - 1, square.height - 1), radius=CORNER, fill=255
    )
    legacy = square.convert("RGBA")
    legacy.putalpha(rounded_mask)

    for name, scale in DENSITIES.items():
        d = RES / f"mipmap-{name}"
        d.mkdir(parents=True, exist_ok=True)
        px = round(48 * scale)
        legacy.resize((px, px), Image.LANCZOS).save(d / "ic_launcher.png", optimize=True)

        canvas_px = round(108 * scale)
        art_px = round(ADAPTIVE_ART_DP * scale)
        fg = Image.new("RGB", (canvas_px, canvas_px), NAVY)
        off = (canvas_px - art_px) // 2
        fg.paste(feathered(inner, art_px, max(2, art_px // 14)), (off, off))
        fg.save(d / "ic_launcher_foreground.png", optimize=True)

    feathered(inner, 512, 24).save(Path("assets/icon/play_store_512.png"), optimize=True)


if __name__ == "__main__":
    main()
