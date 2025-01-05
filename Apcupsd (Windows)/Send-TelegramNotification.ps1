param (
    [string]$Message
)

$BotToken = "<BotToken>"
$ChatID = <ChatID>
$FullMessage = "[$env:COMPUTERNAME] - $Message"
$Uri = "https://api.telegram.org/$BotToken/sendMessage?chat_id=$ChatID&text=$FullMessage"

Invoke-RestMethod -Uri $Uri -Method Post
