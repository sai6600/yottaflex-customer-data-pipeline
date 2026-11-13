
from datetime import datetime


def validate_event(event):
    errors = []

    required_fields = [
        "event_id",
        "customer_id",
        "event_type",
        "event_version",
        "event_timestamp"
    ]

    for field in required_fields:
        if event.get(field) is None or str(event.get(field)).strip() == "":
            errors.append(f"Missing required field: {field}")

    if errors:
        return False, errors

    event_type = str(event["event_type"]).upper()

    if event_type not in ["INSERT", "UPDATE", "DELETE"]:
        errors.append("Invalid event type")

    version = event["event_version"]

    if isinstance(version, bool) or not isinstance(version, int) or version <= 0:
        errors.append("Event version must be a positive integer")

    try:
        datetime.fromisoformat(
            event["event_timestamp"].replace("Z", "+00:00")
        )
    except (ValueError, TypeError, AttributeError):
        errors.append("Invalid event timestamp")

    if event_type in ["INSERT", "UPDATE"]:
        if not event.get("customer_name"):
            errors.append("Customer name is required")

        if not event.get("email"):
            errors.append("Email is required")
        elif "@" not in event["email"]:
            errors.append("Invalid email format")

    return len(errors) == 0, errors
