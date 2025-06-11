import sys
import os
import glob
import argparse
import pillow_heif
from PIL import Image

pillow_heif.register_heif_opener()

def heic_to_jpeg(heic_file_path, quality=95):
    """Convert a single HEIC file to JPEG format."""
    try:
        if not os.path.exists(heic_file_path):
            print(f"Error: File not found: {heic_file_path}")
            return False
            
        image = Image.open(heic_file_path)
        jpeg_file_path = heic_file_path.rsplit('.', 1)[0] + '.jpg'
        image.save(jpeg_file_path, "JPEG", quality=quality)
        print(f"✓ Converted {heic_file_path} to {jpeg_file_path}")
        return True
    except Exception as e:
        print(f"✗ Error converting {heic_file_path}: {str(e)}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Convert HEIC images to JPEG format',
        epilog='''Examples:
  %(prog)s photo.heic
  %(prog)s photo1.heic photo2.heic photo3.heic
  %(prog)s *.heic''',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument('files', nargs='+', help='HEIC file(s) to convert. Supports wildcards.')
    parser.add_argument('--quality', type=int, default=95, help='JPEG quality (1-100, default: 95)')
    parser.add_argument('--overwrite', action='store_true', help='Overwrite existing JPEG files')
    
    args = parser.parse_args()
      # Expand wildcards
    all_files = []
    for pattern in args.files:
        # Use glob to expand wildcards
        matches = glob.glob(pattern)
        if matches:
            all_files.extend(matches)
        else:
            # If no wildcard matches, check if it's actually a wildcard pattern
            if '*' in pattern or '?' in pattern:
                # It's a wildcard pattern but no matches found
                print(f"No files found matching pattern: {pattern}")
            else:
                # It's a direct file path, add as-is
                all_files.append(pattern)
    
    if not all_files:
        print("No files found to convert.")
        return 1
    
    # Filter for HEIC files and provide better error messages
    heic_files = []
    non_heic_files = []
    
    for f in all_files:
        if f.lower().endswith(('.heic', '.heif')):
            heic_files.append(f)
        else:
            non_heic_files.append(f)
    
    if non_heic_files:
        print(f"Skipping {len(non_heic_files)} non-HEIC files:")
        for f in non_heic_files:
            print(f"  - {f}")
        print()
    
    if not heic_files:
        print("No HEIC files found in the specified files.")
        return 1
    
    print(f"Found {len(heic_files)} HEIC file(s) to convert:")
    for f in heic_files:
        print(f"  - {f}")
    print()
    
    success_count = 0
    for heic_file in heic_files:
        jpeg_file = heic_file.rsplit('.', 1)[0] + '.jpg'
        
        if os.path.exists(jpeg_file) and not args.overwrite:
            print(f"⚠ Skipped {heic_file} (JPEG already exists, use --overwrite to replace)")
            continue
            
        if heic_to_jpeg(heic_file, args.quality):
            success_count += 1
    
    print(f"\nConversion complete: {success_count}/{len(heic_files)} files converted successfully.")
    return 0 if success_count > 0 else 1

if __name__ == "__main__":
    # Legacy support for single file argument (for context menu compatibility)
    # Only use legacy mode for actual files (not wildcards) and when the file exists
    if (len(sys.argv) == 2 and not sys.argv[1].startswith('-') and 
        '*' not in sys.argv[1] and '?' not in sys.argv[1] and 
        os.path.exists(sys.argv[1])):
        if heic_to_jpeg(sys.argv[1], 95):
            sys.exit(0)
        else:
            sys.exit(1)
    else:
        sys.exit(main())
