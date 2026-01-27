# 🖥️ New-ADDesktops

![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell) ![Active Directory](https://img.shields.io/badge/ActiveDirectory-Module-green)

Skrypt PowerShell automatyzujący proces dodawania nowych komputerów do domeny Active Directory.
Skrypt pobiera ostatni numer inwentarzowy z AD, inkrementuje go i tworzy serię nowych obiektów.

### Co robi ten skrypt?
1. **Inteligentne nazewnictwo:** Skanuje AD w poszukiwaniu komputerów z prefiksem `xxxxDT`, znajduje najwyższy numer i zaczyna tworzenie od kolejnego.
2. **Masowe dodawanie:** W jednej pętli tworzy 100 nowych obiektów (ilość konfigurowalna w pętli `for`).
3. **Automatyzacja Grup:** Dodaje nowe maszyny do zdefiniowanych grup (np. `gg-desktop`, `ug-DisablePowerShell`).
4. **Pełne Logowanie:** Zapisuje wynik operacji w `C:\scripts\New-ADDesktops\logs\`.

### Konfiguracja
Skrypt jest przygotowany jako szablon. Przed uruchomieniem na produkcji **należy edytować** poniższe zmienne w pliku `New-ADDesktops.ps1` pod swoje potrzeby:

* **Prefix nazwy:** Skrypt szuka maszyn `xxxxDT`. Zmień to na swój standard (np. `FIRMADT`).
* **Ścieżka OU:**
  ```powershell
  $OU = "OU=Computers,DC=domain,DC=pl"
