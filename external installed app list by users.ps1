$tenantId = ""
$clientId = ""
$clientSecret = ""
 
# Auth URL and API base
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$graphApiBaseUrl = "https://graph.microsoft.com/v1.0"
 
# Get OAuth Token
$token = Invoke-RestMethod -Method Post -Uri $tokenUrl -ContentType "application/x-www-form-urlencoded" -Body @{
   client_id     = $clientId
   scope         = "https://graph.microsoft.com/.default"
   client_secret = $clientSecret
   grant_type    = "client_credentials"
}
$accessToken = $token.access_token
$headers = @{Authorization = "Bearer $accessToken"}
 
# Get all users (handle pagination later if needed)
$users = Invoke-RestMethod -Method Get -Uri "$graphApiBaseUrl/users" -Headers $headers
$userAppMap = @{}
 
foreach ($user in $users.value) {
    $email = $user.mail
    $userId = $user.id
 
    # Check if $email is not null or empty
    if (![string]::IsNullOrEmpty($email)) {
        $installedApps = Invoke-RestMethod -Method Get -Uri "$graphApiBaseUrl/users/$userId/teamwork/installedApps?expand=teamsApp" -Headers $headers
 
        foreach ($app in $installedApps.value) {
            $appId = $app.teamsApp.displayName
            if ($userAppMap.ContainsKey($email)) {
                $userAppMap[$email] += $appId
            } else {
                $userAppMap[$email] = @($appId)
            }
        }
    } else {
        Write-Host "Skipping user with ID $userId because email is null or empty."
    }
}
 
# Save this intermediate result to JSON for reuse
$userAppMap | ConvertTo-Json -Depth 10 | Out-File "C:\Users\Shivam.Malik\OneDrive - 1\userAppMapmyiddd.json"
 
# Load previously saved user-app data
$userAppMap = Get-Content "C:\Users\Shivam.Malik\OneDrive - 1\userAppMapmyiddd.json" | ConvertFrom-Json
 
# Reverse: AppId → Users
$appUserMap = @{}
 
foreach ($user in $userAppMap.PSObject.Properties.Name) {
    $apps = $userAppMap.$user
    foreach ($app in $apps) {
        if ($appUserMap.ContainsKey($app)) {
            $appUserMap[$app] += $user
        } else {
            $appUserMap[$app] = @($user)
        }
    }
}
 
# Format for CSV output
$results = @()
foreach ($appId in $appUserMap.Keys) {
    $userList = $appUserMap[$appId] -join ", "
    $results += [PSCustomObject]@{
        TeamsAppId = $appId
        Users      = $userList
    }
}
 
# Export to CSV
$results | Export-Csv -Path "C:\Users\Shivam.Malik\OneDrive - 1\FinalAppUserListMYtestiddd.csv"