<#
===========================================================================
        Author - Roi Rogers
        This script creates an Answer File for windows server 2022 and places it in a ISO file

        * Script must be run as Administrator!
        * Script creates xml that supports x64 cpu architecture exclusivly, in order to adapt the xml for different architecture
          Replace all values named 'amd64' with arm, arm64, x86 depending on desired architecture
        * In order for script to run correctly you must have Windows ADK installed on your workstation
          You may download Windows ADK from the following link:
          https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install

        Disclaimer - Use this script at your own risk; the author is not responsible for any damage to your system. 

        version 1 - requires better error handling, next version will include it


25-02-18 INCEPTO NE DESISTAM
===========================================================================
#>


## parameters
$path=  "X:\Example\Path\Temp\"
$ComputerName= "AwesomePC"
$AdminPassword= "Aa123456"
$Name= "John"
$Organization= "AwesomeCorp"

## Message colors
$successColor= "Green"
$infoColor= "Yellow"
$errorColor= "Red"


## main function (XML Creator)
function CreateXML {
    param (
            #[parameter(Mandatory='true')]
            # [string]
            #$ComputerName,
            #[parameter(Mandatory='true')]
            #[string]
            #$Name,
            #[parameter(Mandatory='true')]
            #[string]
            #$AdminPassword,
            #[parameter(Mandatory='true')]
            #[string]
            #$Path,
            #[parameter]
            #[string]
            #$Organization
    )
    
    $xmlWriter= New-Object System.Xml.XmlTextWriter("$($path)autounattend.xml", [System.Text.Encoding]::UTF8)

    #Properties
    $xmlWriter.Formatting= 'Indented'
    $xmlWriter.Indentation= 1
    $xmlWriter.IndentChar= "`t"

    # write the header
    $xmlWriter.WriteStartDocument()

    # create XML Elements
    $XmlWriter.WriteComment('Answer File')
    $xmlWriter.WriteStartElement('unattend')
    $XmlWriter.WriteAttributeString('xmlns', 'urn:schemas-microsoft-com:unattend')

        $xmlWriter.WriteStartElement('settings')
        $XmlWriter.WriteAttributeString('pass', 'windowsPE') 

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Setup')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')

                $xmlWriter.WriteStartElement('ImageInstall')

                    $xmlWriter.WriteStartElement('OSImage')

                        $xmlWriter.WriteStartElement('InstallFrom')

                            $xmlWriter.WriteStartElement('MetaData')
                            $XmlWriter.WriteAttributeString('wcm:action', 'add')
                            $xmlWriter.WriteElementString('Key','/IMAGE/NAME')
                            $xmlWriter.WriteElementString('Value','Windows Server 2022 SERVERSTANDARD')
                            $xmlWriter.WriteEndElement()    # MetaData

                        $xmlWriter.WriteEndElement()    # InstallFrom

                        $xmlWriter.WriteStartElement('InstallTo')
                        $xmlWriter.WriteElementString('DiskID','0')
                        $xmlWriter.WriteElementString('PartitionID','2')
                        $xmlWriter.WriteEndElement() # InstallTo

                    $xmlWriter.WriteElementString('WillShowUI','OnError')
                    $xmlWriter.WriteEndElement()    # OSImage

                $xmlWriter.WriteEndElement()    # ImageInstall

                # Disk Configuration
                $xmlWriter.WriteStartElement('DiskConfiguration')

                    $xmlWriter.WriteStartElement('Disk')
                    $XmlWriter.WriteAttributeString('wcm:action', 'add')

                        # Creates Partitions
                        $xmlWriter.WriteStartElement('CreatePartitions')

                            # Creates Partition
                            $xmlWriter.WriteStartElement('CreatePartition') #1
                            $XmlWriter.WriteAttributeString('wcm:action', 'add')
                            $xmlWriter.WriteElementString('Order','1')
                            $xmlWriter.WriteElementString('Size','350')
                            $xmlWriter.WriteElementString('Type','EFI')
                            $xmlWriter.WriteEndElement()    # CreatePartition1

                            # Creates Partition
                            $xmlWriter.WriteStartElement('CreatePartition') #2
                            $XmlWriter.WriteAttributeString('wcm:action', 'add')
                            $xmlWriter.WriteElementString('Extend','true')
                            $xmlWriter.WriteElementString('Order','2')
                            $xmlWriter.WriteElementString('Type','Primary')
                            $xmlWriter.WriteEndElement()    # CreatePartition2

                        $xmlWriter.WriteEndElement()    # CreatePartitions




                    $xmlWriter.WriteElementString('DiskID','0')                   
                    $xmlWriter.WriteElementString('WillWipeDisk','true') 

                        $xmlWriter.WriteStartElement('ModifyPartitions')  

                            $xmlWriter.WriteStartElement('ModifyPartition') #1 
                            $XmlWriter.WriteAttributeString('wcm:action', 'add')                   
                            $xmlWriter.WriteElementString('Format','FAT32')                    
                            $xmlWriter.WriteElementString('Label','System')
                            $xmlWriter.WriteElementString('Order','1')
                            $xmlWriter.WriteElementString('PartitionID','1')
                            $xmlWriter.WriteEndElement()    # ModifyPartition1

                            $xmlWriter.WriteStartElement('ModifyPartition') #2 
                            $XmlWriter.WriteAttributeString('wcm:action', 'add')                   
                            $xmlWriter.WriteElementString('Format','NTFS')                    
                            $xmlWriter.WriteElementString('Label','Windows')
                            $xmlWriter.WriteElementString('Letter','C')                    
                            $xmlWriter.WriteElementString('Order','2')
                            $xmlWriter.WriteElementString('PartitionID','2')
                            $xmlWriter.WriteEndElement()    # ModifyPartition2

                        $xmlWriter.WriteEndElement()    # ModifyPartitions

                    $xmlWriter.WriteEndElement() # Disk           

                $xmlWriter.WriteElementString('WillShowUI','OnError')
                $xmlWriter.WriteEndElement() # DiskConfiguration

                $xmlWriter.WriteStartElement('UserData')
                $xmlWriter.WriteElementString('AcceptEula','true')
                $xmlWriter.WriteElementString('FullName',$Name)
                $xmlWriter.WriteElementString('Organization',$Organization)
                $xmlWriter.WriteEndElement() # UserData

            $xmlWriter.WriteEndElement() #component
            
            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-International-Core-WinPE')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')

                $xmlWriter.WriteStartElement('SetupUILanguage')
                $xmlWriter.WriteElementString('UILanguage','en-US')
                $xmlWriter.WriteEndElement() # SetupUILanguage
            
            $xmlWriter.WriteElementString('InputLocale','en-US')
            $xmlWriter.WriteElementString('SystemLocale','en-US')
            $xmlWriter.WriteElementString('UILanguage','en-US')
            $xmlWriter.WriteElementString('UILanguageFallback','en-US')
            $xmlWriter.WriteElementString('UserLocale','en-US')

            $xmlWriter.WriteEndElement() #component

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-PnpCustomizationsWinPE')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')

                $xmlWriter.WriteStartElement('DriverPaths')

                    $xmlWriter.WriteStartElement('PathAndCredentials')
                    $XmlWriter.WriteAttributeString('wcm:action','add')
                    $XmlWriter.WriteAttributeString('wcm:keyValue','1')
                    $xmlWriter.WriteElementString('Path','A:\')
                    $xmlWriter.WriteEndElement() #PathAndCredentials

                $xmlWriter.WriteEndElement() #DriverPaths
            
            $xmlWriter.WriteEndElement() #component

        $xmlWriter.WriteEndElement() #settings

        $xmlWriter.WriteStartElement('settings')
        $XmlWriter.WriteAttributeString('pass','specialize')

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Shell-Setup')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')

                $xmlWriter.WriteStartElement('OEMInformation')
                $xmlWriter.WriteElementString('HelpCustomized','false')
                $xmlWriter.WriteEndElement() #OEMInformation

            $xmlWriter.WriteElementString('ComputerName',$ComputerName)

            $xmlWriter.WriteEndElement() #component

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Security-SPP-UX')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')
            $xmlWriter.WriteElementString('SkipAutoActivation','true')
            $xmlWriter.WriteEndElement() #component

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-ServerManager-SvrMgrNc')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')
            $xmlWriter.WriteElementString('DoNotOpenServerManagerAtLogon','true')
            $xmlWriter.WriteEndElement() #component

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-IE-ESC')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')
            $xmlWriter.WriteElementString('IEHardenAdmin','false')
            $xmlWriter.WriteElementString('IEHardenUser','false')
            $xmlWriter.WriteEndElement() #component

        $xmlWriter.WriteEndElement() #settings

        $xmlWriter.WriteStartElement('settings')
        $XmlWriter.WriteAttributeString('pass','oobeSystem')

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Shell-Setup')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')

                $xmlWriter.WriteStartElement('OOBE')
                $xmlWriter.WriteElementString('HideEULAPage','true')
                $xmlWriter.WriteElementString('HideLocalAccountScreen','true')
                $xmlWriter.WriteElementString('HideOEMRegistrationScreen','true')
                $xmlWriter.WriteElementString('HideOnlineAccountScreens','true')
                $xmlWriter.WriteElementString('HideWirelessSetupInOOBE','true')
                $xmlWriter.WriteElementString('NetworkLocation','Home')
                $xmlWriter.WriteElementString('ProtectYourPC','1')
                $xmlWriter.WriteEndElement() #OOBE

                $xmlWriter.WriteStartElement('UserAccounts')

                    $xmlWriter.WriteStartElement('AdministratorPassword')
                    $xmlWriter.WriteElementString('Value',$AdminPassword)
                    $xmlWriter.WriteElementString('PlainText','true')
                    $xmlWriter.WriteEndElement() #AdministratorPassword

                    $xmlWriter.WriteStartElement('LocalAccounts')

                        $xmlWriter.WriteStartElement('LocalAccount')
                        $xmlWriter.WriteAttributeString('wcm:action','add')

                            $xmlWriter.WriteStartElement('Password')
                            $xmlWriter.WriteElementString('Value',$AdminPassword)
                            $xmlWriter.WriteElementString('PlainText','true')
                            $xmlWriter.WriteEndElement() #Password

                        $xmlWriter.WriteElementString('Group','administrators')   
                        $xmlWriter.WriteElementString('DisplayName', $Name)
                        $xmlWriter.WriteElementString('Name',$Name)
                        $xmlWriter.WriteElementString('Description',"$name user")
                        $xmlWriter.WriteEndElement() #LocalAccount

                    $xmlWriter.WriteEndElement() #LocalAccounts

                $xmlWriter.WriteEndElement() #UserAccounts

                $xmlWriter.WriteStartElement('RegisteredOwner')
                $xmlWriter.WriteEndElement() #RegisteredOwner

            $xmlWriter.WriteEndElement() #component

        $xmlWriter.WriteEndElement() #settings

        $xmlWriter.WriteStartElement('settings')
        $XmlWriter.WriteAttributeString('pass','offlineServicing')

            $xmlWriter.WriteStartElement('component')
            $XmlWriter.WriteAttributeString('xmlns:wcm', 'http://schemas.microsoft.com/WMIConfig/2002/State')
            $XmlWriter.WriteAttributeString('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
            $XmlWriter.WriteAttributeString('name','Microsoft-Windows-LUA-Settings')
            $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
            $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
            $XmlWriter.WriteAttributeString('language','neutral')
            $XmlWriter.WriteAttributeString('versionScope','nonSxS')
            $xmlWriter.WriteElementString('EnableLUA','false')
            $xmlWriter.WriteEndElement() #component

        $xmlWriter.WriteEndElement() #settings
        
    $xmlWriter.WriteEndElement() #unattend


    # finalize the document:
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()

}

## Run Function
try {
    Write-Host "Generating XML" -ForegroundColor $infoColor
    CreateXML
    Write-Host "XML has been generated successfully" -ForegroundColor $successColor
}
catch {
    Write-Host "XML has failed to generate:`n $($Error)" -ForegroundColor $errorColor
}


## Deletes temporary directories if exist
if(Test-Path "$($path)TempForIso\"){
    Remove-Item "$($path)\TempForIso\" -Recurse -Force
}
if(Test-Path "$($path)IsoPath\"){
    Remove-Item "$($path)\IsoPath\" -Recurse -Force
}

## Make the temporary directories used for the script + copy xml
New-Item -ItemType Directory -Name "TempForIso" -Path $path
New-Item -ItemType Directory -Name "IsoPath" -Path $path
Move-Item -Path "$($path)autounattend.xml" -Destination "$($path)TempForIso" -Force

## Path to oscdimg.exe (You might need to adjust based on your Windows ADK installation)
$oscdimgPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"

## Create the ISO
try {
    Write-Host "Creating ISO" -ForegroundColor $infoColor
    & $oscdimgPath -o -u2 'G:\Roi General\Study\Powershell scripts\Temp\TempForIso\' 'G:\Roi General\Study\Powershell scripts\Temp\IsoPath\Unattended.iso'
    Write-Host "Created ISO successfully" -ForegroundColor $successColor
}
catch {
    Write-Host "Failed to create ISO:`n $($Error)" -ForegroundColor $errorColor
}
Remove-Item "$($path)TempForIso\" -Recurse





## Unfinished VHDX section instead of using ISO - Script works but scrapped because windows installation isn't loading xml from VHDX
<#

$DriveLetter= "X"

## Create VHDX, Mount
try {
    Write-Host "Creating VHDX" -ForegroundColor $infoColor
New-VHD -Path "$($path)Unattended.vhdx" -SizeBytes 10MB -Fixed
Mount-VHD -Path "$($path)Unattended.vhdx"
$disk= Get-Disk -FriendlyName "Msft Virtual Disk"
Write-Host "VHDX has been created successfully" -ForegroundColor $successColor
}
catch {
    Write-Host "Failed to create VHDX" -ForegroundColor $errorColor
}


## Initialize Disk and Insert autounattend.xml
try {
    # Initialize Disk/Create Volume
    Write-Host "Creating Volume" -ForegroundColor $infoColor
    $DriveExist = Get-Volume | Where-Object {$_.DriveLetter -eq $DriveLetter}
    if(-not $DriveExist) {
        New-Volume -DiskNumber $disk.Number -DriveLetter $DriveLetter -FileSystem NTFS -FriendlyName 'Unattended' -ErrorAction Stop
        Write-Host "Volume created successfully" -ForegroundColor $successColor
        # Insert and delete autounattend.xml
        Write-Host "Adding XML to VHDX" -ForegroundColor $infoColor
        Copy-Item -Path "$($path)autounattend.xml" -Destination "$($DriveLetter):\"
        Copy-Item -Path "$($path)bootsect.exe" -Destination "$($DriveLetter):\"
        Remove-Item -Path "$($path)autounattend.xml" -Force
        Write-Host "Added XML to VHDX successfully" -ForegroundColor $successColor
    }
    else {
        Write-Host "Volume $DriveLetter already exists please change DriveLetter paramater" -ForegroundColor $errorColor
    }
}
catch {
    Write-Host "Failed to create Volume, unexpected error" -ForegroundColor $errorColor
}

## Unmount Disk
try {
    Write-Host "Unmounting VHDX" -ForegroundColor $infoColor
    $disk = Get-Disk -FriendlyName "Msft Virtual Disk"
    Dismount-VHD -Path "$($path)Unattended.vhdx"
    Write-Host "VHDX unmounted successfully" -ForegroundColor $successColor
}
catch {
    Write-Host "Failed to unmount VHDX" -ForegroundColor $errorColor
}
#>

