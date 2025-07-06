#!/bin/bash

# Function to count lines in Dart files for a given directory
count_lines() {
    local dir="$1"
    local total_lines=0
    
    # Find all .dart files recursively, excluding generated files and specific patterns
    while IFS= read -r -d '' file; do
        # Skip generated files and specific patterns
        if [[ "$file" == *.g.dart ]] || \
           [[ "$file" == *todos_repository* ]] || \
           [[ "$file" == *file_storage* ]] || \
           [[ "$file" == *web_client* ]] || \
           [[ "$file" == *main_* ]]; then
            continue
        fi
        
        # Count non-comment, non-empty lines
        local file_lines=$(grep -v '^[[:space:]]*//' "$file" | grep -v '^[[:space:]]*$' | wc -l)
        total_lines=$((total_lines + file_lines))
    done < <(find "$dir/lib" -name "*.dart" -type f -print0 2>/dev/null)
    
    echo "$total_lines"
}

# Function to count lines for multiple directories
count_lines_for_dirs() {
    local total=0
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            local lines=$(count_lines "$dir")
            total=$((total + lines))
        fi
    done
    echo "$total"
}

# Define samples as a single array of objects (name:dirs format)
samples=(
    "change_notifier_provider:change_notifier_provider"
    "bloc:bloc_flutter blocs"
    "bloc library:bloc_library"
    "built_redux:built_redux"
    "firestore_redux:firestore_redux"
    "frideos_library:frideos_library"
    "inherited_widget:inherited_widget"
    "mobx:mobx"
    "mvi:mvi_flutter mvi_base"
    "redux:redux"
    "scoped_model:scoped_model"
    "simple blocs:simple_bloc_flutter simple_blocs"
    "vanilla:vanilla"
)

# Collect results
results=()

for sample in "${samples[@]}"; do
    name=$(echo "$sample" | cut -d: -f1)
    dirs=$(echo "$sample" | cut -d: -f2)
    line_count=$(count_lines_for_dirs $dirs)
    results+=("$line_count $name")
done

# Sort results by line count
IFS=$'\n' sorted_results=($(sort -n <<<"${results[*]}"))
unset IFS

# Generate output
echo "# Line Counts"
echo ""
echo "Though not the only factor or even most important factor, the amount of code it"
echo "takes to achieve a working product is an important consideration when comparing"
echo "frameworks."
echo ""
echo "This is an imperfect line count comparison -- some of the samples contain a bit"
echo "more functionality / are structured a bit differently than others -- and should"
echo "be taken with a grain of salt. All generated files, blank lines and comment"
echo "lines are removed for this comparison."
echo ""
echo "For authors of frameworks or samples (hey, I'm one of those!): Please do not"
echo "take this comparison personally, nor should folks play \"Code Golf\" with the"
echo "samples to make them smaller, unless doing so improves the application overall."
echo ""
echo "| *Sample* | *LOC (no comments)* |"
echo "|--------|-------------------|"

# Output sorted results
for result in "${sorted_results[@]}"; do
    line_count=$(echo "$result" | awk '{print $1}')
    name=$(echo "$result" | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/ $//')
    echo "| $name | $line_count |"
done

echo ""
echo "Note: This file was generated on $(date -u) using \`scripts/line_counter.sh\`." 
