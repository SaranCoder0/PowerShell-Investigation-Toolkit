# **Usage Steps for Process Tree Script**

## **Step 1: Open PowerShell**

* Press `<span>Win + X</span>` and select **Windows Terminal (Admin)** or **PowerShell (Admin)**.

## **Step 2: Run the Script**

* Execute the following command to retrieve parent and child process ID:
  ```
  .\ProcessTree.ps1
  ```

## Step 3: Retrieve SHA-256 Hash of Executables (Optional)

To include the SHA-256 hash of each process executable in the output, use the `-Hash` flag:

```powershell
.\ProcessTree.ps1 -Hash
```
