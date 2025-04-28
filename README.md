# Coalescent-based Species Tree Inference of Plant Genomes Using Single- and Multi-Copy BUSCOs with ASTRAL-Pro3

## Project Overview

This repository provides a practical workflow for building coalescent-based species trees from plant genomes using **single-copy** and **multi-copy BUSCO genes** as phylogenetic markers.  
The approach uses **ASTRAL-Pro3** to account for gene tree discordance, including incomplete lineage sorting (ILS) and gene duplication/loss (GDL).

The pipeline is based on the experience of analyzing _Chenopodium album_ genomes within Caryophyllales but is designed to be easily adapted to any plant clade with available genome assemblies.

## About the Workflow

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
3. [**Multiple Sequence Alignment**](mafft_align.sh): Align amino acid sequences of each BUSCO gene using MAFFT.
4. [**Codon-Aware Alignment**](hyphy_align.sh): Use HyPhy to map protein alignments back to nucleotide sequences.
5. [**Gene Tree Estimation**](estimate_gene_trees.sh): Build maximum likelihood gene trees for each aligned BUSCO gene with IQ-TREE2.
6. [**Species Tree Inference**](run_astralpro3.sh): Infer a coalescent species tree using ASTRAL-Pro3, accounting for duplications.

## Author

  **Kate Escobar** 
  MSc in Bioinformatics, University of Copenhagen (UCPH)

## Acknowledgements

Special thanks to Assistant Professor **Josefin Stiller** (Department of Biology, Section for Ecology and Evolution, UCPH) and Assistant Professor **Pablo D. Cárdenas** (Department of Plant and Environmental Sciences, Section for Plant Biochemistry, UCPH) for guidance and support during the development of the original project.

## Citations and Software Credits

- **BUSCO**:  
  Felipe A. Simão, Robert M. Waterhouse, Panagiotis Ioannidis, Evgenia V. Kriventseva, Evgeny M. Zdobnov,
  BUSCO: assessing genome assembly and annotation completeness with single-copy orthologs, Bioinformatics,
  Volume 31, Issue 19, October 2015, Pages 3210–3212, https://doi.org/10.1093/bioinformatics/btv351

- **ASTRAL-Pro**:  
  Chao Zhang, Celine Scornavacca, Erin K. Molloy, Siavash Mirarab. ASTRAL-Pro: quartet-based
  species tree inference despite paralogy. Molecular Biology and Evolution, 2020, https://doi.org/10.1093/molbev/msaa139

- **HyPhy**:  
  Sergei L. Kosakovsky Pond, Simon D. W. Frost, Spencer V. Muse, HyPhy: hypothesis testing using phylogenies, Bioinformatics,
  Volume 21, Issue 5, March 2005, Pages 676–679, https://doi.org/10.1093/bioinformatics/bti079

- **MAFFT**:  
  Kazutaka Katoh, Daron M. Standley, MAFFT Multiple Sequence Alignment Software Version 7: Improvements in Performance and Usability,
  Molecular Biology and Evolution, Volume 30, Issue 4, April 2013, Pages 772–780, https://doi.org/10.1093/molbev/mst010
