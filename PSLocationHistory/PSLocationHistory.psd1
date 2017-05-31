#
# Module manifest for module 'PSLocationHistory'
#
# Generated by: th203
#
# Generated on: 30/05/2017
#

@{

# These modules will be processed when the module manifest is loaded.

# Script module or binary module file associated with this manifest.
RootModule = 'PSLocationHistory.psm1'

# Version number of this module.
ModuleVersion = '1.24'

# ID used to uniquely identify this module
GUID = 'ee040c5e-525a-4bac-9615-be612f662f87'

# Author of this module
Author = 'Tahir Hassan'

# Company or vendor of this module
CompanyName = 'Tahir Hassan'

# Copyright statement for this module
Copyright = '(c) 2017 Tahir Hassan. MIT License.'

# Description of the functionality provided by this module
Description = 'A module that provides location history.  It replaces the `cd` command to provide backwards and forwards navigation and ability to list and select a recently visited location.

Check the GitHub repository https://github.com/tahir-hassan/PSLocationHistory for more information.
'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Enable-LocationHistory','Disable-LocationHistory','Enter-RecentLocation','Set-LocationWithHistory','Get-RecentLocation'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
	'PSLocationHistory.psd1', 'PSLocationHistory.psm1'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/tahir-hassan/PSLocationHistory'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

