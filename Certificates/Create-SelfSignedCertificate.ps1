#requires -Version 5.1

<#
.SYNOPSIS
    Generates a self-signed certificate and exports it to the specified file paths.
    This version only functions on Windows.

.DESCRIPTION
    The Create-SelfSignedCertificate function generates a self-signed certificate with the specified name and exports it to the following file paths:
    - Certificate file (.cer): .\secrets\$CertificateName.cer
    - PFX file (.pfx): .\secrets\$CertificateName.pfx
    - Thumbprint file (.thumbprint.txt): .\secrets\$CertificateName.thumbprint.txt

.PARAMETER CertificateName
    The name of the certificate to be generated.

.EXAMPLE
    Create-SelfSignedCertificate -CertificateName "kth-mgmt-mfastatus-read-account-xxx"
    Generates a self-signed certificate with the name "kth-mgmt-mfastatus-read-account-xxx" and exports it to the specified file paths.
#>
function Create-SelfSignedCertificate {
    param (
        [Parameter(Mandatory=$true)]
        [string]$CertificateName
    )

    #Parameters
    $CertificatePassword = "changeit"
    $secretsFolderPath = ".\secrets"
    $certFilePath = "$secretsFolderPath\$certificateName.cer"
    $pfxFilePath = "$secretsFolderPath\$certificateName.pfx"
    $thumbprintFilePath = "$secretsFolderPath\$certificateName.thumbprint.txt"

    #Check if secrets folder exists, if not, create it
    if (-not (Test-Path -Path $secretsFolderPath)) {
        New-Item -ItemType Directory -Path $secretsFolderPath -ErrorAction SilentlyContinue
    }

    #Generate a Self-signed Certificate
    $Certificate = New-SelfSignedCertificate -Subject $CertificateName -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256 -NotAfter $((Get-Date).AddYears(2)) -FriendlyName $CertificateName

    #Export the Certificate to "Documents" Folder in your computer
    Export-Certificate -Cert $Certificate -FilePath $certFilePath

    #Export the PFX File
    Export-PfxCertificate -Cert $Certificate -FilePath $pfxFilePath -Password (ConvertTo-SecureString -String $CertificatePassword -Force -AsPlainText)

    $Certificate.Thumbprint | Out-File -FilePath $thumbprintFilePath
}

# Usage example:
Create-SelfSignedCertificate -CertificateName "kth-mgmt-mfastatus-read-account-xxx"
