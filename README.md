
# Customer Change Data Processing Pipeline

## 1. Project Overview

This project implements a customer change data processing pipeline using Python, MySQL and pandas.

It processes three types of customer events:

- INSERT: Creates a new customer record.
- UPDATE: Updates an existing customer record.
- DELETE: Marks a customer record as deleted.

The pipeline maintains event history separately from the current customer state.

## 2. Technology Stack

- Python 3.13
- MySQL 8
- mysql-connector-python
- pandas
- pytest
- Jupyter Notebook

## 3. Architecture

```text
Input Events
     |
     v
Event Validation
     |
     v
Duplicate Check
     |
     v
Event Processing
     |
     +----------------------+
     |                      |
     v                      v
Event History         Current Customer
(customer_events)     (current_customers)
     |
     v
Run Metrics and Rejected Events
```

## 4. Database Tables

| Table | Purpose |
|---|---|
| pipeline_runs | Tracks pipeline execution and metrics |
| customer_events | Stores accepted event history |
| current_customers | Stores the latest customer state |
| rejected_events | Stores invalid or rejected events |

## 5. Processing Rules

1. Every event must have an event ID, customer ID, event type, version and timestamp.
2. Event types must be INSERT, UPDATE or DELETE.
3. Event versions must be positive integers.
4. INSERT and UPDATE require a customer name and valid basic email format.
5. Duplicate event IDs are not processed again.
6. UPDATE or DELETE for an unknown customer is rejected.
7. Older events are retained in history when valid, but do not overwrite newer customer state.
8. Invalid events are stored in the rejected events table.

A unique constraint on customer ID and event version prevents two different events from using the same version for one customer.

## 6. Test Results

The following checks were performed during development:

| Test | Result |
|---|---|
| INSERT and UPDATE | Passed |
| DELETE | Passed |
| Duplicate event | Passed |
| Invalid event | Passed |
| Empty batch | Passed |
| Out-of-order event | Passed |
| Event history verification | Passed |
| Current-state verification | Passed |
| Three pytest validation tests | Passed |

## 7. Automated Tests

Run:

```bash
python -m pytest tests/test_pipeline.py -v
```

The current pytest suite contains three event-validation tests. Other processing scenarios were tested manually using the notebook and MySQL.

## 8. Project Setup

Install dependencies:

```bash
pip install mysql-connector-python pandas pytest
```

Create a MySQL database:

```sql
CREATE DATABASE yottaflex_pipeline;
```

Create the four database tables using the SQL schema provided in the project notebook.

Configure the MySQL connection in the notebook. Do not commit passwords or other credentials to GitHub.

Run the notebook cells in order to initialize the connection and execute the pipeline.

## 9. Project Limitations and Future Improvements

- Move all pipeline processing functions into reusable Python modules.
- Add broader automated integration tests.
- Improve transaction recovery and retry handling.
- Add strict unexpected-schema validation.
- Add configurable synthetic data generation for large-volume testing.
- Add performance benchmarking for 100,000 or more events.

## 10. AI Usage Disclosure

AI assistance was used during development for explanations, code suggestions, debugging, test creation and documentation.

The developer reviewed and executed the suggested code and tested the pipeline using sample events.

The prompts used during development are documented in `prompt_history/ai_prompts.md`.
