function Get-RStudio {
    <#
        .SYNOPSIS
            Returns the available RStudio version and download URI.

        .NOTES
            Author: Andrew Cooper
            Twitter: @adotcoop
            Based on Get-AtlassianBitbucket.ps1
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        $res = (Get-FunctionResource -AppName ("$($MyInvocation.MyCommand)".Split("-"))[1])
    )

    # Read the download URI
    $Content = Invoke-RestMethodWrapper -Uri $res.Get.Download.Uri

    # Step through each installer type
    foreach ($Product in $res.Get.Download.Products) {

        # Build the output object; Output object to the pipeline
        $PSObject = [PSCustomObject] @{
            Version      = $Content.rstudio.$Product.stable.desktop.installer.windows.version
            ProductName  = $Content.rstudio.$Product.stable.desktop.installer.windows.label
            Pro          = $Content.rstudio.$Product.stable.desktop.installer.windows.pro
            Date         = $Content.rstudio.$Product.stable.desktop.installer.windows.last_modified
            Size         = $Content.rstudio.$Product.stable.desktop.installer.windows.size
            Sha256       = $Content.rstudio.$Product.stable.desktop.installer.windows.sha256
            Type         = Get-FileType -File $Content.rstudio.$Product.stable.desktop.installer.windows.url
            URI          = $Content.rstudio.$Product.stable.desktop.installer.windows.url
        }
        Write-Output -InputObject $PSObject
    }
}
