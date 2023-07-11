# Set the specific folders to check for changes
$specificFolders = @("customers", "internal", "tools")

# Fetch the latest changes from the remote repository
git fetch

# Check if the 'master' branch has changes
$hasChanges = git diff --quiet origin/master

if ($hasChanges) {
    Write-Host "The 'master' branch has changes."

    # Check if the changes are in the specific folders
    $changesInFolders = git diff --name-only --diff-filter=d origin/master -- $specificFolders

    if ($changesInFolders) {
        Write-Host "Changes are present in the specific folders:"
        Write-Host $changesInFolders
    } else {
        Write-Host "No changes found in the specific folders."
    }

    # Check for conflicts between local branch and 'master'
    $conflictOutput = git diff --name-only --diff-filter=U origin/master

    if ($conflictOutput) {
        Write-Host "Conflicts found between local branch and 'master'."
        Write-Host "Conflicted files:"
        Write-Host $conflictOutput
    } else {
        Write-Host "No conflicts found between local branch and 'master'."
    }
} else {
    Write-Host "The 'master' branch does not have any changes."
}
