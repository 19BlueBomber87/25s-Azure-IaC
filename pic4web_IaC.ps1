#download Pics
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/html/cert.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\\cert.jpg
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/AquaMoose.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\\AquaMoose.jpg
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/babymoose2.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\\babymoose2.jpg
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bull.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\\bull.jpg
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bunny.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\\bunny.jpg
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bunny2.jpg" -OutFile C:\\inetpub\\wwwroot\\jpg\bunny2.jpg

#add computer info to web site
$html = Get-Content C:\\inetpub\\wwwroot\\Default.htm
$html.replace("Custom Heading Size and Font Type","$ENV:COMPUTERNAME`n$(Get-Date)`n$([System.Net.Dns]::GetHostAddresses($ENV:COMPUTERNAME))") | Out-File C:\\inetpub\\wwwroot\\Default.htm
