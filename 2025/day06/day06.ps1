$data = Get-Content -Path ./2025/day06/input.txt
$grid = ${data} | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
$numericLines = @()
$opsLine = $null
ForEach ($line in ${grid}) {
    If (${line} -Match '^[\d\s]+$') {
        $numericLines += ${line}
    } Else {
        $opsLine = ${line}
    }
}
$numbers2D = @()
ForEach ($line in ${numericLines}) {
    $row = (${line} -Split '\s+') | ForEach-Object { [Int]$_ }
    $numbers2D += ,@(${row})
}
$opsArray = (${opsLine} -Replace '\s+', '') -Split '' | Where-Object { $_.Trim('') -ne ''}
function Mathematize {
    param (
        [Parameter(Mandatory=$true)][char]$operator,
        [Parameter(Mandatory=$true)][double]$x,
        [Parameter(Mandatory=$true)][double]$y
    )
    Switch (${operator}) {
        '+' { return (${x} + ${y}) }
        '*' { return (${x} * ${y}) }
    }
}
$rows = ${numbers2D}.Count
If (${rows} -lt 1) { 
    Throw "No numeric rows found."
}
$cols = ${numbers2D}[0].Count
If (${opsArray}.Count -ne ${cols}) { 
    Throw "Operator count ($(${opsArray}.Count)) must equal column count (${cols})."
}
$mathValues = @()
For ($j = 0; $j -lt ${cols}; $j++) {
    $operator = $opsArray[$j]
    $runningTotal = [double]${numbers2D}[0][${j}]
    For ($i = 1; $i -lt ${rows}; $i++) {
        $runningTotal = Mathematize -operator ${operator} -x ${runningTotal} -y ([double]${numbers2D}[${i}][${j}])
    }
    ${mathValues} += ${runningTotal}
}
$pt1Sol = (${mathValues} | Measure-Object -Sum).Sum
Write-Host "Day 6 Part 1 solution is ${pt1Sol}"
$rawNumerics = ${data} | Where-Object { $_ -Match '^[\d\s]+$' }
$rowsTokens = @()
ForEach ($line in ${rawNumerics}) {
    $matches1 = [Regex]::Matches(${line}, '\S+')
    $tokens = ForEach ($match in ${matches1}) {
        [PSCustomObject]@{
            Value = ${match}.Value
            Start = ${match}.Index
            End = ${match}.Index + ${match}.Length - 1
            Length = ${match}.Length
        }
    }
    $rowsTokens += ,@(${tokens})
}
$rows = ${rowsTokens}.Count
$cols = (${rowsTokens} | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum
For ($row=0; $row -lt ${rows}; ${row}++) {
    If (${rowsTokens}[${row}].Count -ne ${cols}) {
        Throw "Row ${row} has $(${rowsTokens}[${row}].Count) tokens; expected ${cols}. Check input alignment."
    }
}
$columns = @()
For ($j=0; $j -lt ${cols}; $j++) {
    $col = @()
    For ($row = 0; $row -lt ${rows}; $row++) {
        ${col} += ${rowsTokens}[${row}][${j}]
    }
    ${columns} += ,@(${col})
}
function Get-Alignment {
    param([double[]]$xs)
    If (${xs}.Count -le 1) { Return 0.0 }
    $mean = (${xs} | Measure-Object -Average).Average
    $sum = 0.0
    ForEach ($x in ${xs}) {
        ${sum} += [Math]::Pow((${x} - ${mean}), 2) }
    Return ${sum} / ${xs}.Count
}
$columnDescriptors = @()
For ($j=0; $j -lt ${cols}; $j++) {
    $starts = ${columns}[${j}] | ForEach-Object { [Double]$_.Start }
    $ends = ${columns}[${j}] | ForEach-Object { [Double]$_.End }
    $varStart = Get-Alignment ${starts}
    $varEnd = Get-Alignment ${ends}
    $alignment = If (${varStart} -le ${varEnd}) { 'Left' } Else { 'Right' }
    $width = (${columns}[${j}] | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    $columnDescriptors += [PSCustomObject]@{
        Index = ${j}
        Alignment = ${alignment}
        Width = ${width}
        Tokens = (${columns}[${j}] | ForEach-Object { $_.Value })
    }
}
function Get-ReadsByColumn {
    param (
        [Parameter(Mandatory=$true)][string[]]$columnValues,
        [Parameter(Mandatory=$true)][ValidateSet('Left','Right')][string]$alignment,
        [Parameter(Mandatory=$true)][int] $width
    )
    $padded = Switch (${alignment}) {
        'Left' { ${columnValues} | ForEach-Object { $_.PadRight(${width}, ' ') } }
        'Right' { ${columnValues} | ForEach-Object { $_.PadLeft(${width},  ' ') } }
    }
    $reads = @()
    For ($k = ${width} - 1; $k -ge 0; $k--) {
        $chars = For ($row = 0; $row -lt ${padded}.Count; $row++) { ${padded}[${row}][${k}] }
        $digits = (-Join ${chars}) -replace '\s+', ''
        If (${digits} -ne '') { ${reads} += ${digits} }
    }
    return $reads
}
$allReads = @()
ForEach ($desc in ${columnDescriptors}) {
    $reads = Get-ReadsByColumn -columnValues ${desc}.Tokens -alignment ${desc}.Alignment -width ${desc}.Width
    $allReads += [PSCustomObject]@{
        Column = ${desc}.Index
        Alignment = ${desc}.Alignment
        Reads = ${reads}
    }
}
$mathValues = @()
ForEach ($read in ${allReads}) {
    $operator = ${opsArray}[${read}.Column]
    $runningTotal = [Double]${read}.Reads[0]
    For ($j = 1; $j -le ${read}.Reads.Count - 1; $j++) {
        $runningTotal = Mathematize -operator ${operator} -x ${runningTotal} -y ([Double]${read}.Reads[${j}])
    }
    ${mathValues} += ${runningTotal}
}
$pt2Sol = (${mathValues} | Measure-Object -Sum).Sum
Write-Host "Day 6 Part 1 solution is ${pt2Sol}"