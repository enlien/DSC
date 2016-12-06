Configuration Init-PullServer {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName,
        [Parameter(Mandatory=$true)]
        [string]$Thumbprint,
        [Parameter(Mandatory=$true)]
        [string]$RegistrationKey
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration, PSDesiredStateConfiguration
    
    Node $computerName {

        WindowsFeature DscService {
            Ensure = 'Present'
            Name = "DSC-Service"
        }
        
        WindowsFeature Web-Mgmt-Console {
            Ensure = 'Present'
            Name = "Web-Mgmt-Console"
        }

        xDSCWebService PullWebServer {
            Ensure = 'Present'
            EndpointName = "PullWebServer"
            CertificateThumbPrint = $Thumbprint
            UseSecurityBestPractices = $false
            Port = 8080
            PhysicalPath = "c:\Dsc\PullWebServer"
            ConfigurationPath = "$($env:PROGRAMFILES)\WindowsPowerShell\DscService\Configuration"
            ModulePath = "$($env:PROGRAMFILES)\WindowsPowerShell\DscService\Modules"
            State = "Started"
            DependsOn = '[WindowsFeature]DscService'
        }

       File RegistrationKeyFile
       {
           Ensure = 'Present'
           Type = 'File'
           Contents = $RegistrationKey
           DestinationPath = "$($env:ProgramFiles)\WindowsPowerShell\DscService\RegistrationKeys.txt"
       }
    }
}
$thumbprint = Get-ChildItem Cert:\LocalMachine\My | where -Property FriendlyName -Like "server3dsc*"  | Select-Object -Property Thumbprint

Init-PullServer `
    -OutPutPath "c:\DSC\Init-PullServer" `
    -ComputerName "Server3DSC" `
    -Thumbprint $thumbprint `
    -RegistrationKey "8888fc25-e91b-41e1-9101-c3074d74513f"