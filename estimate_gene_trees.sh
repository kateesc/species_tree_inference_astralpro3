#!/bin/bash

################################################################################
# BUSCO Gene Tree Estimation Using IQ-TREE2 (Parallelized on Subsets)
#
# Description:
# This script estimates gene trees from codon-aware nucleotide alignments
# produced by HyPhy, using IQ-TREE2 with model selection (MFP) and bootstrap support.
# The dataset is **partitioned into subsets** to run multiple IQ-TREE jobs in parallel,
# speeding up the computation significantly.
#
# Requirements:
#   - IQ-TREE2 installed (v2.2.2.7 or higher).
#   - Module system (Lmod) available, or manually accessible binaries.
#
# Input Assumptions:
#   - ALIGNMENT_DIR contains codon-aligned nucleotide BUSCO gene files (*.fasta).
#   - SPLIT_LIST_DIR contains text files (list_part_*.txt), each listing a subset of alignments.
#     (Example: list_part_1.txt contains names like 116811at71240.fasta, one per line)
#
# Outputs:
#   - Individual gene trees (.treefile) stored in OUTPUT_DIR.
#   - A concatenated file "gene.trees" containing all estimated trees.
#   - A run log tracking success or failure of each estimation.
#
################################################################################

# Load necessary modules
module load tools ngs
module load iqtree/2.2.2.7

# Define paths (adjust according to your environment)
ALIGNMENT_DIR="/.../Aligned_BUSCO_Genes_nuc"    # Codon-aware BUSCO alignments
SPLIT_LIST_DIR="/.../subsets"                   # Subsets of genes (partitioned for parallel processing)
OUTPUT_DIR="/.../Gene_Trees"                    # Where individual trees and logs are stored
TREE_FILE="$OUTPUT_DIR/gene.trees"              # Final combined tree file

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Move to alignment directory
cd "$ALIGNMENT_DIR" || { echo "ERROR: Cannot access alignment directory: $ALIGNMENT_DIR"; exit 1; }

# Initialize log file
LOG_FILE="$OUTPUT_DIR/iqtree_run.log"
> "$LOG_FILE"  # Clear any previous logs

echo "Running IQ-TREE2 gene tree estimation on 11 subsets in parallel..."

# Loop over each subset (list_part_*.txt)
for list_file in "$SPLIT_LIST_DIR"/list_part_*.txt; do
    (
    subset_name=$(basename "$list_file" .txt)

    echo "Processing subset: $subset_name" | tee -a "$LOG_FILE"

    while read -r gene_name; do
        clean_name=$(echo "$gene_name" | tr -d '\r' | xargs)  # Clean extra spaces or carriage returns
        alignment="$ALIGNMENT_DIR/$clean_name"

        # Check if alignment file exists
        if [ -f "$alignment" ]; then
            gene_base=$(basename "$clean_name" .fasta)
            output_prefix="$OUTPUT_DIR/$gene_base"

            # Skip if tree already exists
            if [ -e "$output_prefix.treefile" ]; then
                echo "Tree already exists for: $gene_base. Skipping." | tee -a "$LOG_FILE"
                continue
            fi

            echo "Estimating gene tree for: $gene_base..." | tee -a "$LOG_FILE"

            # Run IQ-TREE2
            iqtree2 -s "$alignment" -m MFP -B 1000 -T 4 -pre "$output_prefix"

            if [ $? -eq 0 ]; then
                echo "Successfully estimated tree for: $gene_base" | tee -a "$LOG_FILE"
            else
                echo "IQ-TREE2 failed for: $gene_base" | tee -a "$LOG_FILE"
            fi
        else
            echo "Alignment file not found: $alignment" | tee -a "$LOG_FILE"
        fi
    done < "$list_file"

    echo "Finished subset: $subset_name" | tee -a "$LOG_FILE"
    ) &
done

# Wait for all background parallel jobs to finish
wait

# Combine all gene trees into a single file
echo "Combining all estimated gene trees into: $TREE_FILE"
cat "$OUTPUT_DIR"/*.treefile > "$TREE_FILE"

echo "Gene tree estimation process finished. Logs available at: $LOG_FILE"
