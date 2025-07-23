# WriteLog.psm1 - PowerShell Logging Module

<#+
.SYNOPSIS
    Writes log messages to a daily log file with level and timestamp. It expects the log directory to be initialized before logging messages.
.DESCRIPTION
    Use WriteLog to log messages with levels (INFO, ERROR, WARN, FATAL) to a log file in the .\Logs directory.
.PARAMETER Message
    The message(s) to log.
.PARAMETER Level
    The log level (INFO, ERROR, WARN, FATAL).
.PARAMETER Initialize
    Switch to initialize the log directory and file.
.EXAMPLE
    WriteLog -Message "Started script" -Level INFO
    WriteLog -Initialize
#>

function WriteLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Log')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Log')]
        [ValidateSet('INFO', 'ERROR', 'WARN', "FATAL")]
        [string[]]$Level,

        [Parameter(Mandatory = $false, ParameterSetName = 'Initialize')]
        [switch]$Initialize
    )

    $LogPath = ".\Logs"

    if ($Initialize) {
        if (-not (Test-Path -Path $LogPath)) {
            New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
        }
        $LogFile =  $LogPath +  "\" + (Get-Date -Format "yyyy-MM-dd") + ".logfile.log"
        $MessageHeaders = "Date Level Message"
        Write-Output $MessageHeaders | Out-File -FilePath $LogFile -Append -Encoding utf8
        return
    }

    if ($Message -is [array]) {
        $message = $Message -join " "
    }

    $LogDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss:ffff"
    $LogFile =  $LogPath +  "\" + $($LogDate.Split(" ")[0]) + ".logfile.log"

    $MessageToLog = "$LogDate $Level $message"
    Write-Output $MessageToLog | Out-File -FilePath $LogFile -Append -Encoding utf8
}

Export-ModuleMember -Function WriteLog


