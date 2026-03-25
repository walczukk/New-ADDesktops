# 🖥️ New-ADDesktops

![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell) ![Active Directory](https://img.shields.io/badge/ActiveDirectory-Module-green) ![v1.1](https://img.shields.io/badge/wersja-1.1-e45959)

Skrypt PowerShell automatyzujący proces dodawania nowych komputerów do domeny Active Directory.
Skanuje AD w poszukiwaniu najwyższego numeru z danym prefiksem i zaczyna tworzenie od kolejnego.

### Co nowego w wersji 1.1?
Skrypt został w pełni sparametryzowany. **Nie ma potrzeby edycji kodu**, żeby dostosować go do własnego środowiska!

### Co robi ten skrypt?
1. **Inteligentne nazewnictwo:** Skanuje AD w poszukiwaniu komputerów z prefiksem, znajduje najwyższy numer i zaczyna tworzenie od kolejnego.
2. **Masowe dodawanie:** W jednej pętli tworzy 100 nowych obiektów.
3. **Automatyzacja Grup:** Dodaje nowe maszyny do zdefiniowanych grup (np. `gg-desktop`, `ug-DisablePowerShell`).
4. **Pełne Logowanie:** Zapisuje wynik operacji w `C:\scripts\New-ADDesktops\logs\`.

### Użycie
Wywołaj skrypt z odpowiednimi parametrami z poziomu konsoli.

### Dostępne parametry (z domyślnymi wartościami):

* -ComputerPrefix (domyślnie: "PC")

* -DomainSuffix (domyślnie: "domain.pl")

* -TargetOU (domyślnie: "OU=Computers,DC=domain,DC=pl")

* -TargetGroups (domyślnie: "gg-desktop", "ug-DisablePowerShell")

* -LogPath (domyślnie: "C:\scripts\New-ADDesktops\logs")

* -Count (ilość maszyn do utworzenia)

**Przykład wywołania (tworzy 5 nowych komputerów z prefiksem `IT-PC`):**
```powershell
.\New-ADDesktops.ps1 -ComputerPrefix "IT-PC" -Count 5 -Verbose
```

Autor: *Kacper Walczuk **(@walczukk)***
