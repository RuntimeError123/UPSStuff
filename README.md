# Introuction
In my homelab I use APC UPSes to prevent data loss on power outages and to make sure that I can finish my work when my house loses AC power. For this purpose I bought 2 devices: 
- APC Back-UPS ES 550G. This has been my main UPS for years and has recently been moved to supply my (Mikrotik) router and Ubiquiti switch with power since I bought my new UPS. The UPS is connected to the Mikrotik router. 
- APC Back-UPS BX700U-GR. This UPS protects my home server running Windows. 
Both UPSes are connected through a USB cable. There are many useful applications to shut down servers gracefully when a power loss occurs, however, I find it useful to be informed in these situations. 

Previously, I used e-mail to notify me in case of a power loss. However, I found that this was getting harder to accomplish in a reliable way. I didn't want to buy a subscription with a cloud provider, just to send some notification emails. I felt that OAuth support was limited in applications that send email notifications, so Outlook.com email addresses were no option either.

In the past I used Telegram notifications from HomeAssistant, but I have replaced this with native notifications through the app. Recently I started using Telegram notifications again for my homelab monitoring solution [UptimeKuma](https://github.com/louislam/uptime-kuma). Let's extend the usage of my Telegram bot through this project!

## Bot in Telegram
As a prerequisite we need to have the Telegram application installed on our phone. To get started we need to create a bot in Telegram. We can use [Botfather](https://t.me/botfather) for this purpose. Store the BotToken somewhere safe. Start a new chat with your bot, type something random just to get the chat started.
Now we need to get the chat ID, where your bot will post the notifications. I think the easiest way is to use the [GetIDs Bot](https://t.me/getidsbot). Just make sure to store the chat ID the bot provides.

This process is described in more detail in the [HomeAssistant documentation](https://www.home-assistant.io/integrations/telegram)

## APCUPSD (Windows)
APCUPSD is a free software package that allows your computer to interface with the APC UPS, allowing for automatic shutdown and notification during power events.
I currently use [APCUPSD](https://sourceforge.net/projects/apcupsd/files/win-binaries%20-%20Stable/3.14.14/) 3.14.14 (in the future I might change to [NUT](https://networkupstools.org) as this seems to be developed more actively.) This application shuts down my Windows Server gracefully when the power doesn't return in time and the UPS battery runs out. 

After installing the MSI, just copy apccontrol.bat and Send-TelegramNotification.ps1 to C:\Program Files (x86)\apcupsd\etc\apcupsd or whatever location you have installed APCUPSD to.

Edit the Send-TelegramNotification.ps1 to include your Telegram BotToken and ChatID and you should be good to go.

## Mikrotik
I tested this on a Mikrotik RB750Gr3 with RouterOS 7.16.2. 
- First install the UPS package by downloading the [Extra packages](https://mikrotik.com/download) from Mikrotik (make sure to select the applicable architecture). Extract this file and use the Files button from Winbox to store the UPS package on your device. Restart the router.
- Check if your UPS is detected through System > Resources > USB
- Go to System > UPS and use the Add (+) button to add your UPS. You can leave the default (ups1) name. If you change this, make sure to change this also in the script. After saving the UPS should be visible and reporting its status, if not try to change the port (mine is on usbhid1).
- Create a schedule through System > Scheduler. 
Name: UPSTelegramNotification
Start Date: current date
Start Time: startup
Interval: 00:01:00 (so it will run and check every minute)
Policy: read, write, policy, test (if those policies aren't enabled, the script will refuse to run).
On event: paste content from Mikrotik.sh and update *bottoken* and *chatid* (and optionally *upsname*).
Save by pressing the apply-button.