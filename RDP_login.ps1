$EventId = 21

$A = Get-WinEvent -MaxEvents 1 -FilterHashTable @{LogName='Microsoft-Windows-TerminalServices-LocalSessionManager/Operational'; ID = $EventId} | Select-Object @{n='TimeCreated';e={$_.TimeCreated.ToString("dd.MM.yyyy HH:mm:ss")}},Machinename,ProviderName,Id,Message
$Message = $A.Message
$EventID = $A.Id
$MachineName = $A.MachineName
$Source = $A.ProviderName
$Timestamp = $A.TimeCreated
$pw = Get-Content $env:USERPROFILE\Documents\MailPW.txt | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PSCredential "user@domain.com", $pw
$signature = Invoke-WebRequest -Uri https://.....index.html -UseBasicParsing
$From = "user@domain.com"
$To = 'user@domain.com'
$Subject = "Server Login Notification from $MachineName"
$Body = "EventID: $EventID`nSource: $Source`nMachineName: $MachineName `nMessage: $Message Logged: $Timestamp"
$body += $signature
$SMTPServer = "smtp-mail.outlook.com"
$SMTPPort = "587"
Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Credential $cred