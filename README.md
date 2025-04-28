# Coalescent-based Species Tree Inference of Plant Genomes Using Single- and Multi-Copy BUSCOs with ASTRAL-Pro3

## Project Overview

This repository provides a practical workflow for building coalescent-based species trees from plant genomes using **single-copy** and **multi-copy BUSCO genes** as phylogenetic markers.  
The approach uses **ASTRAL-Pro3** to account for gene tree discordance, including incomplete lineage sorting (ILS) and gene duplication/loss (GDL).

The pipeline is based on the experience of analyzing _Chenopodium album_ genomes within Caryophyllales but is designed to be easily adapted to any plant clade with available genome assemblies.

## Why this workflow?

While traditional species tree methods often assume single-copy genes, **ASTRAL-Pro3** allows the use of **multi-copy orthologs**, making it ideal for plant genomes, where polyploidy and gene duplications are common.  **BUSCO markers** provide a standardized and high-quality source of genes for this type of phylogenomic analysis.

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

## Citations and Software Credits

If you use this workflow, please also cite the developers of the key tools:

- **BUSCO**:  
  Simão FA, Waterhouse RM, Ioannidis P, Kriventseva EV, Zdobnov EM. (2015).  
  BUSCO: assessing genome assembly and annotation completeness with single-copy orthologs. *Bioinformatics*, 31(19), 3210–3212.  
  [https://doi.org/10.1093/bioinformatics/btv351](https://doi.org/10.1093/bioinformatics/btv351)

- **ASTRAL-Pro**:  
  Zhang C, Rabiee M, Sayyari E, Mirarab S. (2020).  
  ASTRAL-Pro: Quartet-Based Species-Tree Inference despite Paralogy. *Molecular Biology and Evolution*, 37(11), 3292–3307.  
  [https://doi.org/10.1093/molbev/msaa145](https://doi.org/10.1093/molbev/msaa145)

- **HyPhy**:  
  Kosakovsky Pond SL, Frost SDW, Muse SV. (2005).  
  HyPhy: hypothesis testing using phylogenies. *Bioinformatics*, 21(5), 676–679.  
  [https://doi.org/10.1093/bioinformatics/bti079](https://doi.org/10.1093/bioinformatics/bti079)

- **MAFFT**:  
  Katoh K, Standley DM. (2013).  
  MAFFT multiple sequence alignment software version 7: improvements in performance and usability. *Molecular Biology and Evolution*, 30(4), 772–780.  
  [https://doi.org/10.1093/molbev/mst010](https://doi.org/10.1093/molbev/mst010)

