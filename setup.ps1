# Set the remote and local branch names
$remoteBranch = "origin/master"
$localBranch = "master"

git fetch

# Set the specific folders to check changes in
$specificFolders = @("customers", "internal", "tools")

# Check if remote `master` has any new changes
$remoteChanges = git rev-list --left-right --count $localBranch...$remoteBranch | ForEach-Object { $_.Split("`t")[1] }

if ($remoteChanges -ne "0") {
    # Remote `master` has new changes
    Write-Host "Remote master has $remoteChanges new changes."

    # Check if the changes conflict with the local branch
    $conflictCheck = git cherry -v $localBranch $remoteBranch | Select-String -Pattern "^\+" -NotMatch

    if ($conflictCheck) {
        # Changes do not conflict with the local branch

        # Check if the changes are in specific folders
        $changedFiles = git diff --name-only $localBranch..$remoteBranch -- $specificFolders

        if ($changedFiles) {
            # Changes are in specific folders
            Write-Host "Remote changes in specific folders:"
            $changedFiles
        }
        else {
            # No changes in specific folders
            Write-Host "Remote changes are not in specific folders."
        }
    }
    else {
        # Changes conflict with the local branch
        Write-Host "Remote changes conflict with the local branch."
    }
}
else {
    # Local branch is up to date with remote `master`
    Write-Host "Local branch is up to date with remote master."
}
