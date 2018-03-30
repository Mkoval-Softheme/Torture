Function Hardreset-VM
{
    param(
    $VMName = $null
    )
    Connect-VIServer -Server 192.168.64.76 -User administrator@vsphere.local -Password P@ssw0rd -Force # Connect to vCenter
    Start-Sleep -Seconds 10
    $vm = Get-VM -Name $VMName # Get VM that will be hardreseted
    
    if(($vm).count -gt 1) # Check for count of VMs, it should be 1
    {
        Write-Host "Error!!!!!!!!!!!!!!!!!!!!!!! VMs more than one!"
    }else{
        
        $vm.ExtensionData.ResetVM() # Run method for VM that hardreset it
    }
}

Import-Module VMware.VimAutomation.Vds # PowerCLI should be installed
Import-Module VMware.VimAutomation.Core

# List of VMs that will be hardreseted
$Agent1="mikhail.koval_Torture_Agent(29)(192.168.89.30)(03-11-2017_05-31-32)"
$Agent2="mikhail.koval_Torture_Agent(30)(192.168.89.31)(03-11-2017_05-31-32)"
$Agent3="mikhail.koval_Torture_Agent(31)(192.168.89.32)(03-11-2017_05-31-32)"
$Agent4="mikhail.koval_Torture_Agent(32)(192.168.89.33)(03-11-2017_05-31-32)"
$Agent5="mikhail.koval_Torture_Agent(33)(192.168.89.34)(03-11-2017_05-31-32)"
$Agent6="mikhail.koval_Torture_Agent(34)(192.168.89.35)(03-11-2017_05-31-32)"

$minToDeath = Get-Random -Minimum 1 -Maximum 20 # This time waiter created for randomizing time when script will execute
Start-Sleep -Seconds (60 * $minToDeath)

Hardreset-VM -VMName $Agent1 # Start function Hardreset-VM
Start-Sleep -Seconds 10

Hardreset-VM -VMName $Agent2
Start-Sleep -Seconds 10

Hardreset-VM -VMName $Agent3
Start-Sleep -Seconds 10

Hardreset-VM -VMName $Agent4
Start-Sleep -Seconds 10

Hardreset-VM -VMName $Agent5
Start-Sleep -Seconds 10

Hardreset-VM -VMName $Agent6
Start-Sleep -Seconds 10