import sys
import os

# Delegate to compad/tools/generate_icons/generate_brand_assets.py
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../compad/tools/generate_icons")))
from generate_brand_assets import generate_assets

if __name__ == "__main__":
    src = "Compad App Icon.png"
    if not os.path.exists(src):
        src = "compad/assets/branding/compad_app_icon.png"
    generate_assets(src, "compad/assets/branding", "compad/store_assets")
    generate_assets(src, "compad/assets/branding", "store_assets")
