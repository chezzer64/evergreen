Function Get-TelerikFiddlerEverywhere {
    <#
        .SYNOPSIS
            Get the current version and download URL for Telerik Fiddler Everywhere.

        .NOTES
            Site: https://stealthpuppy.com
            Author: Aaron Parker
            Twitter: @stealthpuppy
        
        .LINK
            https://github.com/aaronparker/Evergreen

        .EXAMPLE
            Get-TelerikFiddlerEverywhere

            Description:
            Returns the current version and download URI for Telerik Fiddler Everywhere.
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    Param()

    # Get application resource strings from its manifest
    $res = Get-FunctionResource -AppName ("$($MyInvocation.MyCommand)".Split("-"))[1]
    Write-Verbose -Message $res.Name

    # Get the latest download
    $Response = Resolve-SystemNetWebRequest -Uri $res.Get.Download.Uri

    # Construct the output; Return the custom object to the pipeline
    If ($Null -ne $Response) {
        $PSObject = [PSCustomObject] @{
            Version = [RegEx]::Match($Response.ResponseUri.LocalPath, $res.Get.Download.MatchVersion).Captures.Groups[1].Value
            URI     = $Response.ResponseUri.AbsoluteUri
        }
        Write-Output -InputObject $PSObject
    }
}