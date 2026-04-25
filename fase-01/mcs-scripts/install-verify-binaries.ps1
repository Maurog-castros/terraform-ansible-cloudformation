Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDirectory = Split-Path -Parent $PSCommandPath
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$logPath = Join-Path $scriptDirectory "install-verify-binaries-$timestamp.log"
$failures = [System.Collections.Generic.List[string]]::new()

function Write-Log {
    param (
        [Parameter()]
        [AllowEmptyString()]
        [string] $Message
    )

    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    $line | Tee-Object -FilePath $logPath -Append
}

function Invoke-LoggedCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Label,

        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [string[]] $Arguments = @()
    )

    Write-Log ""
    Write-Log "===== $Label ====="
    Write-Log "Command: $FilePath $($Arguments -join ' ')"

    $command = Get-Command -Name $FilePath -ErrorAction SilentlyContinue

    if ($null -eq $command) {
        $message = "MISSING: '$FilePath' was not found in PATH"
        Write-Log $message
        $script:failures.Add("$Label - $message")
        return
    }

    Write-Log "ResolvedPath: $($command.Source)"

    try {
        $output = & $command.Source @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    } catch {
        $message = "ERROR: $($_.Exception.Message)"
        Write-Log $message
        $script:failures.Add("$Label - $message")
        return
    }

    if ($null -ne $output) {
        $output | ForEach-Object { Write-Log $_.ToString() }
    }

    Write-Log "ExitCode: $exitCode"

    if ($exitCode -ne 0) {
        $script:failures.Add("$Label - ExitCode $exitCode")
    }
}

function Invoke-LoggedAnsibleVersion {
    Write-Log ""
    Write-Log "===== Ansible version ====="

    $ansibleCommand = Get-Command -Name 'ansible' -ErrorAction SilentlyContinue

    if ($null -ne $ansibleCommand) {
        Invoke-LoggedCommand -Label 'Ansible version' -FilePath 'ansible' -Arguments @('--version')
        return
    }

    Write-Log "Command: ansible --version"
    Write-Log "MISSING: 'ansible' was not found in Windows PATH"

    $wslCommand = Get-Command -Name 'wsl' -ErrorAction SilentlyContinue

    if ($null -eq $wslCommand) {
        $message = "MISSING: 'wsl' was not found. Install Ubuntu with: wsl --install -d Ubuntu"
        Write-Log $message
        $script:failures.Add("Ansible version - $message")
        return
    }

    $distributions = @(& $wslCommand.Source -l -q 2>$null |
        ForEach-Object { $_ -replace "`0", '' } |
        Where-Object { $_ -and $_ -notmatch '^docker-desktop' })

    if ($null -eq $distributions -or $distributions.Count -eq 0) {
        $message = "MISSING: no Linux WSL distribution found. Install Ubuntu with: wsl --install -d Ubuntu"
        Write-Log $message
        $script:failures.Add("Ansible version - $message")
        return
    }

    $distribution = $distributions[0]
    Write-Log "WSLDistribution: $distribution"
    Write-Log "FallbackCommand: wsl -d $distribution -- ansible --version"

    try {
        $output = & $wslCommand.Source -d $distribution -- ansible --version 2>&1
        $exitCode = $LASTEXITCODE
    } catch {
        $message = "ERROR: $($_.Exception.Message)"
        Write-Log $message
        $script:failures.Add("Ansible version - $message")
        return
    }

    if ($null -ne $output) {
        $output | ForEach-Object { Write-Log $_.ToString() }
    }

    Write-Log "ExitCode: $exitCode"

    if ($exitCode -ne 0) {
        $script:failures.Add("Ansible version - install Ansible inside WSL with: sudo apt update && sudo apt install -y ansible")
    }
}

Write-Log "Starting binary verification"
Write-Log "Script directory: $scriptDirectory"

Invoke-LoggedCommand -Label 'Terraform version' -FilePath 'terraform' -Arguments @('version')
Invoke-LoggedAnsibleVersion
Invoke-LoggedCommand -Label 'AWS CLI version' -FilePath 'aws' -Arguments @('--version')
Invoke-LoggedCommand -Label 'AWS caller identity' -FilePath 'aws' -Arguments @('sts', 'get-caller-identity')

Write-Log ""
if ($failures.Count -gt 0) {
    Write-Log "Verification completed with failures"
    $failures | ForEach-Object { Write-Log "- $_" }
    Write-Log "Log saved at: $logPath"
    exit 1
}

Write-Log "Verification completed successfully"
Write-Log "Log saved at: $logPath"
