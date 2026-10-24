#!/usr/bin/env python3
"""
Brand Asset Generator for Compad.
Generates:
  - assets/branding/icon_full.png (1024x1024, flattened on #3F3DDB, NO alpha)
  - assets/branding/icon_foreground.png (1024x1024, transparent, safe zone <= 66%)
  - assets/branding/icon_background.png (1024x1024, solid #3F3DDB)
  - assets/branding/icon_monochrome.png (1024x1024, single-color symbol on transparent)
  - assets/branding/splash_logo.png (transparent symbol for splash)
  - store_assets/play_store_icon_512.png (512x512, RGB no alpha)
  - store_assets/app_store_icon_1024.png (1024x1024, RGB no alpha)
"""

import os
import shutil
import numpy as np
from PIL import Image

INDIGO = (63, 61, 219) # #3F3DDB

def generate_assets(source_path, branding_dir, store_assets_dir):
    os.makedirs(branding_dir, exist_ok=True)
    os.makedirs(store_assets_dir, exist_ok=True)

    print(f"Loading source icon: {source_path}")
    src_img = Image.open(source_path).convert("RGB")
    src_w, src_h = src_img.size
    print(f"Original dimensions: {src_w}x{src_h}")

    # 1. Flattened icon_full.png (1024x1024, RGB no transparency)
    icon_full = src_img.resize((1024, 1024), Image.Resampling.LANCZOS).convert("RGB")
    icon_full_path = os.path.join(branding_dir, "icon_full.png")
    icon_full.save(icon_full_path, "PNG")
    print(f"Saved: {icon_full_path} (Mode: {icon_full.mode}, Size: {icon_full.size})")

    # 2. Extract transparent foreground symbol
    arr = np.array(src_img, dtype=np.float32)
    # Background indigo has low red/green channels (40-77).
    # White symbol has high R, G, B channels (>220).
    min_rgb = np.min(arr, axis=2)
    alpha = np.clip((min_rgb - 100.0) / (190.0 - 100.0), 0.0, 1.0) * 255.0
    alpha = alpha.astype(np.uint8)

    symbol_rgba = np.zeros((src_h, src_w, 4), dtype=np.uint8)
    symbol_rgba[:, :, 0] = 255
    symbol_rgba[:, :, 1] = 255
    symbol_rgba[:, :, 2] = 255
    symbol_rgba[:, :, 3] = alpha

    raw_symbol = Image.fromarray(symbol_rgba)
    bbox = raw_symbol.getbbox()
    cropped_symbol = raw_symbol.crop(bbox)
    sym_w, sym_h = cropped_symbol.size
    print(f"Extracted symbol bounding box: {bbox}, cropped size: {sym_w}x{sym_h}")

    # Android adaptive icon requirements: 1024x1024 canvas, symbol inside 66% safe zone (center 675x675)
    max_safe_size = int(1024 * 0.60) # 614px (well inside 66% = 675px)
    scale = min(max_safe_size / sym_w, max_safe_size / sym_h)
    new_w = int(sym_w * scale)
    new_h = int(sym_h * scale)
    scaled_symbol = cropped_symbol.resize((new_w, new_h), Image.Resampling.LANCZOS)

    icon_foreground = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    paste_x = (1024 - new_w) // 2
    paste_y = (1024 - new_h) // 2
    icon_foreground.paste(scaled_symbol, (paste_x, paste_y), scaled_symbol)
    
    fg_path = os.path.join(branding_dir, "icon_foreground.png")
    icon_foreground.save(fg_path, "PNG")
    print(f"Saved: {fg_path} (Safe zone scaled to {new_w}x{new_h})")

    # 3. Solid background icon_background.png
    icon_bg = Image.new("RGB", (1024, 1024), INDIGO)
    bg_path = os.path.join(branding_dir, "icon_background.png")
    icon_bg.save(bg_path, "PNG")
    print(f"Saved: {bg_path}")

    # 4. Monochrome symbol for Android 13+
    icon_monochrome = icon_foreground.copy()
    mono_path = os.path.join(branding_dir, "icon_monochrome.png")
    icon_monochrome.save(mono_path, "PNG")
    print(f"Saved: {mono_path}")

    # 5. Splash screen logo
    splash_size = 384
    splash_scale = min(splash_size / sym_w, splash_size / sym_h)
    sp_w = int(sym_w * splash_scale)
    sp_h = int(sym_h * splash_scale)
    splash_img = cropped_symbol.resize((sp_w, sp_h), Image.Resampling.LANCZOS)
    splash_path = os.path.join(branding_dir, "splash_logo.png")
    splash_img.save(splash_path, "PNG")
    print(f"Saved: {splash_path} ({sp_w}x{sp_h})")

    # 6. Store Assets
    # Google Play Store (512x512 PNG, RGB no alpha)
    play_store = icon_full.resize((512, 512), Image.Resampling.LANCZOS).convert("RGB")
    play_store_path = os.path.join(store_assets_dir, "play_store_icon_512.png")
    play_store.save(play_store_path, "PNG")
    print(f"Saved: {play_store_path} (Mode: {play_store.mode}, 512x512)")

    # Apple App Store (1024x1024 PNG, RGB no alpha)
    app_store_path = os.path.join(store_assets_dir, "app_store_icon_1024.png")
    icon_full.convert("RGB").save(app_store_path, "PNG")
    print(f"Saved: {app_store_path} (Mode: RGB, 1024x1024)")

if __name__ == "__main__":
    src = "compad/assets/branding/compad_app_icon.png"
    if not os.path.exists(src):
        src = "Compad App Icon.png"
    
    # Generate for compad project and root
    generate_assets(src, "compad/assets/branding", "compad/store_assets")
    generate_assets(src, "compad/assets/branding", "store_assets")
    print("\nAll brand assets generated successfully!")
