# ☁️ Azure Cloud Fundamentals & Data Pipeline ADF Project

##  Debajyoti Bhakta _ SOA

> **Week 4 Internship Assignment** End-to-end data pipeline built with Azure Storage Account and Azure Data Factory, moving the Superstore dataset from raw Blob storage to a processed destination with metadata validation and IAM-secured access.

![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoftazure&logoColor=white)
![Azure Data Factory](https://img.shields.io/badge/Azure%20Data%20Factory-0078D4?style=flat&logo=azuredataexplorer&logoColor=white)
![Status](https://img.shields.io/badge/status-completed-brightgreen)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

---

## 📌 Overview

This project provisions a small but complete Azure data platform:

**Blob Storage → Azure Data Factory (Get Metadata → Copy Data) → Blob Storage**

All infrastructure is defined as code (Azure CLI scripts + ADF JSON
definitions) so the entire environment can be rebuilt with one command,
alongside documentation of the manual Azure Portal / ADF Studio steps.



---

---

## ⚙️ Prerequisites

- An [Azure free account](https://azure.microsoft.com/free) (no Azure account needed beforehand — sign up is free, $200/30-day credit + always-free tiers cover this project entirely)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed (`az --version` to check)
- The Superstore dataset from [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

---

## 🚀 Quick Start

```bash
# 1. Clone / download this folder, then:
cd azure-superstore-adf-pipeline

# 2. Download the dataset from Kaggle and place it here:
#    data/Sample - Superstore.csv

# 3. Edit scripts/variables.sh — change STORAGE_ACCOUNT and
#    DATA_FACTORY_NAME to something globally unique.

# 4. Make scripts executable
chmod +x scripts/*.sh

# 5. Run everything
./scripts/deploy-all.sh
```

This will, in order:
1. Log you into Azure and create the **Resource Group**
2. Create the **Storage Account** with `raw-data` and `processed-data` containers
3. Upload the Superstore CSV
4. Create **Azure Data Factory** and deploy the Linked Service, Datasets, and Pipeline
5. Assign **IAM roles** (Reader, Storage Blob Data Contributor) to ADF's managed identity
6. **Trigger the pipeline** and poll until it succeeds

Prefer to click through the Azure Portal / ADF Studio UI by hand instead of
running scripts? See the step-by-step walkthrough in `docs/summary.md` and
the earlier full guide — every resource name below matches what the scripts
create, so you can mix and match.

---


## 📊 Sample Execution Result

| Metric | Value |
|---|---|
| Pipeline | `PL_Superstore_EndToEnd` |
| Trigger type | Manual (Trigger Now) |
| Activities | 2 (Get Metadata → Copy Data) |
| Status | ✅ Succeeded |
| Source rows | ~9,994 (Superstore dataset) |
| Output file | `processed-data/Superstore_output.csv` |

*(Fill in your actual run duration / row count / timestamps from the
Monitor tab after you run it — see `docs/summary.md` for the full
report template.)*

---

## 📸 Screenshots

See [`screenshots/README.md`](./screenshots/README.md) for the full checklist
of 13 required screenshots (Resource Group, Storage, ADF Studio, Pipeline
canvas, Monitor, IAM, etc.) and their expected filenames.

---

## 🧹 Cleanup

To avoid any ongoing cost, delete everything with one command:

```bash
az group delete --name rg-superstore-adf-project --yes --no-wait
```

---

## 📚 Resources

- Dataset: [Superstore Dataset (Kaggle)](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- [Azure Data Factory documentation](https://learn.microsoft.com/azure/data-factory/)
- [Azure Free Account](https://azure.microsoft.com/free)

---


