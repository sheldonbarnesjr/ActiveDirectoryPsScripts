#Script to create users from a csv file and give them a default password to change at next login

# Import Active Directory Module
Import-Module ActiveDirectory

# Specify the path to the CSV file
$csvPath = "UPDATE_PATH" # Update this path to your CSV file

# Function to generate a unique username
function Get-UniqueUsername {
    param (
        [string]$baseUsername,
        [string]$domain
    )
    $uniqueUsername = $baseUsername
    $i = 0
    do {
        $userPrincipalName = "$uniqueUsername@$domain"
        $exists = Get-ADUser -Filter "UserPrincipalName -eq '$userPrincipalName'" -ErrorAction SilentlyContinue
        if ($exists) {
            $i++
            $uniqueUsername = $baseUsername + $i
        } else {
            return $uniqueUsername
        }
    } while ($exists)
}

# Read the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user and create them in Active Directory
foreach ($user in $users) {
    Write-Host "Processing user $($user.Username)..."
    
    $baseUsername = $user.Username
    $uniqueUsername = Get-UniqueUsername -baseUsername $baseUsername -domain "mydomain.com"
    $userPrincipalName = "$uniqueUsername@mydomain.com"
    $ouPath = "OU=" + $user.OU + ",DC=mydomain,DC=com"

    # User properties
    $userProperties = @{
        SamAccountName = $uniqueUsername
        UserPrincipalName = $userPrincipalName
        Name = $user.FirstName + " " + $user.LastName
        GivenName = $user.FirstName
        Surname = $user.LastName
        Enabled = $true
        AccountPassword = (ConvertTo-SecureString -AsPlainText $user.Password -Force)
        Path = $ouPath
        ChangePasswordAtLogon = $true
    }
    
    # Attempt to create the user
    try {
        New-ADUser @userProperties -ErrorAction Stop
        Write-Host "User ${uniqueUsername} has been successfully added to the $($user.OU) OU."
    } catch {
        Write-Host "Failed to add user ${uniqueUsername}: $_"
    }
}
