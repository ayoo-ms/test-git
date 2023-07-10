$targetBranch = "master"

git fetch origin $targetBranch | out-null
$currentBranch = git rev-parse --abbrev-ref HEAD
git merge-base --is-ancestor origin/$targetBranch $currentBranch
$isAheadOrSame = $?
if (-not $isAheadOrSame){

    # check for changes in Tooling and Customer folders
    $directoriesToCheck = @(
       "internal/*",   # changes in permissions, ms graph preautz, tooling etc
        "customers/*",   # customer facing changes
        "tools/*"
      )

    $modifiedFilesInTargetBranch = git diff --name-only origin/$targetBranch

    foreach ($directory in $directoriesToCheck) {
        $modifiedFile = $modifiedFilesInTargetBranch  | Where-Object { $_ -like $directory }
        if ($modifiedFile) {
            Write-Host "Error: Changes in internal tools and/or customer binaries detected, please rebase or pull the latest artifacts from the remote $($targetBranch) branch`n"  -ForegroundColor RED
            exit 1
        }
    }

    # check for conflicts
    $diffOutput = git diff origin/$targetBranch..$currentBranch --name-only --diff-filter=U

    # If the output contains any conflicted files, print an error message
    if ($diffOutput) {
        Write-Host "Error: Conflicts found between remote $($targetBranch) and $($currentBranch) branch."  -ForegroundColor RED
        Write-Host $diffOutput  -ForegroundColor RED
        exit 1
    } else {
        Write-Host "No conflicts found.`n"
    }

    Write-Host "WARNING!! Your local branch is behind origin/$($targetBranch), please rebase or pull the latest artifacts from the remote $($targetBranch) branch`n" -ForegroundColor RED
}
else {   
    Write-Host "Local branch is up to date with $($targetBranch) branch."
    write-host "============================================`n"
}