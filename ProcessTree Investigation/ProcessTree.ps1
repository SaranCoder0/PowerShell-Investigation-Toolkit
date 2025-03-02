param (
    [Parameter(Mandatory = $true)]
    [int]$ProcessID,

    [switch]$Hash   # Optional switch to extract SHA-256 hash
)

# Define output file
$OutputFile = "$PSScriptRoot\ProcessTreeOutput.txt"

# Clear previous output file (if exists)
if (Test-Path $OutputFile) {
    Clear-Content $OutputFile
}

function Get-FileSHA256 {
    param ([string]$FilePath)

    if (Test-Path $FilePath) {
        try {
            return (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        } catch {
            return "Error calculating hash"
        }
    }
    return "N/A"
}

function Write-Log {
    param (
        [string]$Message,
        [switch]$Highlight
    )
    
    if ($Highlight) {
        Write-Host $Message -ForegroundColor Yellow   # Highlighted in Yellow for Console
    } else {
        Write-Host $Message  # Normal Console Output
    }
    
    Add-Content -Path $OutputFile -Value $Message   # Save to file
}

function Get-ProcessTree {
    param ([int]$ParentProcessID, [int]$Level = 0)

    if ($ParentProcessID -eq 0) {
        Write-Log "Invalid ProcessID (0). Please provide a valid ProcessID." -Highlight
        return
    }

    $children = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ParentProcessID }

    if (-not $children) {
        Write-Log (" " * ($Level * 4) + "|-- No child processes found for $ParentProcessID")
        return
    }

    foreach ($child in $children) {
        $exePath = $child.ExecutablePath
        if (-not $exePath) { $exePath = "N/A" }

        $logMessage = " " * ($Level * 4) + "|-- " + $child.ProcessId + " : " + $child.Name + " ($exePath)"

        if ($Hash -and $exePath -ne "N/A") {
            $hashValue = Get-FileSHA256 -FilePath $exePath
            $logMessage += " SHA256: $hashValue"
        }

        # Highlight in console + file if the process is the given ProcessID
        if ($child.ProcessId -eq $ProcessID) {
            Write-Log ("|-- ==> ***$logMessage*** <==") -Highlight
        } else {
            Write-Log $logMessage
        }

        Get-ProcessTree -ParentProcessID $child.ProcessId -Level ($Level + 1)
    }
}

# Step 1: Get Parent Process ID
$process = Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -eq $ProcessID }

if ($process) {
    $ParentProcessID = $process.ParentProcessId
    Write-Log "`nParent Process ID for ==> ***$($ProcessID)*** : $ParentProcessID`n" -Highlight

    # Step 2: Fetch Process Tree for Parent Process ID
    if ($ParentProcessID -ne 0) {
        Write-Log "`nProcess Tree for Parent Process ID: $ParentProcessID`n"
        $parentProcess = Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -eq $ParentProcessID }
        if ($parentProcess) {
            $exePath = $parentProcess.ExecutablePath
            if (-not $exePath) { $exePath = "N/A" }

            $logMessage = "$ParentProcessID : $($parentProcess.Name) ($exePath)"
            
            if ($Hash -and $exePath -ne "N/A") {
                $hashValue = Get-FileSHA256 -FilePath $exePath
                $logMessage += " SHA256: $hashValue"
            }

            Write-Log $logMessage
            Get-ProcessTree -ParentProcessID $ParentProcessID
        } else {
            Write-Log "Parent process not found."
        }
    } else {
        Write-Log "No valid parent process found."
    }
} else {
    Write-Log "No process found with ID $ProcessID"
}

Write-Log "`nProcess tree saved to: $OutputFile"
