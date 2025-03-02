# PowerShell Scripts and Commands for Investigation

A collection of **PowerShell commands and scripts** for **threat hunting, forensic investigation, and security analysis**.

---

## System Investigation

### Get System Information

```powershell
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsDomain
```

### Check Running Processes

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```

```powershell
Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine | Format-Table -AutoSize
```

---

## Persistence & Startup Investigation

### Check Startup Programs

```powershell
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location | Format-Table -AutoSize
```

### Check Registry Run Keys for Persistence

```powershell
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
```

### List Scheduled Tasks

```powershell
Get-ScheduledTask | Where-Object {$_.State -eq "Ready"} | Select-Object TaskName, TaskPath, Actions
```

---

## Log & Event Analysis

### Check Failed Logins (Event ID 4625)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4625} | Select-Object TimeCreated, Message
```

### Detect Privilege Escalation Attempts (Event ID 4673)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4673} | Select-Object TimeCreated, Message
```

### Find Cleared Security Logs (Event ID 1102)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 1102} | Select-Object TimeCreated, Message
```

---

## Network Investigation

### List Active Network Connections

```powershell
Get-NetTCPConnection | Sort-Object State | Format-Table -AutoSize
```

### Find External Connections

```powershell
Get-NetTCPConnection | Where-Object {$_.RemoteAddress -notlike "192.168.*" -and $_.RemoteAddress -notlike "10.*"} | Format-Table -AutoSize
```

### Display Network Adapters & IPs

```powershell
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress
```

---

## Forensic Investigation

### Find Recently Modified Files (Last 7 Days)

```powershell
Get-ChildItem -Path C:\Users\ -Recurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} | Sort-Object LastWriteTime -Descending
```

### Get Installed Software

```powershell
Get-WmiObject Win32_Product | Select-Object Name, Version
```

---

## Sysmon & Threat Hunting

### Find Newly Created Processes (Sysmon Event ID 1)

```powershell
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational | Where-Object {$_.Id -eq 1} | Select-Object TimeCreated, Message
```

### Detect Suspicious Network Traffic (Sysmon Event ID 3)

```powershell
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational | Where-Object {$_.Id -eq 3} | Select-Object TimeCreated, Message
```

---

## Export Logs for Splunk or Analysis

```powershell
Get-WinEvent -LogName Security -MaxEvents 1000 | Export-Csv -Path C:\Logs\SecurityLogs.csv -NoTypeInformation
```

---

## Contribution

Feel free to contribute by adding more PowerShell scripts for security investigations.

For suggestions or improvements, submit a pull request or open an issue.

---

## References

- [Microsoft PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Sysmon - Windows Event Logging](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Windows Event IDs](https://www.ultimatewindowssecurity.com/securitylog/book/page.aspx?spid=chapter1)

---

Created by [Your Name] | Cybersecurity Enthusias

A collection of **PowerShell commands and scripts** for **threat hunting, forensic investigation, and security analysis**.

---

## System Investigation

### Get System Information

```powershell
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsDomain
```

### Check Running Processes

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```


```powershell
Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine | Format-Table -AutoSize
```

---

## Persistence & Startup Investigation

### Check Startup Programs

```powershell
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location | Format-Table -AutoSize
```

### Check Registry Run Keys for Persistence

```powershell
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
```

### List Scheduled Tasks

```powershell
Get-ScheduledTask | Where-Object {$_.State -eq "Ready"} | Select-Object TaskName, TaskPath, Actions
```

---

## Log & Event Analysis

### Check Failed Logins (Event ID 4625)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4625} | Select-Object TimeCreated, Message
```

### Detect Privilege Escalation Attempts (Event ID 4673)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4673} | Select-Object TimeCreated, Message
```

### Find Cleared Security Logs (Event ID 1102)

```powershell
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 1102} | Select-Object TimeCreated, Message
```

---

## Network Investigation

### List Active Network Connections

```powershell
Get-NetTCPConnection | Sort-Object State | Format-Table -AutoSize
```

### Find External Connections

```powershell
Get-NetTCPConnection | Where-Object {$_.RemoteAddress -notlike "192.168.*" -and $_.RemoteAddress -notlike "10.*"} | Format-Table -AutoSize
```

### Display Network Adapters & IPs

```powershell
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress
```

---

## 🛠 Forensic Investigation

### Find Recently Modified Files (Last 7 Days)

```powershell
Get-ChildItem -Path C:\Users\ -Recurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} | Sort-Object LastWriteTime -Descending
```

### Get Installed Software

```powershell
Get-WmiObject Win32_Product | Select-Object Name, Version
```

---

## Sysmon & Threat Hunting

### Find Newly Created Processes (Sysmon Event ID 1)

```powershell
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational | Where-Object {$_.Id -eq 1} | Select-Object TimeCreated, Message
```

### Detect Suspicious Network Traffic (Sysmon Event ID 3)

```powershell
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational | Where-Object {$_.Id -eq 3} | Select-Object TimeCreated, Message
```

---

## Export Logs for Splunk or Analysis

```powershell
Get-WinEvent -LogName Security -MaxEvents 1000 | Export-Csv -Path C:\Logs\SecurityLogs.csv -NoTypeInformation
```

---

## Contribution

 **Feel free to contribute by adding more PowerShell scripts for security investigations.**

**For suggestions or improvements, submit a pull request or open an issue.**

---

## References

- [Microsoft PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Sysmon - Windows Event Logging](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Windows Event ID](https://www.ultimatewindowssecurity.com/securitylog/book/page.aspx?spid=chapter1)
