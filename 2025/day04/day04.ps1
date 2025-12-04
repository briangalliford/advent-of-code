$data = Get-Content ./2025/day04/input.txt
$rows = ${data}.Count
$cols = ${data}[0].Length
$pt1Sol = $pt2Sol = $loop = 0
$changed = $true
While (${changed}) {
    $changed = $false
    $loop = ${loop} + 1
    $toReplace = @()
    For ($row = 0; $row -lt ${rows}; $row++) {
        For ($col = 0; $col -lt ${cols}; $col++) {
            If (${data}[${row}][${col}] -eq "@") {
                $count = 0
                ForEach ($deltaRow in -1..1) {
                    ForEach ($deltaCol in -1..1) {
                        If (${deltaRow} -eq 0 -And ${deltaCol} -eq 0) { 
                            Continue
                        }
                        $neighborRow = ${row} + ${deltaRow}
                        $neighborCol = ${col} + ${deltaCol}
                        If (${neighborRow} -ge 0 -And ${neighborRow} -lt ${rows} -And ${neighborCol} -ge 0 -And ${neighborCol} -lt ${cols}) {
                            If (${data}[${neighborRow}][${neighborCol}] -eq "@") {
                                ${count}++
                            }
                        }
                    }
                }
                If (${count} -lt 4) {
                    If (${loop} -eq 1) {
                        $pt1Sol = ${pt1Sol} + 1
                    }
                    $pt2Sol = ${pt2Sol} + 1
                    $toReplace += [PSCustomObject]@{ Row = ${row}; Col = ${col} }
                }
            }
        }
    }
    If (${toReplace}.Count -gt 0) {
        ForEach ($point in ${toReplace}) {
            $rowChars = ${data}[${point}.Row].ToCharArray()
            $rowChars[${point}.Col] = "x"
            ${data}[${point}.Row] = -Join ${rowChars}
        }
        $changed = $true
    }
}
Write-Host "Day 4 Part 1 solution is ${pt1Sol}"
Write-Host "Day 4 Part 2 solution is ${pt2Sol}"