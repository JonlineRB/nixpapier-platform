"""Shared helpers for seed profiles. Imported by profile scripts."""
from django.db import connection
from documents.models import Tag, DocumentType


def _marker_exists(version: str) -> bool:
    with connection.cursor() as c:
        c.execute(
            "CREATE TABLE IF NOT EXISTS custom_seed_state (version TEXT PRIMARY KEY)"
        )
        c.execute("SELECT 1 FROM custom_seed_state WHERE version = %s", [version])
        return c.fetchone() is not None


def _write_marker(version: str) -> None:
    with connection.cursor() as c:
        c.execute("INSERT INTO custom_seed_state (version) VALUES (%s)", [version])


def seed_once(version: str, document_types=None, tags=None) -> None:
    """Apply the given objects exactly once per version marker."""
    if _marker_exists(version):
        print(f"[seed] {version} already applied, skipping.")
        return

    for dt in document_types or []:
        DocumentType.objects.create(**dt)
    for tag in tags or []:
        Tag.objects.create(**tag)

    _write_marker(version)
    print(f"[seed] {version} applied.")
