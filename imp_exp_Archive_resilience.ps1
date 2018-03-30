Function Disable-NET
{
    param(
    $waitJob = 290,
    $disableTime = 270
    )
    
    Start-Sleep -Seconds $waitJob

    Get-NetAdapter | %{Disable-NetAdapter -Name $_.Name -Confirm:$false}

    Start-Sleep -Seconds $disableTime

    Get-NetAdapter | %{Enable-NetAdapter -Name $_.Name -Confirm:$false}

}

Function ArchiveTo-Azure
{
    param(
    $CloudAccountName = "Azure",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -CloudAccountName $args[0] -CloudContainer $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$EndDate,$Path,$RecycleAction,$StartDate)

}

Function ArchiveTo-Amazon
{
    param(
    $CloudAccountName = "Amazon",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -CloudAccountName $args[0] -CloudContainer $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$EndDate,$Path,$RecycleAction,$StartDate)
}

Function ArchiveTo-OpenStack
{
    param(
    $CloudAccountName = "OpenStack",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test_OpenStack",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -CloudAccountName $args[0] -CloudContainer $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$EndDate,$Path,$RecycleAction,$StartDate)
}

Function ArchiveTo-Rackspace
{
    param(
    $CloudAccountName = "Rackspace",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test_Rackspace",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -CloudAccountName $args[0] -CloudContainer $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$EndDate,$Path,$RecycleAction,$StartDate)
}

Function ArchiveTo-Google
{
    param(
    $CloudAccountName = "Google",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -CloudAccountName $args[0] -CloudContainer $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$EndDate,$Path,$RecycleAction,$StartDate)
}

Function ArchiveTo-NET
{
    param(
    $ArchiveUserName = "Administrator",
    $ArchivePassword = "raid4us!",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "\\192.168.64.127\share\archive_resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt")
    )
    
    net use $Path /del

    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-Archive -All -ArchiveUserName $args[0] -ArchivePassword $args[1] -EndDate $args[2] -Path $args[3] -RecycleAction $args[4] -StartDate $args[5]
    } -ArgumentList @($ArchiveUserName,$ArchivePassword,$EndDate,$Path,$RecycleAction,$StartDate)
}

###############Import################


Function ImportFrom-Azure
{
    param(
    $CloudAccountName = "Azure",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-Archive -All -CloudAccountName $CloudAccountName -CloudContainer $CloudContainer -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate

    Start-Sleep -Seconds 10

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -CloudAccountName $args[0] -CloudContainer $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$Path,$Repository)

}

Function ImportFrom-Amazon
{
    param(
    $CloudAccountName = "Amazon",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 30

    Start-Archive -All -CloudAccountName $CloudAccountName -CloudContainer $CloudContainer -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate

    Start-Sleep -Seconds 30

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 30

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -CloudAccountName $args[0] -CloudContainer $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$Path,$Repository)
}

Function ImportFrom-OpenStack
{
    param(
    $CloudAccountName = "OpenStack",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test_OpenStack",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-Archive -All -CloudAccountName $CloudAccountName -CloudContainer $CloudContainer -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate

    Start-Sleep -Seconds 10

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -CloudAccountName $args[0] -CloudContainer $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$Path,$Repository)
}

Function ImportFrom-Rackspace
{
    param(
    $CloudAccountName = "Rackspace",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test_Rackspace",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-Archive -All -CloudAccountName $CloudAccountName -CloudContainer $CloudContainer -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate

    Start-Sleep -Seconds 10

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -CloudAccountName $args[0] -CloudContainer $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$Path,$Repository)
}

Function ImportFrom-Google
{
    param(
    $CloudAccountName = "Google",
    $CloudContainer = "mkoval",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-Archive -All -CloudAccountName $CloudAccountName -CloudContainer $CloudContainer -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate

    Start-Sleep -Seconds 10

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -CloudAccountName $args[0] -CloudContainer $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($CloudAccountName,$CloudContainer,$Path,$Repository)
}

Function ImportFrom-NET
{
    param(
    $ArchiveUserName = "Administrator",
    $ArchivePassword = "raid4us!",
    $EndDate = (Get-Date).AddHours(1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Path = "\\192.168.64.127\share\archive_resiliency_test",
    $RecycleAction = "erasecompletely",
    $StartDate = (Get-Date).AddYears(-1).ToString("MM/dd/yyyy hh:mm:ss tt"),
    $Repository = "Repository 1"
    )
    
    net use $Path /del

    New-Snapshot -All

    Start-Sleep -Seconds 10

    Start-Archive -All -ArchiveUserName $ArchiveUserName -ArchivePassword $ArchivePassword -EndDate $EndDate -Path $Path -RecycleAction $RecycleAction -StartDate $StartDate
    
    Start-Sleep -Seconds 10

    Remove-RecoveryPoints -All -ProtectedServer (Get-ProtectedServers).DisplayName

    Start-Sleep -Seconds 10

    Start-job -ScriptBlock {
        Start-RestoreArchive -All -ArchiveUserName $args[0] -ArchivePassword $args[1] -Path $args[2] -Repository $args[3]
    } -ArgumentList @($ArchiveUserName,$ArchivePassword,$Path,$Repository)
}

while($true)
{

    
    ArchiveTo-Amazon
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ArchiveTo-Azure
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ArchiveTo-Google
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ArchiveTo-NET
    Disable-NET -waitJob 30
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ArchiveTo-OpenStack
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ArchiveTo-Rackspace
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}
    


    ####################Import#######################

    ImportFrom-Amazon
    Disable-NET 
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}
    

    ImportFrom-Azure
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ImportFrom-Google
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ImportFrom-NET
    Disable-NET -waitJob 30
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ImportFrom-OpenStack
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

    ImportFrom-Rackspace
    Disable-NET
Start-Sleep -Seconds 120
    while((Get-Activejobs -all) -ne "No jobs of the specified type were found on the core."){Start-Sleep -Seconds 120}

}