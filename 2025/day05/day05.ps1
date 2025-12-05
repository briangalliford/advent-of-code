function Merge-Ranges {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)][Object]$rangesInput,
        [Switch]$mergeRanges
    )
    Begin {
        $ranges = New-Object System.Collections.Generic.List[Object]
    } Process {
        If (${rangesInput} -Is [string]) {
            If (${rangesInput} -Match '^\s*$') {
                Return
            }
            $start, $end = ${rangesInput} -Split '\s*-\s*'
            ${ranges}.Add([PSCustomObject]@{ Start = [int64]${start}; End = [int64]${end} })
        } ElseIf (${rangesInput}.PSObject.Properties.Name -Contains 'Start' -And ${rangesInput}.PSObject.Properties.Name -Contains 'End') {
            ${ranges}.Add([PSCustomObject]@{ Start = [Int64]${rangesInput}.Start; End = [Int64]${rangesInput}.End })
        }
    } End {
        If (${ranges}.Count -eq 0) {
            Return @()
        }
        $sorted = ${ranges} | Sort-Object Start, End
        $merged = New-Object System.Collections.Generic.List[Object]
        $currentRange = [PSCustomObject]@{ Start = ${sorted}[0].Start; End = ${sorted}[0].End }
        $delta = If (${mergeRanges}) { 1 } Else { 0 }
        For ($i = 1; $i -lt ${sorted}.Count; $i++) {
            $nextRange = ${sorted}[${i}]
            If (${nextRange}.Start -le (${currentRange}.End + ${delta})) {
                If (${nextRange}.End -gt ${currentRange}.End) {
                    ${currentRange}.End = ${nextRange}.End
                }
            } Else {
                ${merged}.Add(${currentRange})
                $currentRange = [PSCustomObject]@{ Start = ${nextRange}.Start; End = ${nextRange}.End }
            }
        }
        ${merged}.Add(${currentRange})
        ${merged}
    }
}
function Test-ValInRanges {
    param (
        [Parameter(Mandatory)][int64]$value,
        [Parameter(Mandatory)][Object[]]$intervals
    )
    ForEach ($interval in ${intervals}) {
        If (${value} -ge ${interval}.Start -And ${value} -le ${interval}.End) {
            Return $true
        }
        If (${value} -lt ${interval}.Start) {
            Break
        }
    }
    Return $false
}
$data = Get-Content -Path ./2025/day05/input.txt
$blankIndex = (${data} | ForEach-Object -Begin {
    $i = 0
} -Process {
    If ($_ -Match '^\s*$') {
        ${i}
    } Else {
        ${i}++
        $null
    }
} | Select-Object -First 1)
$ranges = ${data}[0..(${blankIndex} - 1)]
$idsToCheck = ${data}[(${blankIndex} + 1)..(${data}.Count - 1)]
$mergedRanges = ${ranges} | Merge-Ranges -mergeRanges:$true
$sumPt1 = 0
ForEach ($id in ${idsToCheck}) {
    If (Test-ValInRanges -Value ${id} -Intervals ${mergedRanges}) {
        $sumPt1 = ${sumPt1} + 1
    }
}
$lengths = ${mergedRanges} | ForEach-Object { $_.End - $_.Start + 1 }
$pt2Count = (${lengths} | Measure-Object -Sum).Sum
Write-Host "Day 5 Part 1 solution is ${sumPt1}"
Write-Host "Day 5 Part 2 solution is ${pt2Count}"