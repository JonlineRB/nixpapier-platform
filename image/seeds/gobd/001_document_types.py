from importlib.machinery import SourceFileLoader

lib = SourceFileLoader("seedlib", "/seeds/_lib.py").load_module()

lib.seed_once(
    "gobd_v1",
    document_types=[
        dict(name="Eingangsrechnung", match="rechnung", matching_algorithm=1, is_insensitive=True),
        dict(name="Ausgangsrechnung", match="rechnung, nix", matching_algorithm=1, is_insensitive=True),
        dict(name="Jahresabschluss", match="Jahresabschluss", matching_algorithm=1, is_insensitive=True),
        dict(name="Geschäftsbrief", match="Geschäftsbrief", matching_algorithm=1, is_insensitive=True),
        dict(name="Kassenbuch", match="Kassenbuch", matching_algorithm=1, is_insensitive=True),
        dict(name="E-Rechnung", match="E-Rechnung", matching_algorithm=1, is_insensitive=True),
        dict(name="Lohnunterlagen", match="Lohn", matching_algorithm=1, is_insensitive=True),
    ],
    tags=[
        dict(name="10 Jahre", match="ust-id, umsatzsteuer, finanzamt", matching_algorithm=1, is_insensitive=True),
    ],
)
