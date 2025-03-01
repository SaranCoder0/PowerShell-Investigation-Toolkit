# **Get Parent and Child Process IDs in Windows**

## **Overview**

This PowerShell script retrieves the **Parent Process ID (PPID)** and **Child Process IDs** for a given **Process ID (PID)** in Windows. It helps in process investigation and detecting anomalies.

---

## **Usage Instructions**

### **1. Download the Script**

Save the following script as `<span>Get-ProcessTree.ps1</span>`:

```
# Get Parent Process ID and Child Process IDs for a Given Process ID

param (
    [int]$ProcessID
)

# Get Parent Process ID
$parentProcess = Get-WmiObject Win32_Process -Filter "ProcessId=$ProcessID" | Select-Object ProcessId, ParentProcessId

# Get Child Processes
$childProcesses = Get-WmiObject Win32_Process | Where-Object { $_.ParentProcessId -eq $ProcessID } | Select-Object ProcessId, Name

# Display Results
if ($parentProcess) {
    Write-Output "Process ID: $($parentProcess.ProcessId)"
    Write-Output "Parent Process ID: $($parentProcess.ParentProcessId)"
} else {
    Write-Output "Process with ID $ProcessID not found."
}

Write-Output "`nChild Processes:"
if ($childProcesses) {
    $childProcesses | Format-Table -AutoSize
} else {
    Write-Output "No child processes found for Process ID $ProcessID."
}
```

---

### **2. Open PowerShell and Navigate to the Script Location**

```
cd C:\path\to\script  # Change to the directory where the script is saved
```

### **3. Run the Script**

Execute the script by providing a Process ID:

```
.\Get-ProcessTree.ps1 -ProcessID <Your_PID>
```

Replace `<span><Your_PID></span>` with the target process ID you want to investigate.

---

## **Example Output**

```
Process ID: 1234
Parent Process ID: 567

Child Processes:
ProcessId Name
--------- ----
3456      cmd.exe
7890      powershell.exe
```

---

## **Use Cases**

* **Security Investigation**: Identify if a suspicious process was spawned by malware.
* **System Monitoring**: Understand process hierarchy and relationships.
* **Forensics**: Detect process injection or unauthorized process spawning.

---

## **Additional Notes**

* **Administrator privileges may be required** to retrieve process details.
* If no output appears, verify that the Process ID exists using:
  ```
  Get-Process -Id <Your_PID>
  ```
* Consider using `<span>Sysmon</span>` for advanced process tracking in Windows.

---

### 🚀 Now you can track processes easily with PowerShell!
