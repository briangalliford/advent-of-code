$puzzleInput = Get-Content -Path "./2024/day02/input.txt"
$safeCount = $dampenerCount = 0
ForEach ($report in ${puzzleInput}) {
    $reportString = ${report}.Split(" ")
    $report = [int[]] ${reportString}
    $sortedAsc = ${report} | Sort-Object
    $sortedDesc = ${report} | Sort-Object -Descending
    $sortedAscString = (${sortedAsc} | ForEach-Object {$_.ToString()}) -Join ","
    $sortedDescString = (${sortedDesc} | ForEach-Object {$_.ToString()}) -Join ","
    $reportStringJoin = ${reportString} -Join ","
    $safe = $true
    If (${sortedAscString} -eq ${reportStringJoin} -Or ${sortedDescString} -eq ${reportStringJoin}) {
        For ($i=0; $i -le (${report}.Length - 2); $i++) {
            $diff = [Math]::Abs(${report}[$i] - ${report}[$i+1])
            If (${diff} -eq 0 -Or ${diff} -ge 4) {
                $safe = $false
                Break
            }
        }
    } Else {
        $safe = $false
    }
    If (${safe}) {
        ${safeCount} += 1
    } Else {
        $recheckSum = 0
        For ($i=0; $i -lt ${report}.Length; $i++) {
            $arrayList = [System.Collections.ArrayList]${report}
            ${arrayList}.RemoveAt(${i})
            $newReport = [int[]] ${arrayList}
            $sortedAsc = ${newReport} | Sort-Object
            $sortedDesc = ${newReport} | Sort-Object -Descending
            $sortedAscString = (${sortedAsc} | ForEach-Object {$_.ToString()}) -Join ","
            $sortedDescString = (${sortedDesc} | ForEach-Object {$_.ToString()}) -Join ","
            $reportStringJoin = (${newReport} | ForEach-Object {$_.ToString()}) -Join ","
            $safeRecheck = $true
            If (${sortedAscString} -eq ${reportStringJoin} -Or ${sortedDescString} -eq ${reportStringJoin}) {
                For ($j=0; $j -le (${newReport}.Length - 2); $j++) {
                    $diff = [Math]::Abs(${newReport}[$j] - ${newReport}[$j+1])
                    If (${diff} -eq 0 -Or ${diff} -ge 4) {
                        $safeRecheck = $false
                        Break
                    }
                }
            } Else {
                $safeRecheck = $false
            }
            If (${safeRecheck} -eq $false) {
                $recheckSum += 1
            }
        }
        If (${recheckSum} -lt ${report}.Length) {
            ${dampenerCount} += 1
        }
    }
}
Write-Host "Part 1 answer is ${safeCount}"
Write-Host "Part 2 answer adds ${dampenerCount} for a total of" (${safeCount} + ${dampenerCount})