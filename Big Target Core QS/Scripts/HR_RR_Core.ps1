 Function New-Session # Function for creating SSH session
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

Function HR-Machine
{
    param($iDracIP = $null)
    # Credentials creating
    $Username = "root"
    $Password = "calvin"
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)

    $sshSession = New-SSHSession -ComputerName $iDracIP -Credential $cred -Force # Create SSH session iDRAC

    Invoke-SSHCommand -Index $sshSession.SessionId -Command "racadm serveraction hardreset" | Format-List -Property Output # Command for iDRAC that will hardreset machine

    Start-Sleep -Seconds 300

    Get-SSHSession | Remove-SSHSession # Remove SSH session
}


$minToDeath = Get-Random -Minimum 1 -Maximum 30 # This time waiter created for randomizing time when script will execute
Start-Sleep (60 * $minToDeath)

HR-Machine -iDracIP "10.230.241.18" # Start function for hardreset HR-Machine 