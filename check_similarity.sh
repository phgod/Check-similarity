#!/bin/bash
# Simple script to check for highly similar PDF submissions using pairwise comparisons
# Syntax: ./check_similarity.sh
# (Assuming that all the PDF files are put under the SUBMISSIONS folder.)

TOLERANCE=10 # Start with 10 and increase gradually if nothing is found

SAVEIFS=$IFS;IFS=$(echo -en "\n\b");
for f1 in SUBMISSIONS/*; do
    for f2 in SUBMISSIONS/*; do
        if [[ "$f1" < "$f2" ]]; then
          DIFF=$(diff -w -B <(pdftotext -layout $f1 /dev/stdout) <(pdftotext -layout $f2 /dev/stdout)| wc -l)
          if (($DIFF <= $TOLERANCE)); then
            echo "SIMILAR (DIFF=$DIFF):"
            echo "   $f1"
            echo "   $f2"
            diffpdf $f1 $f2 # Display the two files in diffpdf for comparison
          fi
        fi
      done
  done
IFS=$SAVEIFS
