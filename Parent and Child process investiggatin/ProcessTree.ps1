param (
    [Parameter(Mandatory = $true)]
    [int]$ProcessID
)

function Get-ProcessTree {
    param ([int]$ParentProcessID, [int]$Level = 0)

    if ($ParentProcessID -eq 0) {
        Write-Host "Invalid ProcessID (0). Please provide a valid ProcessID."
        return
    }

    $children = Get-WmiObject Win32_Process | Where-Object { $_.ParentProcessId -eq $ParentProcessID }

    if (-not $children) {
        Write-Host (" " * ($Level * 4) + "|-- No child processes found for $ParentProcessID")
        return
    }

    foreach ($child in $children) {
        $exePath = $child.ExecutablePath
        if (-not $exePath) { $exePath = "N/A" }

        Write-Host (" " * ($Level * 4) + "|-- " + $child.ProcessId + " : " + $child.Name + " (" + $exePath + ")")
        Get-ProcessTree -ParentProcessID $child.ProcessId -Level ($Level + 1)
    }
}

# Step 1: Get Parent Process ID
$process = Get-WmiObject Win32_Process | Where-Object { $_.ProcessId -eq $ProcessID }

if ($process) {
    $ParentProcessID = $process.ParentProcessId
    Write-Host "`nParent Process ID for $($ProcessID): $ParentProcessID`n"

    # Step 2: Fetch Process Tree for Parent Process ID
    if ($ParentProcessID -ne 0) {
        Write-Host "`nProcess Tree for Parent Process ID: $ParentProcessID`n"
        $parentProcess = Get-WmiObject Win32_Process | Where-Object { $_.ProcessId -eq $ParentProcessID }
        if ($parentProcess) {
            $exePath = $parentProcess.ExecutablePath
            if (-not $exePath) { $exePath = "N/A" }

            Write-Host "$ParentProcessID : $($parentProcess.Name) ($exePath)"
            Get-ProcessTree -ParentProcessID $ParentProcessID
        } else {
            Write-Host "Parent process not found."
        }
    } else {
        Write-Host "No valid parent process found."
    }
} else {
    Write-Host "No process found with ID $ProcessID"
}
