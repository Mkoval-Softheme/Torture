 Function Get-RandID
 {
    param($machineName = $null)
    if($machineName -eq $null)
    {
        $machinesList = Get-ProtectedServers
        $machineName = $machinesList[(Get-Random -Minimum 0 -Maximum ($machinesList.Count - 1))].DisplayName

    }
    $machine = Get-ProtectedServers | Where-Object{$_.DisplayName -eq $machineName}

    $recoveryPointsList = Get-RecoveryPoints -ProtectedServer $machine.DisplayName -Number all
    $recoveryPointID = $recoveryPointsList[(Get-Random -Minimum 0 -Maximum ($recoveryPointsList.Count - 1))].Id

    $machineName
    $recoveryPointID
 }

$minToDeath = Get-Random -Minimum 1 -Maximum 120 # This time waiter created for randomizing time when script will execute
Start-Sleep -Seconds (60 * $minToDeath)

Import-Module "C:\RollBack\RollBackCmdlet.dll" # Rollback module writed by Dima Gorgulenko Located: \\192.168.64.127\share\Torture\Big Master Core DVM\RollBack(Powershell module).zip

$IDs = Get-RandID # Call Get-RandID function that returns in 0 element "Machine name", in 1st element "Recovery Point ID"

New-Rollback -ProtectedServer $IDs[0] -RPGuid $IDs[1] # Start rollback 