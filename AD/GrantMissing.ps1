# -----------------------------
# Anonymized / generic version
# -----------------------------

$BaselineUsers = @("baselineUser01","baselineUser02")   # Users whose common group memberships are the baseline
$UsersToGrant  = @("targetUser01")                     # Users to receive missing memberships

try {
    $ScriptNameNoExt = ($myInvocation.MyCommand.Name).Replace(".ps1","")
    $dt = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Start-Transcript -Path "$PSScriptRoot\$ScriptNameNoExt-Transcript-$dt.log" -IncludeInvocationHeader -Force

    # Build a list of groups common to all baseline users
    $Result = Get-ADUser $BaselineUsers[0] -Properties MemberOf |
        Select-Object -ExpandProperty MemberOf

    foreach ($Index in 1..($BaselineUsers.Count - 1)) {
        $BaselineGroups = Get-ADUser $BaselineUsers[$Index] -Properties MemberOf |
            Select-Object -ExpandProperty MemberOf

        $Result = Compare-Object -ReferenceObject $Result -DifferenceObject $BaselineGroups -IncludeEqual |
            Where-Object SideIndicator -EQ "==" |
            Select-Object -ExpandProperty InputObject
    }

    foreach ($user in $UsersToGrant) {
        Write-Host "Processing user: $user"

        $UserCurrGroups = Get-ADUser $user -Properties MemberOf |
            Select-Object -ExpandProperty MemberOf

        # Groups that exist in baseline-common list, but user doesn't currently have
        $MissingGroups = Compare-Object -ReferenceObject $UserCurrGroups -DifferenceObject $Result |
            Where-Object SideIndicator -EQ "=>" |
            Select-Object -ExpandProperty InputObject |
            ForEach-Object { $_ } |
            Where-Object {
                try {
                    (Get-ADGroup $_ -Properties wWWHomePage).wWWHomePage -eq $null
                }
                catch { $false }
            }

        foreach ($group in $MissingGroups) {
            Add-ADGroupMember -Identity $group -Members $user -Confirm:$false -Verbose
        }
    }
}
catch {
    Write-Host "An error occurred:"
    Write-Host $_
}
finally {
    Stop-Transcript
}
