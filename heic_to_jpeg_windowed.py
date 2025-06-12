import sys
import os
import pillow_heif
from PIL import Image

pillow_heif.register_heif_opener()

def heic_to_jpeg_silent(heic_file_path, quality=70):
    """Convert a single HEIC file to JPEG format silently."""
    try:
        if not os.path.exists(heic_file_path):
            return False
            
        image = Image.open(heic_file_path)
        jpeg_file_path = heic_file_path.rsplit('.', 1)[0] + '.jpg'
        image.save(jpeg_file_path, "JPEG", quality=quality)
        return True
    except Exception as e:
        return False

if __name__ == "__main__":
    # Ultra-simple windowed version - no coalescing, just convert one file
    if len(sys.argv) != 2:
        sys.exit(1)
    
    file_path = sys.argv[1]
    if not os.path.exists(file_path) or not file_path.lower().endswith(('.heic', '.heif')):
        sys.exit(1)
      # Convert the file silently
    if heic_to_jpeg_silent(file_path, 70):
        sys.exit(0)
    else:
        sys.exit(1)
