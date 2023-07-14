# Set the specific folders to check for changes
$specificFolders = @("customers", "internal", "tools")

# Fetch the latest changes from the remote repository
git fetch

<<<<<<< HEAD
# Get the commit hash of the remote master branch
$remoteMasterCommit = git rev-parse origin/master
=======
    # check for conflicts
    $conflicts = git diff --check origin/$targetBranch..$currentBranch
>>>>>>> 94b3e1ee9781b1d2cb40c6150a6ae447b9d52cdc

# Get the commit hash of the current branch
$currentBranchCommit = git rev-parse HEAD

# Check if the remote master branch has new changes
if ($remoteMasterCommit -ne $currentBranchCommit) {
    Write-Host "The remote 'master' branch has new changes."

    # Check for conflicts between local branch and 'master'
    $conflictOutput = git diff --name-only --diff-filter=U origin/master

    if ($conflictOutput) {
        Write-Host "Conflicts found between the current branch and 'master'."
        Write-Host "Conflicted files:"
        Write-Host $conflictOutput
    } else {
        Write-Host "No conflicts found between the current branch and 'master'."

        # Check if the changes are in the specific folders
        $changesInFolders = git diff --name-only --diff-filter=d origin/master -- $specificFolders

        if ($changesInFolders) {
            Write-Host "Changes are present in the specific folders:"
            Write-Host $changesInFolders
        } else {
            Write-Host "No changes found in the specific folders."
        }
    }
} else {
    Write-Host "The remote 'master' branch does not have any new changes."
}
<<<<<<< HEAD
=======
else {   
    Write-Host "Local branch is up to date with $($targetBranch) branch."
    write-host "============================================`n"
}
>>>>>>> 94b3e1ee9781b1d2cb40c6150a6ae447b9d52cdc
