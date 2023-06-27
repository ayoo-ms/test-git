 $targetBranch = "master"

 git fetch origin $targetBranch | out-null
 $currentBranch = git rev-parse --abbrev-ref HEAD
 $conflictingChanges = git merge-base --is-ancestor origin/$targetBranch $currentBranch
 $isAheadOrSame = $?
 if (-not $isAheadOrSame){
     Write-Host "WARNING!! Your local branch is behind origin/$($targetBranch), please rebase or pull the latest artifacts from the remote $($targetBranch) branch`n" ForegroundColor RED
    }
elseif ($conflictingChanges) {
    Throw "Conflicting changes detected between current branch and remote $($targetBranch), please rebase or pull the latest artifacts from the remote $($targetBranch) branch`n"
    exit 1
    }
    else {   
        Write-Host "Local branch is up to date with $($targetBranch) branch."
        write-host "============================================`n"
    }

    # check for changes in Tooling and Customer folders
 $directoriesToCheck = @(
     "Internal/Tools/*",   # changes in permissions, ms graph preautz, tooling etc
      "Customers/Powershell/*",   # customer facing changes
      "Customers/Configs/*"
    )

 $modifiedFilesInTargetBranch = git diff --name-only origin/$targetBranch

 foreach ($directory in $directoriesToCheck) {
     $modifiedFile = $modifiedFilesInTargetBranch  | Where-Object { $_ -like $directory }
     if ($modifiedFile) {
          Throw "Changes in internal tools and/or customer binaries detected, please rebase or pull the latest artifacts from the remote $($targetBranch) branch`n"
         exit 1
        }
    }