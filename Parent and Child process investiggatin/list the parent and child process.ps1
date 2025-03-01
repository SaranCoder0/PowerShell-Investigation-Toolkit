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
