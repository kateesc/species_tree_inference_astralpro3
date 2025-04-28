#!/bin/bash

################################################################################
# Batch Amino Acid Sequence Alignment Script
#
# Description:
# This script batch-aligns BUSCO gene amino acid sequences using MAFFT (linsi).
#
# Requirements:
#   - Environment/module system (e.g., Lmod) to load software modules.
#   - MAFFT installed and accessible (this script uses version 7.525).
#
# Input Assumptions:
#   - A directory structure where each BUSCO locus has its own folder.
#   - Inside each locus folder, a FASTA file named exactly as <locus_name>.fa.
#     Example:
#       /path_to_grouped_sequences/
#         ├── 116811at71240/
#         │     └── 116811at71240.fa
#         ├── 118488at71240/
#         │     └── 118488at71240.fa
#
# Output:
#   - Aligned FASTA files stored in a specified output directory.
#   - Log file of any failed alignments.
#
################################################################################

# Load necessary modules (adjust module names based on your cluster setup)
module load tools ngs        # General NGS tools (depends on your system)
module load mafft/7.525      # Load MAFFT specifically for linsi

# Set working directories
BASE_DIR="/path_to_grouped_sequences"  # Directory containing BUSCO loci folders
ALIGNED_OUTPUT_DIR="/home/projects/ku_00297/data/Kate/Thesis/Aligned_BUSCO_Genes_AA"

# Create the output directory if it doesn't exist
mkdir -p "$ALIGNED_OUTPUT_DIR"

# Initialize a log file to record failed alignments
FAILED_LOG="$ALIGNED_OUTPUT_DIR/failed_alignments_AA.log"
> "$FAILED_LOG"  # Clear previous log if it exists

echo "Searching for BUSCO loci in: $BASE_DIR"

# Loop over each BUSCO locus directory
for locus_dir in "$BASE_DIR"/*/; do
    locus_name=$(basename "$locus_dir")  # Get folder name (assumed locus ID)
    fasta_file="$locus_dir/$locus_name.fa"  # Expected file: locus_dir/locus_name.fa

    # Check if the expected .fa file exists
    if [ ! -f "$fasta_file" ]; then
        echo "Skipping: No FASTA file found in $locus_dir"
        continue
    fi

    aligned_file="$ALIGNED_OUTPUT_DIR/${locus_name}.fasta"  # Define output alignment file path

    # Check if this alignment has already been done
    if [ -e "$aligned_file" ]; then
        echo "Alignment already exists: $aligned_file. Skipping."
        continue
    fi

    echo "Running alignment for $fasta_file..."

    # Run MAFFT linsi alignment with 40 CPU threads
    linsi --thread 40 "$fasta_file" > "$aligned_file"

    # Check if alignment completed successfully
    if [ $? -eq 0 ]; then
        echo "Alignment completed successfully: $aligned_file"
    else
        echo "Alignment failed for: $fasta_file" | tee -a "$FAILED_LOG"
    fi
done

echo "Batch alignment process finished. Failed alignments are logged in: $FAILED_LOG"
