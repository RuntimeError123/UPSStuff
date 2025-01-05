:local bottoken "<bottoken>"
:local chatid "<chatid>" 
:local upsname "ups1"

:global flagonbatt;

:local online;
:local sysname [/system identity get name];

:if ([:typeof $flagonbatt]="nothing") do={
    :set flagonbatt 0
    }

/system ups monitor $upsname once do={
    :set online $"on-line";
    }

:if (($online=false) && ($flagonbatt=0)) do={
    :set flagonbatt 1;
    /tool fetch url="https://api.telegram.org/$bottoken/sendMessage?chat_id=$chatid&text=[$sysname] - Power failure. Running on UPS batteries. %F0%9F%94%8B" output=none;
    :log info ("UPS: Telegram power failure message sent")
    }

:if (($online=true) && ($flagonbatt=1)) do={
    :set flagonbatt 0;
    /tool fetch url="https://api.telegram.org/$bottoken/sendMessage?chat_id=$chatid&text=[$sysname] - Power has returned. No longer running on UPS batteries. %F0%9F%94%8C" output=none;
    :log info ("UPS: Telegram power restored message")
    }
