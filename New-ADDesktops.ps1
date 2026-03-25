<#
.SYNOPSIS
Dodaje nowe komputery do Active Directory

.DESCRIPTION
Skrypt pobiera ostatni numer komputera z danym prefiksem, następnie na podstawie zdefiniowanej
liczby, generuje ilość nowych kont komputerów w AD oraz dodaje je do wskazanych grup.

.EXAMPLE
.\New-ADDesktops_v1.1.ps1 -ComputerPrefix "PC" -Count 10

.NOTES
    Wersja: 1.1
    Autor: Kacper Walczuk
    Data publikacji: 2026-03-25

    ZASTRZEŻENIE
    Skrypt wprowadza zmiany w Active Directory. Mimo że został napisany z dbałością o błędy,
    używasz ich na własną odpowiedzialność! Przetestuj dokładnie jego działanie na środowisku
    testowym przed uruchomieniem go na produkcji :) 
#>
[CmdletBinding()]
param (
    [string]$ComputerPrefix = "PC",
    [string]$DomainSuffix = "domain.pl",
    [string]$TargetOU = "OU=Computers,DC=domain,DC=pl",
    [string[]]$TargetGroups = @("gg-desktop","ug-DisablePowerShell"),
    [string]$LogPath = "C:\scripts\New-ADDesktops\logs\",
    [int]$Count = 10
)
Import-Module ActiveDirectory

$LastComputer = Get-ADComputer -Filter "Name -like '$ComputerPrefix*'" | Sort-Object {[int]($_.Name -replace "$ComputerPrefix", '')} | Select -ExpandProperty Name -Last 1
$StartNumber = [int]($LastComputer -replace $ComputerPrefix, '')
$DateFormat = Get-Date -Format "yyyy-MM-dd"
$LogFile = Join-Path -Path $LogPath -ChildPath "DT_Import_$DateFormat.log"

if (-not (Test-Path -Path $LogPath)) {
    mkdir $LogPath
}
 
for ($i = 1; $i -le $Count; $i++) {
    $NewNumber = $StartNumber + $i
    $NewComputer = "$ComputerPrefix$NewNumber"

    Write-Verbose "Przetwarzanie komputera: $NewComputer"

    try {
        $DNSHostName = "$NewComputer.$DomainSuffix"
        $SAMAccountName = "$NewComputer$"
        Start-Sleep -Milliseconds 300

        New-ADComputer -Name $NewComputer `
                       -SAMAccountName $SAMAccountName `
                       -DNSHostName $DNSHostName `
                       -Path $TargetOU `
                       -Enabled $true `
                       #-WhatIf
        Write-Verbose "Dodałem $NewComputer" -Verbose
        "$((Get-Date -Format "yyyy-MM-dd HH:mm:ss")): Dodano $NewComputer" | Out-File -FilePath $LogFile -Append

        Start-Sleep -Seconds 1

        foreach ($group in $TargetGroups) {
            Add-ADGroupMember -Identity $group -Members $SAMAccountName #-WhatIf
            Write-Verbose "Dodałem $NewComputer do grupy: $group" -Verbose
            "$((Get-Date -Format "yyyy-MM-dd HH:mm:ss")): Dodano $NewComputer do grupy: $group" | Out-File -FilePath $LogFile -Append
        }
    }
    catch {
        Write-Error "BŁĄD przy $NewComputer - $_"
        "$((Get-Date -Format "yyyy-MM-dd HH:mm:ss")): BŁĄD przy $NewComputer - $_" | Out-File -FilePath $LogFile -Append
    }
}
