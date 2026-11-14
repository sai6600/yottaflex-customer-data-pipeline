create database yottaflex_pipeline;
use yottaflex_pipeline;
show databases;

-- 1. Pipeline execution details
CREATE TABLE pipeline_runs (
    run_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    start_time DATETIME(6) NOT NULL,
    end_time DATETIME(6),
    status VARCHAR(20) NOT NULL DEFAULT 'RUNNING',
    input_count INT NOT NULL DEFAULT 0,
    accepted_count INT NOT NULL DEFAULT 0,
    rejected_count INT NOT NULL DEFAULT 0,
    duplicate_count INT NOT NULL DEFAULT 0,
    stale_count INT NOT NULL DEFAULT 0,
    error_message TEXT
);

-- 2. Accepted event history (audit table)
CREATE TABLE customer_events (
    event_id VARCHAR(100) NOT NULL,
    customer_id VARCHAR(64) NOT NULL,
    event_type VARCHAR(10) NOT NULL,
    event_version BIGINT NOT NULL,
    event_timestamp DATETIME(6) NOT NULL,
    customer_name VARCHAR(150),
    email VARCHAR(255),
    source_file VARCHAR(255),
    run_id BIGINT NOT NULL,
    processed_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    PRIMARY KEY (event_id),
    UNIQUE KEY uq_customer_version (customer_id, event_version),

    CONSTRAINT fk_events_run
        FOREIGN KEY (run_id) REFERENCES pipeline_runs(run_id)
);

-- 3. Latest customer state
CREATE TABLE current_customers (
    customer_id VARCHAR(64) PRIMARY KEY,
    customer_name VARCHAR(150),
    email VARCHAR(255),
    latest_version BIGINT NOT NULL,
    last_event_id VARCHAR(100) NOT NULL,
    last_event_timestamp DATETIME(6) NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6)
);

-- 4. Invalid or rejected events
CREATE TABLE rejected_events (
    reject_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_id VARCHAR(100),
    customer_id VARCHAR(64),
    raw_event LONGTEXT NOT NULL,
    rejection_reason TEXT NOT NULL,
    source_file VARCHAR(255),
    run_id BIGINT NOT NULL,
    rejected_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT fk_rejected_run
        FOREIGN KEY (run_id) REFERENCES pipeline_runs(run_id)
);
show tables;
select * from pipeline_runs;
SELECT * FROM customer_events;
SELECT * FROM current_customers;
SELECT * FROM current_customers
WHERE customer_id = 'C101';
SELECT event_id, customer_id, event_type, event_version
FROM customer_events
WHERE customer_id = 'C101'
ORDER BY event_version;
SELECT customer_id, customer_name, latest_version, is_deleted
FROM current_customers
WHERE customer_id = 'C102';
SELECT
    customer_id,
    customer_name,
    email,
    latest_version,
    is_deleted
FROM current_customers
WHERE customer_id = 'C101';
SELECT event_id, event_type, event_version
FROM customer_events
WHERE customer_id = 'C101'
ORDER BY event_version;

SELECT
    reject_id,
    event_id,
    customer_id,
    rejection_reason,
    source_file
FROM rejected_events;

SELECT
    run_id,
    status,
    input_count,
    accepted_count,
    rejected_count,
    duplicate_count,
    stale_count,
    start_time,
    end_time
FROM pipeline_runs;

SELECT
    run_id,
    input_count,
    accepted_count,
    rejected_count,
    duplicate_count,
    stale_count
FROM pipeline_runs;

SELECT *
FROM current_customers
WHERE customer_id IN ('C200', 'C201');
SELECT event_id, customer_id, event_type, event_version
FROM customer_events
WHERE run_id = 2
ORDER BY customer_id, event_version;
SELECT *
FROM pipeline_runs
WHERE run_id = 2;
SELECT run_id, event_id, customer_id, event_type, event_version
FROM customer_events
ORDER BY run_id, customer_id, event_version;

SELECT
    run_id,
    status,
    input_count,
    accepted_count,
    rejected_count,
    duplicate_count,
    stale_count,
    start_time,
    end_time,
    error_message
FROM pipeline_runs
ORDER BY run_id;
SELECT *
FROM current_customers
ORDER BY customer_id;
SELECT
    event_id,
    customer_id,
    rejection_reason,
    run_id
FROM rejected_events
ORDER BY reject_id;

SELECT
    event_id,
    customer_id,
    event_type,
    event_version,
    run_id
FROM customer_events
ORDER BY customer_id, event_version;
SELECT
    event_id,
    COUNT(*) AS occurrence_count
FROM customer_events
GROUP BY event_id
HAVING COUNT(*) > 1;       

SELECT
    customer_id,
    customer_name,
    email,
    latest_version,
    is_deleted
FROM current_customers
WHERE customer_id = 'C300';

SELECT event_id, event_type, event_version
FROM customer_events
WHERE customer_id = 'C300'
ORDER BY event_version;

SELECT
    run_id,
    status,
    input_count,
    accepted_count,
    rejected_count,
    duplicate_count,
    stale_count
FROM pipeline_runs
WHERE run_id IN (2, 3, 4)
ORDER BY run_id;       
SELECT run_id, status, input_count,
       accepted_count, rejected_count,
       duplicate_count, stale_count
FROM pipeline_runs
ORDER BY run_id;
