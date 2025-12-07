$data = Get-Content -Path ./2025/day07/input.txt
$width = ${data}[0].Length
$height = ${data}.Count
$sCol = ${data}[0].IndexOf('S')
$waysPerCol = @{}
$waysPerCol[${sCol}] = [BigInt]1
$currentCols = [System.Collections.Generic.HashSet[Int]]::new()
[void]$currentCols.Add(${sCol})
$splitEvents = 0
For ($r = 1; $r -lt ${data}.Count; $r++) {
    $row = ${data}[${r}]
    $nextCols = [System.Collections.Generic.HashSet[Int]]::new()
    ForEach ($c in ${currentCols}) {
        If (${c} -ge 0 -and ${c} -lt ${width}) {
            $char = ${row}[${c}]
        } Else {
            $char = $null
        }
        If (${char} -eq '^') {
            ${splitEvents}++
            If (${c} - 1 -ge 0) { [void]${nextCols}.Add(${c} - 1) }
            If (${c} + 1 -lt ${width}) { [void]${nextCols}.Add(${c} + 1) }
        } Else {
            If (${c} -ge 0 -and ${c} -lt ${width}) { [void]${nextCols}.Add(${c}) }
        }
    }
    $currentCols = ${nextCols}
}
$finalBranchCount = ${currentCols}.Count
Write-Host "Day 7 Part 1 solution is ${finalBranchCount}"
For ($r = 1; $r -lt ${height}; $r++) {
    $row = ${data}[${r}]
    $nextWays = @{}
    ForEach ($kvp in ${waysPerCol}.GetEnumerator()) {
        $c = [Int]${kvp}.Key
        $ways = [BigInt]${kvp}.Value
        If (${c} -ge 0 -and ${c} -lt ${width}) {
            $char = ${row}[${c}]
        } Else {
            Continue
        }
        If (${char} -eq '^') {
            If (${c} - 1 -ge 0) {
                If (-Not ${nextWays}.ContainsKey(${c} - 1)) { ${nextWays}[${c} - 1] = [BigInt]0 }
                ${nextWays}[${c} - 1] += ${ways}
            }
            If (${c} + 1 -lt ${width}) {
                If (-Not ${nextWays}.ContainsKey(${c} + 1)) { ${nextWays}[${c} + 1] = [BigInt]0 }
                ${nextWays}[${c} + 1] += ${ways}
            }
        } Else {
            If (-Not ${nextWays}.ContainsKey(${c})) { ${nextWays}[${c}] = [BigInt]0 }
            ${nextWays}[${c}] += ${ways}
        }
    }
    $waysPerCol = ${nextWays}
}
$totalPaths = [BigInt]0
ForEach ($value in ${waysPerCol}.Values) { ${totalPaths} += ${value} }
Write-Host "Day 7 Part 2 solution is ${totalPaths}"