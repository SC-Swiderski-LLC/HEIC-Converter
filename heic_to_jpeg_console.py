import sys
import os
import glob
import argparse
import pillow_heif
from PIL import Image

pillow_heif.register_heif_opener()

def heic_to_jpeg(heic_file_path, quality=95, verbose=True):
    """Convert a single HEIC file to JPEG format."""
    try:
        if not os.path.exists(heic_file_path):
            if verbose:
                print(f"Error: File '{heic_file_path}' does not exist.")
            return False
            
        if verbose:
            print(f"Converting {heic_file_path}...")
        
        image = Image.open(heic_file_path)
        jpeg_file_path = heic_file_path.rsplit('.', 1)[0] + '.jpg'
        image.save(jpeg_file_path, "JPEG", quality=quality)
        
        if verbose:
            print(f"\u2713 Successfully converted to {jpeg_file_path}")
        return True
        
    except Exception as e:
        if verbose:
            print(f"\u2717 Error converting '{heic_file_path}': {e}")
        return False

def expand_wildcards(patterns):
    """Expand wildcard patterns to file paths."""
    all_files = []
    for pattern in patterns:
        if '*' in pattern or '?' in pattern:
            # Use glob to expand wildcards
            expanded = glob.glob(pattern)
            if expanded:
                all_files.extend(expanded)
            else:
                # No matches found for this pattern
                print(f"Warning: No files match pattern '{pattern}'")
        else:
            # Not a wildcard, add as is
            all_files.append(pattern)
    return all_files

def main():
    parser = argparse.ArgumentParser(description="Convert HEIC images to JPEG format")
    parser.add_argument("files", nargs="+", help="HEIC file(s) to convert. Supports wildcards.")
    parser.add_argument("--quality", type=int, default=95, 
                       help="JPEG quality (1-100, default: 95)")
    parser.add_argument("--overwrite", action="store_true",
                       help="Overwrite existing JPEG files")
    
    args = parser.parse_args()
    
    if args.quality < 1 or args.quality > 100:
        print("Error: Quality must be between 1 and 100")
        sys.exit(1)
    
    # Expand wildcards in file patterns
    file_paths = expand_wildcards(args.files)
    
    # Filter for HEIC files that exist
    heic_files = []
    for file_path in file_paths:
        if os.path.exists(file_path) and file_path.lower().endswith(('.heic', '.heif')):
            heic_files.append(file_path)
        elif os.path.exists(file_path):
            print(f"Skipping '{file_path}': Not a HEIC file")
        else:
            print(f"Warning: File '{file_path}' does not exist")
    
    if not heic_files:
        print("Error: No valid HEIC files found")
        sys.exit(1)
    
    print(f"Found {len(heic_files)} HEIC file(s) to convert")
    print()
    
    # Convert files
    success_count = 0
    for heic_file in heic_files:
        jpeg_file_path = heic_file.rsplit('.', 1)[0] + '.jpg'
        
        # Check if output file exists and overwrite flag
        if os.path.exists(jpeg_file_path) and not args.overwrite:
            print(f"Skipping {heic_file}: {jpeg_file_path} already exists (use --overwrite to replace)")
            continue
            
        if heic_to_jpeg(heic_file, args.quality):
            success_count += 1
    
    print()
    print(f"Conversion complete: {success_count}/{len(heic_files)} files converted successfully")
    
    if success_count == len(heic_files):
        sys.exit(0)
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()
