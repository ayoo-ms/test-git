# Set the specific folders to check for changes
$foldersToCheck = @("customers", "internal", "tools")

# Check if 'master' branch has changes
$masterChanges = git diff --name-only origin/master

if ($masterChanges) {
    Write-Host "Changes found in 'master' branch."
    Write-Host "Changed files:"
    Write-Host $masterChanges

    # Check if changes are in specific folders
    $changedFolders = $masterChanges | ForEach-Object {
        Split-Path $_ -Parent | Get-Unique
    }

    $matchingFolders = Compare-Object $foldersToCheck $changedFolders

    if ($matchingFolders) {
        Write-Host "Changes found in the following folders:"
        $matchingFolders | Where-Object { $_.SideIndicator -eq '==' } | ForEach-Object {
            Write-Host $_.InputObject
        }
    } else {
        Write-Host "No changes found in the specified folders."
    }
} else {
    Write-Host "No changes found in 'master' branch."
}

# Set the local branch name
$localBranch = "your-local-branch-name"

# Check for conflicts between local branch and 'master' branch
$conflictOutput = git diff --check origin/master..master

# If conflicts are found, print an error message
if ($conflictOutput) {
    Write-Host "Error: Conflicts found between local branch and 'master' branch."
    Write-Host "Conflicts:"
    Write-Host $conflictOutput
} else {
    Write-Host "No conflicts found between local branch and 'master' branch."
}
