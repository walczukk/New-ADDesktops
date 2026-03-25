# Changelog

Wszystkie znaczące zmiany w tym projekcie będą dokumentowane w tym pliku.

## v1.1 - 2026-03-25
### Zmieniono
- Sparametryzowano cały skrypt (wywalenie zahardcodowanych ścieżek i nazw).
- Zastąpiono `Write-Host` na `Write-Verbose`.
- Poprawiono logikę pętli generującej komputery (`-lt` zamieniono na `-le`).

### Dodano
- Sprawdzenie istnienia folderu z logami.

## v1.0 - 2026-01-17
### Dodano
- Inicjalna wersja skryptu do masowego tworzenia komputerów w AD i dodawania ich do grup.
