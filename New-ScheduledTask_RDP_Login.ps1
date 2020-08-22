$cimTriggerClass = cimclass MSFT_TaskEventTrigger root/Microsoft/Windows/TaskScheduler
$trigger = $cimTriggerClass | New-CimInstance -ClientOnly

$trigger.Enabled = $true
$trigger.Subscription = '<QueryList><Query Id="0" Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"><Select Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Operational">*[System[Provider[@Name=''Microsoft-Windows-TerminalServices-LocalSessionManager''] and EventID=21]]</Select></Query></QueryList>'

$ActionPara = @{
    Execute  = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    Argument = '-NoProfile -File C:\Scripts\RDP_login.ps1'
    }

$Action = New-ScheduledTaskAction @ActionPara
$Principal = New-ScheduledTaskPrincipal -UserID andre -LogonType S4U -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet

$RegTaskPara = @{
    TaskName    = 'RDP-Login'
    Description = 'login success authenticated user'
    Action      = $Action
    Principal   = $Principal
    Settings    = $Settings
    Trigger     = $Trigger
}

Register-ScheduledTask @RegTaskPara

