<#
PowerShell helper to add, commit, rebase with remote, and push changes.

Usage:
  .\scripts\git-commit.ps1 -Message "your commit message"

This avoids using shell operators like && or || which are not supported in
older PowerShell versions. It runs the sequence: git add -A; git commit -m <msg>;
git pull --rebase origin HEAD; git push origin HEAD
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Message
)

function Run-GitCommand {
    param([string]$cmd)
    Write-Host "Running: git $cmd"
    $proc = Start-Process -FilePath git -ArgumentList $cmd -NoNewWindow -Wait -PassThru -RedirectStandardOutput .\scripts\git-output.txt -RedirectStandardError .\scripts\git-error.txt
    return $proc.ExitCode
}

# Stage all changes
if ((Run-GitCommand 'add -A') -ne 0) {
    Write-Error "git add failed. See scripts/git-error.txt"
    exit 1
}

# Commit
$commitArgs = "commit -m \"$Message\""
if ((Run-GitCommand $commitArgs) -ne 0) {
    Write-Host "Commit failed or no changes to commit. Continuing to pull/push..."
}

# Pull with rebase to integrate remote changes
if ((Run-GitCommand 'pull --rebase origin HEAD') -ne 0) {
    Write-Warning "git pull --rebase failed. You may need to resolve conflicts manually."
}

# Push
if ((Run-GitCommand 'push origin HEAD') -ne 0) {
    Write-Error "git push failed. See scripts/git-error.txt"
    exit 1
}

Write-Host "Done. Changes pushed to origin."
