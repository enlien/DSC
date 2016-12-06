Configuration MyConfiguration{
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$ConfigurationName,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Absent","Present")]
        [string]$Ensure
    )

    Import-DscResource -ModuleName cRavenDb,xNetworking
    Node $ConfigurationName {
        cRavenDB RavenDb {
            DataDir = "c:\RavenDb\Data"
            DeleteFilesAndData = $true
            Ensure = $Ensure
            InstallPath = "c:\RavenDb"
            Name = "MyRavenDb"
            Version = "3.5.1"
            Port = "8080"
        }
        xFirewall OpenRavenDBPort {
            Action = 'Allow'
            Description = "RavenDb Inngående"
            Direction = 'Inbound'
            DisplayName = "RavenDb"
            Ensure = $Ensure
            Enabled = 'True'
            LocalPort = '8080'
            Name = "RavenDb"
            Protocol = "Tcp"
        }
    }
}

$folder = "C:\DSC\MyConfiguration"
$configurationName = "MyConfiguration"
MyConfiguration -OutPutPath $folder -ConfigurationName $configurationName -Ensure "Present" -Verbose
Publish-DSCModuleAndMof -Source $folder -ModuleNameList @('cRavenDb','xNetworking') -Force -Verbose