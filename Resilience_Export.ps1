 Function New-Session
{
    param(
    $ComputerName = $null,
    $Username = "Administrator",
    $Password = "raid4us!"
    )
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)

    set-item wsman:\localhost\Client\TrustedHosts -value $ComputerName -Force

    if (!(Test-Connection -ComputerName $ComputerName -Quiet))
    {
        Write-Host "Cannot contact the specified machine"
        exit
    }
    else 
    {
        Write-Host "Test-Connection function passed" 
    }

    Write-Host "Making session"
    $session = new-pssession -computername $ComputerName -credential $cred
 
    $counter=0
    while(!($session))
    {
           
        Write-Host "$ComputerName inaccessible! $counter try"
        $session = new-pssession -computername $ComputerName -credential $cred
        $counter++
        if( $counter -eq 5) {
            Write-Host "No way, man. Could not make session, check password maybe?"
            exit
        }
    }

    Write-Host ($session.state)
    return $session

}

function StartExport-VMWare
{
    param(
    $Path = "C:\VMWare_Export",
    $PathPassword = "raid4us!",
    $PathUserName = "Administrator",
    $ProtectedServer = "192.168.90.20",
    $TargetPath = "\\192.168.90.21\VMWare_Export",
    $VMName = "Resilience_VMWare_Export"

    )
    
    New-Snapshot -All

    $session = New-Session -ComputerName 192.168.90.21
    if(!(Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Force} -ArgumentList $Path))
    {
        Write-Host "Machine not exist"
    }else{Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Recurse -Force | Remove-Item -Confirm:$false -Force -Recurse} -ArgumentList $Path}

    Get-PSSession | Remove-PSSession -Confirm:$false

    Start-Job -ScriptBlock {
    Start-VMExport -PathPassword $args[0] -PathUserName $args[1] -ProtectedServer $args[2] -TargetPath $args[3] -UseSourceRam -Version 12 -VMName $args[4]
    } -ArgumentList @($PathPassword,$PathUserName,$ProtectedServer,$TargetPath,$VMName)
    
}

function StartExport-VBox
{
    param(
    $Path = "E:\VBox_Export",
    $PathPassword = "raid4us!",
    $PathUserName = "Administrator",
    $ProtectedServer = "192.168.90.20",
    $TargetPath = "\\192.168.90.21\VBox_Export",
    $VMName = "Resilience_VBox_Export"

    )
    
    New-Snapshot -All

    $session = New-Session -ComputerName 192.168.90.21
    if(!(Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Force} -ArgumentList $Path))
    {
        Write-Host "Machine not exist"
    }else{Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Recurse -Force | Remove-Item -Confirm:$false -Force -Recurse} -ArgumentList $Path}

    Get-PSSession | Remove-PSSession -Confirm:$false

    Start-Job -ScriptBlock {
    Start-VBExport -PathPassword $args[0] -PathUserName $args[1] -ProtectedServer $args[2] -TargetPath $args[3] -UseSourceRam -VMName $args[4]
    } -ArgumentList @($PathPassword,$PathUserName,$ProtectedServer,$TargetPath,$VMName)
}

function StartExport-ESXi
{
    param(
    $Datacenter = "dc_new",
    $Datastore = "CML-Lun11",
    $ResourcePool = "Resources",
    $HostPassword = "P@ssw0rd",
    $HostUserName = "Administrator@vsphere.local",
    $ProtectedServer = "192.168.90.20",
    $HostName = "192.168.64.76",
    $VMName = "CPU_ESXi_Export",
    $ComputeResource = "Compellent_Hosts"
    )
    
    New-Snapshot -All

    if(!(Get-VM -Name $VMName))
    {
        Write-Host "Machine not exist"
    }else{Remove-VM -DeletePermanently -VM $VMName -Confirm:$false}

    Start-Sleep -Seconds 20

    Start-Job -ScriptBlock {
    Start-ESXiExport -HostPassword $args[0] -HostUserName $args[1] -ProtectedServer $args[2] -Datacenter $args[3] -DataStore $args[4] -ResourcePool $args[5] -DiskMapping withvm `
    -DiskProvisioning thin -UseSourceRam -VMName $args[6] -HostName $args[7] -ComputeResource $args[8] -Version vmx-11
    } -ArgumentList @($HostPassword,$HostUserName,$ProtectedServer,$Datacenter,$Datastore,$ResourcePool,$VMName,$HostName,$ComputeResource)
}

function StartExport-HyperV
{
    param(
    $VMLocation = "D:\HyperV_Export",
    $HostPassword = "raid4us!",
    $HostUserName = "Administrator",
    $ProtectedServer = "192.168.90.20",
    $HostName = "192.168.95.100",
    $VMName = "Resilience_HyperV_Export"

    )
    $Path = ($VMLocation + "\" + $VMName)
    
    New-Snapshot -All

    $session = New-Session -ComputerName $HostName
    if(!(Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Force} -ArgumentList $Path))
    {
        Write-Host "Machine not exist"
    }else{
        Invoke-Command -Session $session -ScriptBlock {Remove-VM -Name $args[0] -Confirm:$false -Force; Start-Sleep -Seconds 10} -ArgumentList $VMName
        Invoke-Command -Session $session -ScriptBlock {Get-ChildItem $args[0] -Recurse -Force | Remove-Item -Confirm:$false -Force -Recurse} -ArgumentList $VMLocation
    }

    Get-PSSession | Remove-PSSession -Confirm:$false

    Start-Job -ScriptBlock {
    Start-HyperVExport -HostPassword $args[0] -HostUserName $args[1] -ProtectedServer $args[2] -VMLocation $args[3] -UseSourceRam -VMName $args[4] -UseVhdx -HostName $args[5]
    } -ArgumentList @($HostPassword,$HostUserName,$ProtectedServer,$VMLocation,$VMName,$HostName)
}

Function Disable-NET
{
    param(
    $waitJob = 150,
    $disableTime = 290
    )


    Start-Sleep -Seconds $waitJob

    Get-NetAdapter | %{Disable-NetAdapter -Name $_.Name -Confirm:$false}

    Start-Sleep -Seconds $disableTime

    Get-NetAdapter | %{Enable-NetAdapter -Name $_.Name -Confirm:$false}

}

Import-Module VMware.VimAutomation.Vds
Import-Module VMware.VimAutomation.Core

Connect-VIServer -Server 192.168.64.76 -User administrator@vsphere.local -Password P@ssw0rd -Force

ipmo rapidrecovery*

while($true)
{
    StartExport-VMWare
    Disable-NET -disableTime 800
    Start-Sleep -Seconds 100
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}

    StartExport-VBox
    Disable-NET -disableTime 830
    Start-Sleep -Seconds 100
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}

    StartExport-HyperV -HostName "192.168.95.101"
    Start-Sleep -Seconds 240
    Disable-NET -disableTime 700 -waitJob 240
    Start-Sleep -Seconds 300
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}
    
    StartExport-ESXi
    Disable-NET -disableTime 700 -waitJob 540
    Start-Sleep -Seconds 300
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}
    
}