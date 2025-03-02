# **Case Investigation: Suspicious TCP Connection in Windows**

## **Case Overview**

A potentially unknown TCP connection was observed on a Windows system. The objective of this investigation is to determine:

* Which port and IP address were involved?
* Which process initiated the connection?
* Whether the process is legitimate or potentially malicious.

---

## **Step 1: Identifying the Suspicious Connection**

Using the PowerShell command:

```powershell
Get-NetTCPConnection | Where-Object {$_.RemoteAddress -notlike "192.168.*" -and $_.RemoteAddress -notlike "10.*"} | Format-Table -AutoSize
```

### **Explanation:**

* Retrieves active TCP connections on the system.
* Filters out internal (private) IP addresses.
* Formats the output in a readable table.

We identified the following connection:

| Local IP      | Local Port | Remote IP      | Remote Port | State       | Owning Process |
| ------------- | ---------- | -------------- | ----------- | ----------- | -------------- |
| 192.168.0.109 | 52103      | 74.125.200.188 | 5228        | Established | 700            |

This indicates that a process with **Process ID (PID) 700** has an active TCP connection to **74.125.200.188** on port  **5228** .

---

## **Step 2: Process Identification**

To determine the process responsible for this connection, we ran:

```powershell
Get-Process -Id 700
```

### **Explanation:**

* Fetches details about a process using its Process ID.
* Helps determine if the process is legitimate.

#### **Output:**

```
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- ------------
    417      30    27928      54740      84.16    700   1 chrome
```

### **Findings:**

* The process with PID **700** is **chrome.exe** (Google Chrome).
* Memory usage is around  **27MB (PM)** , and CPU usage is  **84.16 seconds** .
* Since Google Chrome is a well-known legitimate process, it is  **not inherently malicious** .

---

## **Step 3: Verifying the Remote IP Address**

The remote IP **74.125.200.188** belongs to  **Google LLC** .
To confirm this, we performed an nslookup:

```powershell
nslookup 74.125.200.188
```

### **Explanation:**

* Resolves an IP address to a domain name.
* Helps verify if the remote IP belongs to a trusted entity.

#### **Results:**

```
Name:  muc11s01-in-f4.1e100.net
Address: 74.125.200.188
```

* This confirms the IP is owned by Google, likely used for  **Google services or Firebase Cloud Messaging** .
* Port **5228** is commonly associated with  **Google Play Services** .

---

## **Step 4: Checking for Anomalies**

While the connection itself is legitimate, additional security checks can be performed:

### **Check Chrome for Malicious Extensions**

```powershell
Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\Extensions"
```

### **Explanation:**

* Lists installed Chrome extensions.
* Helps check for potentially malicious browser add-ons.

### **Check for Unauthorized Parent Process**

```powershell
Get-WmiObject Win32_Process -Filter "ProcessId=700" | Select-Object ParentProcessId
```

### **Explanation:**

* Retrieves the parent process of a given process.
* Useful for detecting process injection or unauthorized executions.

### **Check for Unauthorized Outbound Traffic**

```powershell
netstat -ano | findstr "700"
```

### **Explanation:**

* Displays network connections associated with a specific process.
* Helps in identifying unusual outbound connections.

---

## **Conclusion**

* **The connection to 74.125.200.188:5228 is legitimate** and part of Google's infrastructure.
* **chrome.exe** is a known trusted process.
* No immediate malicious activity detected, but periodic monitoring of network connections and process activities is recommended.

### **Recommendations**

No immediate action required.
If unusual outbound connections occur, inspect Chrome extensions and processes.
Consider using Windows Defender, Sysmon, or Splunk for continuous monitoring.

---

## **Additional Resources**

* [Microsoft Docs: Investigating Network Connections](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netstat)
* [Google Play Services - TCP Port 5228](https://support.google.com/googleplay/android-developer/answer/9441950?hl=en)
