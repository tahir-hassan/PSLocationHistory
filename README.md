# PSLocationHistory

This module "replaces" the default `cd` command (`Set-Location`) in PowerShell.exe.  It provides:

* backwards and forwards navigation
* ability to list recent locations and to select one to navigate to.

# Installation

### Install from PowerShellGallery (preferred)

You will need PowerShellGet.  It is included in Windows 10 and [WMF5](http://go.microsoft.com/fwlink/?LinkId=398175). If you are using PowerShell V3 or V4, you will need to install [PowerShellGet](https://www.microsoft.com/en-us/download/details.aspx?id=49186).

After installing PowerShellGet, you can simply run `Install-Module PSLocationHistory`.

### Installing from GitHub

You can download the `PSLocationHistory` folder from this repository and copy it to one of your modules directory, using this Microsoft guide to [Installing a PowerShell Module][ms].

[ms]: https://msdn.microsoft.com/en-us/library/dd878350(v=vs.85).aspx


## Usage

### Enabling Location History

You have to run some commands, which you can put in your profile, that will enable the history features of this module.

First, import the module.  This step may not be necessary as PowerShell increasing has `$PSModuleAutoLoadingPreference` set to `$true`:

```powershell
Import-Module PSLocationHistory
```

Now enable the history features of the module:

```powershell
Enable-LocationHistory
```

### Going Backwards and Forwards

To go back to the previous directory, use the `-b` or `-Back` switch:

```powershell
cd -b
```

After going backwards, you can then go forwards.  Use the `-f` or `-Forward` switch:

```powershell
cd -f
```

### Going to a Recent Location

After using PowerShell for some time, you will want to go a directory that you visited earlier in the same session.  To go so, use the `-rl` or `-RecentLocation` switch:

```powershell
cd -rl
```

You will be presented with a list of options.  You enter the number of the path you wish to go to, and then press `<Enter>`.  If there are more options, you can press `<Enter>` (without a number), to view them.  If you wish to cancel, press `ctrl+c`.

## Licence

This project is under the MIT licence.
