# Microsoft Fabric Integration

Microsoft Fabric is used as the analytics, serving, and reporting layer of the FinBank360 Data Platform.

The platform follows a Medallion Architecture in which data is progressively refined from raw financial source data into trusted, business-ready datasets.

---

## Fabric Components

The Microsoft Fabric implementation is designed to use the following components:

- Fabric Lakehouse
- OneLake
- Delta tables
- SQL Analytics Endpoint
- Semantic Model
- Power BI
- Fabric Data Pipelines
- Fabric Notebooks

---

## Role of Microsoft Fabric

Microsoft Fabric provides the analytics and serving layer for FinBank360.

The overall flow is:

```text
Source Systems
      |
      v
Azure Data Factory
      |
      v
ADLS Gen2
      |
      v
Azure Databricks
      |
      v
Bronze / Silver / Gold Delta Data
      |
      v
Microsoft Fabric
      |
      +--> Lakehouse
      |
      +--> SQL Analytics Endpoint
      |
      +--> Semantic Model
      |
      v
Power BI