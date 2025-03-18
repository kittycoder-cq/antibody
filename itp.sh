#!/bin/bash

# Define input and output files
INPUT_FILE="molecule_0.itp"   # Change this to your actual file
OUTPUT_FILE="processed_output_v8.itp"

# Define the range of lines to check (6050 to 11899)
START_LINE=6050
END_LINE=11899

# Define the list of numbers to check
NUMBERS=(['579' '801' '802' '803' '804' '805' '806' '1663' '1664' '1665' '1730' '1731' '1732' '1733' '1734' '1735' '1736' '1737' '1738' '1739' '1740' '1741' '1884' '1885' '1886' '1887' '1888' '1889' '1890' '2697' '2698' '2699' '2700' '2701' '2702' '2703' '2704' '2863' '2864' '2865' '2866' '2923' '2924' '2925' '2926' '2927' '2928' '2929' '2930' '2931' '2932' '2933' '2934' '2935' '2936' '2937' '2938' '2939' '2940' '2941' '3061' '3062' '3063' '3064' '3067' '3068' '3069' '3070' '3071' '3072' '3073' '3074' '3075' '3149' '3150' '3151' '3152' '3153')

# Process the file
awk -v start="$START_LINE" -v end="$END_LINE" -v numbers="${NUMBERS[*]}" '
BEGIN {
    split(numbers, num_list, " ")  # Convert space-separated list into an array
}
{
    line_number = NR  # Current line number
    count = 0
    found_numbers = ""
    
    # Only check lines in the specified range
    if (line_number >= start && line_number <= end) {
        for (i in num_list) {
            if (index($0, num_list[i]) > 0) {
                count++
                found_numbers = found_numbers " " num_list[i]
            }
        }
    }
    
    # Convert found numbers into an array and check the difference condition
    if (count >= 2) {
        split(found_numbers, num_array, " ")
        for (j = 1; j <= count; j++) {
            for (k = j + 1; k <= count; k++) {
                if (num_array[j] != "" && num_array[k] != "" && (num_array[j] - num_array[k] > 600 || num_array[k] - num_array[j] > 600)) {
                    print ";" $0
                    next
                }
            }
        }
    }
    
    print $0
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Processing complete. Modified file saved as $OUTPUT_FILE"
