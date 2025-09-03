#!/bin/bash

# This script loops through subdirectories to find Flutter projects,
# cleans them by removing platform-specific folders,
# recreates the Flutter project files, and then removes an unnecessary test file.

# Find all directories one level deep from the current location.
for dir in */; do
  # Ensure we are only processing actual directories.
  if [ -d "$dir" ]; then
    echo "🔎 Processing directory: $dir"

    pubspec_file="${dir}pubspec.yaml"

    # 1. Check if pubspec.yaml exists and contains a 'flutter:' dependency.
    if [ -f "$pubspec_file" ] && grep -q "flutter:" "$pubspec_file"; then
      echo "  ✅ Found pubspec.yaml with a Flutter dependency."

      # 2. Check if it's a valid project by looking for platform folders.
      if [ -d "${dir}ios" ] || [ -d "${dir}android" ] || [ -d "${dir}web" ] || \
         [ -d "${dir}macos" ] || [ -d "${dir}windows" ] || [ -d "${dir}linux" ]; then
        
        echo "  ✅ Found platform folders. Proceeding with cleanup..."

        # Using a subshell to change directory, so we don't have to 'cd ..'
        (
          cd "$dir" || exit

          # 3. Remove the old platform folders.
          echo "  Removing platform folders: ios, android, web, macos, windows, linux"
          rm -rf ios android web macos windows linux

          # 4. Recreate the Flutter project in the current directory.
          echo "  🚀 Running 'fvm flutter create .'"
          fvm flutter create .

          # 5. Remove the default widget test file.
          widget_test_file="test/widget_test.dart"
          if [ -f "$widget_test_file" ]; then
            echo "  🗑️ Removing generated file: $widget_test_file"
            rm "$widget_test_file"
          fi

          echo "  ✨ Successfully processed project in $dir"
        )
      else
        echo "  ⏭️  Skipping: No platform folders found."
      fi
    else
      echo "  ⏭️  Skipping: Not a Flutter project."
    fi
    echo "--------------------------------------------------"
  fi
done

echo "All directories have been processed."
