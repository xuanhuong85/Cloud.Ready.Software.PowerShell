. (Join-Path $PSScriptRoot '.\_Settings.ps1')

$ObjectsFolder = "C:\temp"
#$ContainerDockerImage = 'microsoft/bcsandbox'
#$ContainerDockerImage = 'microsoft/dynamics-nav:2018-be'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox-master'
#$ContainerDockerImage = 'bcinsider.azurecr.io/bcsandbox'
$ContainerDockerImage = 'mcr.microsoft.com/businesscentral/onprem'

#Fixed params
$ExportToBase = "$env:USERPROFILE\Dropbox (Personal)\GitHub\Blogs\blog.CALAnalysis\Published Events\"
switch ($true) {
    ($ContainerDockerImage.StartsWith('microsoft/bcsandbox')) {  
        $ExportTo = join-path $ExportToBase 'Business Central SaaS'
        break
    }  
    ($ContainerDockerImage.StartsWith('mcr.microsoft.com/businesscentral/onprem')) {  
        $ExportTo = join-path $ExportToBase 'Business Central OnPrem'
        break
    }  
    ($ContainerDockerImage.StartsWith('bcinsider.azurecr.io/bcsandbox-master')) {  
        $ExportTo = join-path $ExportToBase 'Business Central (Insider)'
        break
    }  
    ($ContainerDockerImage.StartsWith('bcinsider.azurecr.io/bcsandbox')) {  
        $ExportTo = join-path $ExportToBase 'Business Central (Insider)'
        break
    }
    ($ContainerDockerImage.Contains('2018')) {  
        $ExportTo = join-path $ExportToBase 'NAV2018'
        break
    }
    ($ContainerDockerImage.StartsWith('2017')) {  
        $ExportTo = join-path $ExportToBase 'NAV2017'
        break
    }

}

$ModuleToolAPIPath = "$env:USERPROFILE\Dropbox\GitHub\Waldo.Model.Tools\ReVision.Model.Tools Library - laptop"

$Containername = 'temponly'
$ContainerAlwaysPull = $true

New-NavContainer `
    -containerName $ContainerName `
    -imageName $ContainerDockerImage `
    -accept_eula `
    -additionalParameters $ContainerAdditionalParameters `
    -licenseFile $SecretSettings.containerLicenseFile `
    -alwaysPull:$ContainerAlwaysPull `
    -Credential $ContainerCredential `
    -doNotExportObjectsToText `
    -updateHosts `
    -auth NavUserPassword `
    -useBestContainerOS `
    -Verbose `
    -memoryLimit 4G


# $ObjectFile = 
# Export-RDHNAVApplicationObjects `
#     -DockerHost $DockerHost `
#     -DockerHostCredentials $DockerHostCredentials `
#     -DockerHostUseSSL:$DockerHostUseSSL `
#     -DockerHostSessionOption $DockerHostSessionOption `
#     -ContainerName $Containername `
#     -Path $ObjectsFolder

$result = Export-NCHNAVApplicationObjects -ContainerName $ContainerName 

Export-NAVEventPublishers `
    -ModuleToolAPIPath $ModuleToolAPIPath `
    -SourceFile $result `
    -DestinationFolder $ExportTo `
    -Verbose

break

Remove-NAVContainer -ContainerName $Containername 

start $ExportTo 