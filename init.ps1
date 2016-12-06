[DscLocalConfigurationManager()]
Configuration Init-Push{
    Node $ComputerName{
        Settings {
            ConfigurationMode = 'ApplyOnly'
            RefreshMode = 'Push'
        }
    }
}

$computerName = 'Server1', 'Server2'

Init-Push -OutPutPat "c:\DSC\Init-Push"