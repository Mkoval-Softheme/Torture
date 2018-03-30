Function Disable-NET
{
    param(
    $waitJob = 150,
    $disableTime = 570,
    $afterDisable = 200
    )


    Start-Sleep -Seconds $waitJob

    Get-NetAdapter | %{Disable-NetAdapter -Name $_.Name -Confirm:$false}

    Start-Sleep -Seconds $disableTime

    Get-NetAdapter | %{Enable-NetAdapter -Name $_.Name -Confirm:$false}

    Start-Sleep -Seconds $afterDisable

}

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
            
        }
    }

    Write-Host ($session.state)
    return $session

}

Function StartReplication
{
    param(
    $AgentName = "localhost",
    $ReplicationName = "Replication",
    $TargetServer = "192.168.90.101",
    $TargetUsername = "administrator",
    $Repository = "Repository 1",
    $Targetpassword = "raid4us!",
    $session = $null
    )

    Invoke-Command -Session $session -ScriptBlock {

        if( (Test-Path C:\generation) -eq 1 ) {Remove-Item C:\generation -Force -Recurse}
        New-Item C:\generation –type directory
        #launch Rnd.exe as wmi process
        $process = get-wmiobject -query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -namespace "root\cimv2" -computername localhost
        $results = $process.Create( "c:\Rnd.exe C" )
        Start-Sleep -Seconds 120
        $results = $process.Create( "Taskkill /f /im Rnd.exe" )
        $results = $process.Delete
        Start-Sleep -Seconds 30
        if( (Test-Path C:\1000*.rnd) -eq 1 ) {Move-Item C:\1000*.rnd -Destination C:\generation -Force}
     }
     Invoke-Command -Session $session -ScriptBlock {
        ipmo rapidrecoverypowershellmodule
        New-Snapshot -ProtectedServer $args[0]
     } -ArgumentList $AgentName

    Start-Sleep -Seconds 15

}

$Agent1 = "mikhail.koval_Network_Resiliency_Agent[1](192.168.90.14)(15-06-2017_03-16-15)"
$Agent2 = "192.168.90.13"
$Agent3 = "Test2012r2"

while($true)
{
    <#Start-Job -ScriptBlock {New-Snapshot -ProtectedServer $args[0] } -ArgumentList $Agent1
    Disable-NET -waitJob 240
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}#>

    Start-Job -ScriptBlock {New-Snapshot -ProtectedServer $args[0] } -ArgumentList $Agent2
    Disable-NET -waitJob 150 -disableTime 540
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}

    <#Start-Job -ScriptBlock {New-Snapshot -ProtectedServer $args[0] } -ArgumentList $Agent3
    Disable-NET -waitJob 240
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}#>

    $session = New-Session -ComputerName 192.168.90.15
    StartReplication -session $session
    Get-PSSession | Remove-PSSession
    Disable-NET -waitJob 20 -disableTime 840 -afterDisable 150
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}

    $session = New-Session -ComputerName 192.168.64.55
    StartReplication -session $session -AgentName "192.168.90.13"
    Get-PSSession | Remove-PSSession
    Disable-NET -waitJob 20 -disableTime 840 -afterDisable 150
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){}

    Start-Sleep -Seconds 300
}
