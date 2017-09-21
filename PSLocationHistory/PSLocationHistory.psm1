Set-StrictMode -Version Latest

$script:IsEnabled = $false;

# Event Handler lists
$script:LocationChangedEventHandlers = New-Object System.Collections.ArrayList

Function DirectoryIsNonTrivial {
	param([string]$Path) 
	
    return ($Path -notmatch '^[a-z]:\\$');
}

Function Get-RecentLocation {
    $script:RecentLocations;
}

Function Update-RecentLocation {
    param([string]$Path)

    if (DirectoryIsNonTrivial $Path) {
        $script:RecentLocations[$Path] = $script:RecentLocations[$Path] + 1;
    }
}

Function Add-LocationToHistoryStack {
    param([string]$Path) 
    		
	if ($script:LocationHistoryPointer -eq ($script:LocationHistory.Count - 1)) {
		$script:LocationHistoryPointer += 1;
		$script:LocationHistory.Add($Path) | Out-Null
	} else {
		$script:LocationHistory.RemoveRange($script:LocationHistoryPointer + 1, $script:LocationHistory.Count - 1 - $script:LocationHistoryPointer)
		$script:LocationHistoryPointer = $script:LocationHistory.Count; # 
		$script:LocationHistory.Add($Path) | Out-Null
	}
}

Function Enter-RecentLocation {
    $DATA_SIZE = 100;

    $data = 
            @($script:RecentLocations.Keys | 
            sort { $script:RecentLocations[$_] } -Descending | 
            Select -First ($DATA_SIZE + 1) | 
            ? { $_ -ne (Get-Location).ProviderPath } | 
            Select -First $DATA_SIZE);
		
	if (-not $data) {
		Write-Host "No Recent Locations";
	} else {
        $PAGE_SIZE = 10;

        $totalPages = [int][Math]::Ceiling($data.Count / $PAGE_SIZE);

        $indexedData = @();

        for ($pageNumber = 1; $pageNumber -le $totalPages; $pageNumber++) {
            $startIndex = ($pageNumber - 1) * $PAGE_SIZE;

            $endIndex = & {
                $offset = 
                    if ($pageNumber -lt $totalPages) {
                        $PAGE_SIZE;
                    } else {
                        $data.Count % $PAGE_SIZE;
                    };

                return $startIndex + $offset - 1;
            }

            $pageData = $data[$startIndex..$endIndex] | sort { $_ };

            $userStartIndex = $startIndex + 1;
            $userEndIndex = $endIndex + 1;

            $indexedPage =  $pageData | % { $i = $userStartIndex; } { [pscustomobject]@{ Index = $i; Path = $_; }; $i++; };

            $indexedData += $indexedPage;

            $indexedPage | Format-Table -Wrap | Out-String | Write-Host -NoNewLine

            $userMessage = "Enter index of path (ctrl+c to cancel$(if ($pageNumber -ne $totalPages) { ", <Enter> for more" }))";

            $inputStr = Read-Host $userMessage;

            $selection = & {
			    if ($inputStr -match '^\d+$') {
				    $inputInt = [int]$inputStr;
				    if (($inputInt -ge 1) -and ($inputInt -le $userEndIndex)) { 
					    return $inputInt;
				    }
			    }
				
			    return $null;
		    }

            if ($selection -is [int]) {
			    Set-LocationWithHistory ($indexedData | Where-Object { $_.Index -eq $selection }).Path
                return;
		    } elseif ($inputStr) {
                Write-Host "Invalid selection" -ForegroundColor Red;
                return;
		    }
        }
	}
}

Function Go-Forward {
    if (($script:LocationHistoryPointer -eq 0 -and ($script:LocationHistory.Count -eq 0)) -or ($script:LocationHistoryPointer -eq ($script:LocationHistory.Count - 1))) {
		Write-Host 'No "Forward" location';
	} else {
		$script:LocationHistoryPointer = $script:LocationHistoryPointer + 1;
		Set-Location $script:LocationHistory[$script:LocationHistoryPointer];
	}
}

Function Go-Back {
    if ($script:LocationHistoryPointer -eq 0) {
		Write-Host 'No "Back" location';
	} else {
		$script:LocationHistoryPointer = $script:LocationHistoryPointer - 1;
		Set-Location $script:LocationHistory[$script:LocationHistoryPointer];
	}
}

Function Set-LocationWithHistory {
	[CmdletBinding()] 
	[OutputType()] 
	param (
		[string]$Path,
        [string]$Path0,
        [string]$Path1,
        [string]$Path2,
        [string]$Path3,
        [string]$Path4,
        [string]$Path5,
        [string]$Path6,
        [string]$Path7,
        [string]$Path8,
        [string]$Path9,
		[switch][Alias("b")]$Back,
		[switch][Alias("f")]$Forward,
		[switch][Alias("rl")]$RecentLocation 
        # later implement [switch][Alias("fl")]$FrequentLocation 
	)

    $Path = ($Path, $Path0, $Path1, $Path2, $Path3, $Path4, $Path5, $Path6, $Path7, $Path8, $Path9 | ? { -not [string]::IsNullOrWhiteSpace($_) }) -join " ";

	if ($Path) {
		if (-not (Test-Path $Path)) {
			"'$Path' does not exist", "" | Write-Host  -ForegroundColor Red
		} else {
			Set-Location $Path
            $newLocation = (Get-Location).ProviderPath;
            
            Add-LocationToHistoryStack $newLocation;
            $script:LocationChangedEventHandlers | ForEach-Object { & $_ $newLocation; }
		}
	} elseif ($Back) {
		Go-Back
	} elseif ($Forward) {
		Go-Forward
	} elseif ($RecentLocation) {
		Enter-RecentLocation
	}
}

Function Set-LocationWithHistoryPrompt() {    
    Update-RecentLocation (Get-Location).ProviderPath;
    __prompt;
}

Function Enable-LocationHistory {
    if ($script:IsEnabled) {
        Write-Host "LocationHistory is already enabled";
    } else {
		$script:LocationHistory = [System.Collections.ArrayList]@();
		$script:LocationHistory.Add((Get-Location).ProviderPath) | Out-Null;
		$script:LocationHistoryPointer = 0;
		$script:RecentLocations = New-Object 'System.Collections.Generic.Dictionary[string,int]'
		
        Rename-Item function:\prompt global:__prompt;
        Rename-Item function:\Set-LocationWithHistoryPrompt global:prompt;
        Set-Alias -Name __cd -Value (Get-Alias cd).Definition -Scope Global -Option AllScope;
        Set-Alias -Name cd -Value Set-LocationWithHistory -Scope Global -Option AllScope;
        $script:IsEnabled = $true;
    }
}

Function Disable-LocationHistory {
    Remove-Item Function:\prompt
    Rename-Item function:\__prompt global:prompt;
    Set-Alias -Name cd -Value (Get-Alias __cd).Definition -Scope Global -Option AllScope;
    Get-Item Alias:\__cd | Remove-Item -Force
    $script:IsEnabled = $false;
}

# following this naming convention
# https://stackoverflow.com/a/980364/288393
# https://en.oxforddictionaries.com/spelling/verb-tenses-adding-ed-and-ing
# <EventName> ::= <NounPhrase><VerbForm> 
# <VerbForm> ::= <VerbPresentParticle> | <VerbPastTense>
Function Add-PSLocationHistoryEventHandler {
    param($LocationChanged)

    if ($LocationChanged) {
        if ($LocationChanged -is [scriptblock]) {
            # handle scriptblocks for now
            $script:LocationChangedEventHandlers.Add($LocationChanged)
        }
    }
}

# Function Set-PSLocationHistoryOption {
#    param([bool]$ShowChildren)
# }

<#
Function ShortenLongString {
    param([string]$Str, [int]$MaxLength)

    if ($Str -le $MaxLength) { return $Str; }

    $splitPos = 10;

    return $Str.Substring(0, $MaxLength - $splitPos - 3) + "..." + $Str.Substring($Str.Length - $splitPos, $splitPos);
}

$terms = Get-ChildItem | ForEach-Object Name

$minColumnWidth = ($terms | % Length | measure -Maximum).Maximum  + 2
$numColumns = [Math]::Max(1, [int][Math]::Floor( [Console]::BufferWidth / $minColumnWidth))

if ($numColumns -eq 1) {
    $terms | % { ShortenLongString $_ } | Write-Host
} else {
    $numRows = ( $terms.Length + $numColumns - 1 ) / $numColumns;

    $colSize = [int][Math]::Floor([Console]::BufferWidth / $numColumns);
    
    (0..($numRows - 1)) | % {
        $rowNum = $_;

        $start = $rowNum * $numColumns;
        $end = $start + $numColumns - 1;

        $lineTerms = $terms[$start..$end]; 
        $printableTerms = $lineTerms | % { $_.PadRight($colSize, ' ') }
        Write-Host ($printableTerms -join '')
    }
}

#>