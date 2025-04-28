#!/bin/bash

################################################################################
# Codon-Aware Alignment of BUSCO Gene Sequences Using HyPhy
#
# Description:
# This script codon-aligns BUSCO gene nucleotide sequences based on
# precomputed amino acid (AA) alignments using HyPhy's codon-msa tool.
#
# Requirements:
#   - Module system (Lmod) or environment where HyPhy (v2.5.65+) is available.
#   - Access to HyPhy's codon-msa script: post-msa.bf.
#
# Input Assumptions:
#   - AA_ALIGNMENTS_DIR contains amino acid alignments (aligned using MAFFT).
#   - NT_SEQUENCES_DIR contains nucleotide sequences (unaligned), matching by name.
#     (example: AA alignment 116811at71240.fasta matches NT 116811at71240.fa)
#
# Outputs:
#   - Codon-aware nucleotide alignments written to OUTPUT_DIR.
#   - Log errors if files are missing or have issues.
#
################################################################################

# Load required modules
module load tools ngs
module load hyphy/2.5.65

# Define paths (must be customized)
HYPHY_SCRIPT="/.../hyphy-analyses/codon-msa/post-msa.bf"  # Path to HyPhy's post-msa.bf script
AA_ALIGNMENTS_DIR="/.../Aligned_BUSCO_Genes_AA"          # Aligned amino acid sequences
NT_SEQUENCES_DIR="/.../Grouped_BUSCO_Genes_nucleotide"   # Unaligned nucleotide sequences
OUTPUT_DIR="/.../Aligned_BUSCO_Genes_nuc"                # Output directory for aligned nucleotides

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Move to the directory containing amino acid alignments
cd "$AA_ALIGNMENTS_DIR" || { echo "ERROR: Cannot access AA alignments directory"; exit 1; }

echo "Checking for missing nucleotide (NT) sequence files..."
MISSING_COUNT=0

# Verify that every AA alignment has a corresponding NT sequence
for FILE in *.fasta; do
    BASENAME=$(basename "$FILE" .fasta)
    NT_FILE=$(find "$NT_SEQUENCES_DIR" -type f -name "${BASENAME}.fa")

    if [ ! -f "$NT_FILE" ]; then
        echo "WARNING: Missing NT sequence for $BASENAME"
        MISSING_COUNT=$((MISSING_COUNT+1))
    fi
done

# Exit if any NT sequences are missing
if [ "$MISSING_COUNT" -gt 0 ]; then
    echo "ERROR: Some nucleotide files are missing. Check warnings above."
    exit 1
fi

echo "All NT files are present."

# Optional: Check sequence headers match (This section could be skipped for speed if you trust your input)
# Sorting headers to detect any mismatches
echo "Sorting sequence headers to check matching order (optional check)..."

for FILE in "$AA_ALIGNMENTS_DIR"/*.fasta; do
    awk '/^>/{print $0; next} {printf "%s",$0} END {print ""}' "$FILE" | sort > "${FILE}.sorted"
done

find "$NT_SEQUENCES_DIR" -type f -name "*.fa" | while read -r FILE; do
    awk '/^>/{print $0; next} {printf "%s",$0} END {print ""}' "$FILE" | sort > "${FILE}.sorted"
done

# Compare sorted headers
diff "$AA_ALIGNMENTS_DIR"/*.sorted "$NT_SEQUENCES_DIR"/*.sorted > header_differences.txt

if [ -s header_differences.txt ]; then
    echo "ERROR: Header mismatches detected! Check 'header_differences.txt'."
    exit 1
fi

echo "Headers match! Proceeding..."

# Ensure all NT sequences are multiples of 3 (codon length requirement)
echo "Checking nucleotide sequence lengths (should be multiple of 3 bases)..."

find "$NT_SEQUENCES_DIR" -type f -name "*.fa" | while read -r NT_FILE; do
    SEQ_LEN=$(awk '!/^>/ {print length}' "$NT_FILE" | awk '{sum+=$1} END {print sum}')
    if [ $((SEQ_LEN % 3)) -ne 0 ]; then
        echo "ERROR: NT file $NT_FILE has invalid sequence length (not a multiple of 3)."
        exit 1
    fi
done

echo "All NT sequences have valid codon lengths."

# Main processing: Codon-align each BUSCO gene with HyPhy
for FILE in *.fasta; do
    BASENAME=$(basename "$FILE" .fasta)

    AA_ALIGNMENT="${AA_ALIGNMENTS_DIR}/${FILE}"
    NT_SEQUENCE=$(find "$NT_SEQUENCES_DIR" -type f -name "${BASENAME}.fa")
    OUTPUT_ALIGNMENT="${OUTPUT_DIR}/${BASENAME}.fasta"

    if [ ! -s "$AA_ALIGNMENT" ]; then
        echo "Skipping $BASENAME: AA file is empty"
        continue
    fi
    if [ ! -s "$NT_SEQUENCE" ]; then
        echo "Skipping $BASENAME: NT file is empty"
        continue
    fi

    echo "Running HyPhy for $BASENAME..."
    hyphy "$HYPHY_SCRIPT" \
        --protein-msa "$AA_ALIGNMENT" \
        --nucleotide-sequences "$NT_SEQUENCE" \
        --output "$OUTPUT_ALIGNMENT" \
        --translate-labels No \
        --skip-unaligned-sequences No \
        --minimum-sequence-length 1

    echo "Finished processing: $BASENAME"
done

echo "Codon-aware alignment completed for all BUSCO genes!"
