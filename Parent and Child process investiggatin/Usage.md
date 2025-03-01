
# **Usage Steps for Process Tree Script**

## **Step 1: Open PowerShell**

* Press `<span>Win + X</span>` and select **Windows Terminal (Admin)** or **PowerShell (Admin)**.

## **Step 2: Run the Script**

* Execute the following command to retrieve parent and child process IDs:
  ```
  .\ProcessTree.ps1
  ```

## **Step 3: Analyze the Output**

* The script will display a list of processes with their **Parent Process ID (PPID)** and **Child Process IDs**.

## **Step 4: Investigate Suspicious Processes**

* Use additional commands like:

  ```
  Get-Process -Id <ProcessID>
  ```

  to fetch details of any suspicious process.

## **Step 5: Close PowerShell**

* Type `<span>exit</span>` and press **Enter** to close the terminal.
