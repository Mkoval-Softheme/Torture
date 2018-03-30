Function HR-ESXi
{
    # Credentials creating
    $Username = "root"
    $Password = "calvin"
    $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)

    New-SSHSession -ComputerName "10.230.240.163" -Credential $cred -Force # Create SSH session iDRAC

    Invoke-SSHCommand -Index 0 -Command "racadm serveraction hardreset" | Format-List -Property Output # Command for iDRAC that will hardreset DR

    Start-Sleep -Seconds 600

    Get-SSHSession | Remove-SSHSession # Remove SSH session
}

$minToDeath = Get-Random -Minimum 1 -Maximum 120 # This time waiter created for randomizing time when script will execute
Start-Sleep -Seconds (60 * $minToDeath)

Install-Module Posh-SSH -Force -Confirm:$false 
 
HR-ESXi # Start function for hardreset ESXi