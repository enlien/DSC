[DscLocalConfigurationManager()]
Configuration Init-SlaveLCM{
    param(
        [Parameter(Mandatory=$True)]
        [string[]]$ComputerName,
        [string]$ConfigurationName
    )
    Node $ComputerName{
        Settings {
            AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyOnly'
            RefreshMode = 'Pull'
            DebugMode = 'ForceModuleImport'
        }
        
        ConfigurationRepositoryWeb Server3DSC-PullSrv
        {
            ServerURL = 'https://Server3DSC:8080/PSDSCPullServer.svc'
            RegistrationKey = '8888fc25-e91b-41e1-9101-c3074d74513f'
            ConfigurationNames = @("$ConfigurationName")
        }   

        ReportServerWeb Server3DSC-PullSrv
        {
            ServerURL = 'https://Server3DSC:8080/PSDSCPullServer.svc'
            RegistrationKey = '8888fc25-e91b-41e1-9101-c3074d74513f'
        }
    }
}

$computerName = 'Server1', 'Server2'

Init-SlaveLCM -OutPutPat "c:\DSC\Init-SlaveLCM" -ComputerName $computerName -ConfigurationName "MyConfiguration"