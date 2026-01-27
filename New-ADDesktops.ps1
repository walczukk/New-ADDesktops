<#Skrypt przygotowany przez: Kacper Walczuk
Skrypt dodaje do AD nowe komputery, ilość można zdefiniować w pętli for zmiennej $NewNumber
Laptopy zostają również dodane do odpowiednich grup
Uruchamiać skrypt z poziomu administratora domenowego#>
Import-Module ActiveDirectory

$ComputerList = Get-ADComputer -Filter 'Name -like "xxxxDT*"' | Sort-Object {[int]($_.Name -replace 'xxxxDT', '')} | Select -ExpandProperty Name -Last 1
$StartNumber = [int]($ComputerList -replace 'xxxxDT', '')
$DateFormat = Get-Date -Format 'yyyy_MM_dd'

$LogPath = "C:\scripts\New-ADDesktops\logs\DT_Import_$DateFormat.log"

$NewNumber = 
for ($i = 1; $i -lt 101; $i++) {
    $StartNumber + $i
}

foreach ($num in $NewNumber) {
    $NewComputer = "xxxxDT$num"
    Write-Host "Dodaję $NewComputer..."

    Try {
        $OU = "OU=Computers,DC=domain,DC=pl"
        $Groups = @("gg-desktop","ug-DisablePowerShell")
        $DNSHostName = "$NewComputer.domain.pl"
        $SAMAccountName = "$NewComputer$"
        Start-Sleep -Milliseconds 300

        New-ADComputer -Name $NewComputer `
                       -SAMAccountName $SAMAccountName `
                       -DNSHostName $DNSHostName `
                       -Path $OU `
                       -Enabled $true `
                       #-WhatIf
        Write-Host "Dodałem $NewComputer" -ForegroundColor Green
        "$($DateFormat): Dodano $NewComputer" | Out-File -FilePath $LogPath -Append

        Start-Sleep -Seconds 1

        foreach ($group in $Groups) {
            Add-ADGroupMember -Identity $group -Members $SAMAccountName #-WhatIf
            Write-Host "Dodałem $NewComputer do grupy: $group" -BackgroundColor Cyan
            "$($DateFormat): Dodano $NewComputer do grupy: $group" | Out-File -FilePath $LogPath -Append
        }
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host "BŁĄD przy $NewComputer - $ErrorMessage" -BackgroundColor Red
        "$($DateFormat): BŁĄD przy $NewComputer - $ErrorMessage" | Out-File -FilePath $LogPath -Append
    }
}