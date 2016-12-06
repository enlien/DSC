Configuration MyConfiguration{
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName
    )

    Import-DscResource -ModuleName cRavenDb

    Node $ComputerName {
        cRavenDB RavenDb {
            DataDir = "c:\RavenDb\Data"
            DeleteFilesAndData = $false
            Ensure = 'Present'
            InstallPath = "c:\RavenDb"
            Name = "MyRavenDb"
            Version = "3.5.1"
            Port = "8080"
        }
    }
}

$folder = "C:\DSC\MyConfiguration_push"

MyConfiguration -OutPutPath $folder -ComputerName 'Server1','Server2','Server3DSC'
