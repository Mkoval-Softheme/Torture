Function Force-BSOD()
{
    $process1 = get-wmiobject -query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -namespace "root\cimv2" -computername localhost
    Logging "Launching Rnd as process on the target machine"
    $results1 = $process1.Create( "C:\NotMyfault64.exe /crash /accepteula" ) # Run NotMyfault util
}

$minToDeath = Get-Random -Minimum 1 -Maximum 60 # This time waiter created for randomizing time when script will execute
Start-Sleep -Seconds (60 * $minToDeath)

Force-BSOD