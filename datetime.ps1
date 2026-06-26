# PowerShell script to display current date, time, and day of the week

Write-Host "Current date and time information:"
Write-Host "=================================="
Write-Host "Date: $((Get-Date).ToString('yyyy-MM-dd'))"
Write-Host "Time: $((Get-Date).ToString('HH:mm:ss'))"
Write-Host "Day of the week: $((Get-Date).ToString('dddd'))"
Write-Host "Full date and time: $(Get-Date)"