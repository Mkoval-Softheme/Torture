Function Kill-ocafsd
{
    Get-Process -Name ocafsd | Stop-Process -Force
}

$minToDeath = Get-Random -Minimum 1 -Maximum 60 # This time waiter created for randomizing time when script will execute
Start-Sleep (60 * $minToDeath)

Kill-ocafsd