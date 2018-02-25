# Windows Azure Storage Reconnaissance Script
# (C) 2018 Matt Burrough
# v1.0

# Requires the Azure PowerShell cmdlets be installed. 
# See https://github.com/Azure/azure-powershell/ for details.

# Before running the script:
#   * Run: Import-Module Azure
#   * Authenticate to Azure in PowerShell
#   * You may also need to run: Set-ExecutionPolicy -Scope Process Unrestricted


# ASM Storage Accounts
Write-Output ">>> ASM <<<"
$storage = Get-AzureStorageAccount
foreach($account in $storage) 
{
    $accountName = $account.StorageAccountName
    Write-Output "======= ASM Storage Account: $accountName ======="
    $key = Get-AzureStorageKey -StorageAccountName $accountName
    $context = New-AzureStorageContext -StorageAccountName `
        $accountName -StorageAccountKey $key.Primary
    $containers = Get-AzureStorageContainer -Context $context
    foreach($container in $containers)
    {
        Write-Output "----- Blobs in Container: $($container.Name) -----"
        Get-AzureStorageBlob -Context $context -Container $container.Name | 
            format-table Name, Length, ContentType, LastModified -auto
    }
    Write-Output "----- Tables -----"
    Get-AzureStorageTable -Context $context | format-table Name -auto
    Write-Output "----- Queues -----"
    Get-AzureStorageQueue -Context $context | 
        format-table Name, Uri, ApproximateMessageCount -auto
    
    $shares = Get-AzureStorageShare -Context $context
    foreach($share in $shares)
    {
        Write-Output "----- Files in Share : $($share.Name) -----"
        Get-AzureStorageFile -Context $context -ShareName $share.Name | 
            format-table Name, @{label='Size';e={$_.Properties.Length}} -auto
    }
    Write-Output ""
}
Write-Output ""

# ARM Storage Accounts
Write-Output ">>> ARM <<<"
$storage = Get-AzureRmStorageAccount
foreach($account in $storage) 
{
    $accountName = $account.StorageAccountName
    Write-Output "======= ARM Storage Account: $accountName ======="
    $key = Get-AzureRmStorageAccountKey -StorageAccountName `
        $accountName -ResourceGroupName $account.ResourceGroupName
    $context = New-AzureStorageContext -StorageAccountName `
        $accountName -StorageAccountKey $key[0].Value
    $containers = Get-AzureStorageContainer -Context $context
    foreach($container in $containers)
    {
        Write-Output "----- Blobs in Container: $($container.Name) -----"
        Get-AzureStorageBlob -Context $context -Container $container.Name | 
            format-table Name, Length, ContentType, LastModified -auto
    }
    Write-Output "----- Tables -----"
    Get-AzureStorageTable -Context $context | format-table Name -auto
    Write-Output "----- Queues -----"
    Get-AzureStorageQueue -Context $context | 
        format-table Name, Uri, ApproximateMessageCount -auto
    
    $shares = Get-AzureStorageShare -Context $context
    foreach($share in $shares)
    {
        Write-Output "----- Files in Share : $($share.Name) -----"
        Get-AzureStorageFile -Context $context -ShareName $share.Name | 
            format-table Name, @{label='Size';e={$_.Properties.Length}} -auto
    }
    Write-Output ""
}