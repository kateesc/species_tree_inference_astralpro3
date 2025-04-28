# Coalescent-based Species Tree Inference of Plant Genomes Using Single- and Multi-Copy BUSCOs with ASTRAL-Pro3

## Project Overview

This repository provides a practical workflow for building coalescent-based species trees from plant genomes using **single-copy** and **multi-copy BUSCO genes** as phylogenetic markers.  
The approach uses **ASTRAL-Pro3** to account for gene tree discordance, including incomplete lineage sorting (ILS) and gene duplication/loss (GDL).

The pipeline is based on the experience of analyzing _Chenopodium album_ genomes within Caryophyllales but is designed to be easily adapted to any plant clade with available genome assemblies.

## Why this workflow?

While traditional species tree methods often assume single-copy genes, **ASTRAL-Pro3** allows the use of **multi-copy orthologs**, making it ideal for plant genomes, where polyploidy and gene duplications are common.  
**BUSCO markers** provide a standardized and high-quality source of genes for this type of phylogenomic analysis.

## Tools and Software Used

- **BUSCO (v5.x)**  
  ➔ For identification of single- and multi-copy orthologs from genome assemblies.

- **MAFFT**  
  ➔ For multiple sequence alignment of protein sequences.

- **HyPhy**  
  ➔ To generate codon-aware nucleotide alignments based on protein alignments.

- **IQ-TREE2**  
  ➔ For maximum likelihood estimation of individual gene trees with model selection.

- **ASTRAL-Pro3**  
  ➔ For coalescent species tree inference using multi-copy gene trees.

## Workflow Overview

1. **Genome Acquisition**: Download haploid or high-quality genome assemblies.
2. **BUSCO Analysis**: Run BUSCO on each genome to extract orthologous genes (both single- and multi-copy).
3. **Multiple Sequence Alignment**: Align amino acid sequences of each BUSCO gene using MAFFT.
4. **Codon-Aware Alignment**: Use HyPhy to map protein alignments back to nucleotide sequences.
5. **Gene Tree Estimation**: Build maximum likelihood gene trees for each aligned BUSCO gene with IQ-TREE2.
6. **Species Tree Inference**: Infer a coalescent species tree using ASTRAL-Pro3, accounting for duplications.

> 🚀 Scripts and example commands are provided in the `/scripts` folder.

## Focus and Scope

This repository focuses on species tree inference using **BUSCO markers** and **ASTRAL-Pro3** for plant genomes.  
Downstream analyses such as evolutionary rate estimation (e.g., root-to-tip distances) are beyond the current scope but can be adapted if needed.

## Author

- **Kate Escobar (shv402)**  
  MSc in Bioinformatics, University of Copenhagen

## Acknowledgements

Special thanks to **Josefin Stiller** and **Pablo D. Cárdenas** for guidance and support during the development of the original project.
