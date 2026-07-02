# A Generalized Approach to Combining Similarity and Eigenvector Analysis of Networks

This repository contains the complete replication materials—data, code, manuscripts, and presentation slides—for the paper **"A Generalized Approach to Combining Similarity and Eigenvector Analysis of Networks"**.

This project implements a generalized framework that combines pairwise node similarity measures (such as Jaccard similarity) with feedback centralities (such as Bonacichs eigenvector scores) to allow for analyses that range from pure brokerage (dissimilarity-weighted) to pure closure (similarity-weighted), as well as hybrid configurations.

---

## 📂 Repository Structure

The project directory is structured as follows:

```text
├── analysis.qmd                    # Main reproducible Quarto notebook (primary entry point)
├── parameter.csv                   # Sensitivity analysis raw scores
├── manuscript.tex                  # Source LaTeX file for the main paper
├── references.bib                  # BibTeX file containing all references
├── asr.bst                         # Academic Sociology Review (ASR) bibliography style
├── editor-letter.tex               # Revision materials
├── response-memo.tex               # Revision materials
├── main.tex                        # Auto-generated LaTeX table with eigenvector scores
├── bump.png / medici.png           # Auto-generated figures
├── renv.lock                       # renv lockfile for exact package versions
└── renv/                           # Project-local R library configuration
```

---

## 🛠️ Prerequisites & Installation

To run the reproducibility workflow, you will need **R** and the **Quarto** CLI (pre-installed in Positron and RStudio).

### 1. Required R Packages
Ensure you have the required R packages installed. You can install them by running the following command in your R console:

```R
renv::restore()
```

This project uses `renv` to lock down dependencies. Running `renv::restore()` will automatically install all CRAN dependencies, the `ggbump` package from GitHub, and the `networkdata` package from its dedicated repository.

Once the tables and figures are generated via Quarto, you can compile the LaTeX paper using `tinytex::latexmk("manuscript.tex")` or `pdflatex manuscript.tex`.

---

## 🚀 How to Reproduce the Findings

1. **Clone the Repository**: Clone this repository to your local machine using git or download it as a ZIP file.
2. **Open the Project**: Open the `.Rproj` or `.R` file in your editor (e.g., RStudio or Positron). This ensures paths are resolved correctly relative to the project root.
3. **Install Dependencies**: Ensure the packages listed above are installed.
4. **Run the Computational Pipeline**:
   * **Using the Command Line (Quarto CLI)**:
     ```bash
     quarto render analysis.qmd
     ```
   * **Using R**:
     ```R
     quarto::quarto_render("analysis.qmd")
     ```
   * Or run interactively in your IDE. This step ensures that all tables and figures are updated directly from the code, guaranteeing that the numbers in the paper are exactly what the code computes.

---

## 📝 License & Citation

If you use the materials or code in this repository, please cite the paper:

```bibtex
@article{lizardo2026generalized,
  title={A Generalized Approach to Combining Similarity and Eigenvector Analysis of Networks},
  author={Lizardo, Omar},
  journal={Working Paper},
  year={2026}
}
```
