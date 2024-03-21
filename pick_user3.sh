#!/bin/bash
# Pick User -  Randomly assign a list of tickets to three users. Used for quarterly sox tickets.
# 20220103 - jah - created
# 20220620 - jah - use gshuf on apple macos (requires macports coreutils install)
# 20240321 - jah - rewrite pick_user to support 3 users (pick_user3)

[ "$1" = "" ] && echo "No list provided." && exit 1

# macos check
[ `uname` = "Darwin" ] && alias shuf='gshuf'

shuf $1 >/dev/null 2>&1
[ $? -gt 0 ] && echo "Shuf test failed.  Something went wrong." && exit 1

echo "The List:"
cat $1
echo

# randomize the list
cat $1 | shuf >$1.random

input_file="$1.random"

# Read the lines of the file into an array
mapfile -t lines < "$input_file"

# Calculate the total number of lines
total_lines="${#lines[@]}"

# Calculate the number of lines each person should get
lines_per_person=$((total_lines / 3))

# Calculate the remainder after dividing the lines equally
remainder=$((total_lines % 3))

# Initialize variables
start_index=0
end_index=0

for ((i = 0; i < 3; i++)); do
    # Calculate the end index for the current person
    end_index=$((start_index + lines_per_person + (i < remainder ? 1 : 0)))

    # Print the portion of the file assigned to the current person
    printf "Person %d's portion:\n" "$((i+1))"
    for ((j = start_index; j < end_index; j++)); do
        printf "%s\n" "${lines[j]}"
    done
    printf "\n"

    # Update the start index for the next person
    start_index=$end_index
done

