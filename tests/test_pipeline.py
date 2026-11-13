
%%writefile tests/test_pipeline.py

from pipeline import validate_event


def test_valid_event():
    event = {
        "event_id": "TEST_VALID",
        "customer_id": "TEST_CUST_1",
        "event_type": "INSERT",
        "event_version": 1,
        "event_timestamp": "2026-11-13T10:00:00",
        "customer_name": "Test Customer",
        "email": "test@example.com"
    }

    is_valid, errors = validate_event(event)

    assert is_valid is True
    assert errors == []


def test_missing_customer_name():
    event = {
        "event_id": "TEST_INVALID",
        "customer_id": "TEST_CUST_2",
        "event_type": "INSERT",
        "event_version": 1,
        "event_timestamp": "2026-11-13T10:00:00",
        "customer_name": "",
        "email": "test@example.com"
    }

    is_valid, errors = validate_event(event)

    assert is_valid is False
    assert "Customer name is required" in errors


def test_invalid_event_version():
    event = {
        "event_id": "TEST_VERSION",
        "customer_id": "TEST_CUST_3",
        "event_type": "INSERT",
        "event_version": 0,
        "event_timestamp": "2026-11-13T10:00:00",
        "customer_name": "Test Customer",
        "email": "test@example.com"
    }

    is_valid, errors = validate_event(event)

    assert is_valid is False
    assert "Event version must be a positive integer" in errors
