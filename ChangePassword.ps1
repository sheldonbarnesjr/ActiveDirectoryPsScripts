# Define the SamAccountName of the user
$samAccountName = "INSERT_NAME"

# Specify the new password - ensure it complies with your domain's password policy
$newPassword = "Password123!"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString -String $newPassword -AsPlainText -Force

# Reset the user's password
Set-ADAccountPassword -Identity $samAccountName -NewPassword $securePassword -Reset

Write-Host "Password for user $samAccountName has been reset."
