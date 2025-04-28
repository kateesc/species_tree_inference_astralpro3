#!/bin/bash

################################################################################
# Species Tree Inference Using ASTRAL-Pro3
#
# Description:
# This script generates a species tree using ASTRAL-Pro3 from a set of cleaned
# gene trees (after duplication handling). Posterior probabilities are included.
#
# Requirements:
#   - ASTRAL-Pro3 installed (here accessed through ASTER module).
#   - Gene trees for all BUSCO loci after cleaning (_fixed.treefile files).
#   - A species mapping file linking gene copies to species names.
#
# Input Assumptions:
#   - GENE_TREES_DIR contains *_fixed.treefile gene trees from IQ-TREE outputs.
#   - SPECIES_MAPPING is a two-column tab-separated file: [gene copy] [species].
#
# Outputs:
#   - Concatenated gene trees file (gene.trees).
#   - Final species tree (species_tree.tre) with posterior probabilities.
#
################################################################################

# Load required modules
module load tools
module load aster/20250224    # Module that provides access to ASTRAL-Pro3

# Define paths (customize according to your project)
GENE_TREES_DIR="/.../Gene_Trees"                                 # Folder with *_fixed.treefile outputs
GENE_TREES_FILE="$GENE_TREES_DIR/gene.trees"                     # Combined gene trees file
OUTPUT_TREE="$GENE_TREES_DIR/species_tree.tre"                   # Output species tree
SPECIES_MAPPING="/.../Mapping_File/species_mapping_cleaned.txt"  # Species mapping file

# Ensure output directory exists
mkdir -p "$GENE_TREES_DIR"

# Step 1: Collect all *_fixed.treefile into a single file
echo "Collecting all cleaned gene trees into gene.trees..."

> "$GENE_TREES_FILE"  # Clear previous gene.trees if it exists

tree_count=0
for tree_file in "$GENE_TREES_DIR"/*_fixed.treefile; do
    if [[ -f "$tree_file" ]]; then
        cat "$tree_file" >> "$GENE_TREES_FILE"
        ((tree_count++))
    fi
done

# Check if trees were successfully collected
if [ ! -s "$GENE_TREES_FILE" ]; then
    echo "ERROR: gene.trees file is empty or missing!" >&2
    exit 1
fi

echo "Successfully collected $tree_count gene trees into gene.trees!"

# Step 2: Run ASTRAL-Pro3
echo "Running ASTRAL-Pro3 with posterior probabilities..."

astral-pro3 \
    -i "$GENE_TREES_FILE" \
    -o "$OUTPUT_TREE" \
    -a "$SPECIES_MAPPING" \
    -u 2 \
    -v 2 \
    --seed 233 \
    --output-pp  # Include posterior probabilities in output

# Step 3: Check if ASTRAL-Pro3 ran successfully
if [ $? -eq 0 ]; then
    echo "ASTRAL-Pro3 species tree estimation completed successfully!"
else
    echo "ERROR: ASTRAL-Pro3 failed!" >&2
    exit 1
fi
