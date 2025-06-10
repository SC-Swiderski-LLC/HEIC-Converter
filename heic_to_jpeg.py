import sys
import pillow_heif
from PIL import Image

pillow_heif.register_heif_opener()

def heic_to_jpeg(heic_file_path):
    image = Image.open(heic_file_path)
    jpeg_file_path = heic_file_path.rsplit('.', 1)[0] + '.jpg'
    image.save(jpeg_file_path, "JPEG")
    print(f"Converted {heic_file_path} to {jpeg_file_path}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python heic_to_jpeg.py <path_to_heic_file>")
    else:
        heic_to_jpeg(sys.argv[1])
