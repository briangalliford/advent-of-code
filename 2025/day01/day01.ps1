$data = Get-Content -Path ~/advent-of-code/2025/day01/input.txt
$start = 50
$zeroCountPt1 = $zeroCountPt2 = 0
ForEach ($inst in ${data}) {
    $zeroPasses = 0
    $direction = ${inst}.Substring(0,1)
    If (${inst}.Length -gt 2) {
        If (${inst}.Length -gt 3) {
            $zeroPasses = [int]${inst}.Substring(1,1)
        }
        $count = [int]${inst}.Substring(${inst}.Length - 2)
    } Else {
        $count = [int]${inst}.Substring(1)
    }
    If ($direction -eq "L") {
        $end = ${start} - ${count}
        If (${end} -lt 0) {
            If (${start} -ne 0) {
                $zeroPasses = ${zeroPasses} + 1
            }
            $end = 100 - [Math]::Abs(${end})
        }
    } Else {
        $end = ${start} + ${count}
        If (${end} -gt 99) {
            $end = ${end} - 100
            If (${end} -ne 0) {
                $zeroPasses = ${zeroPasses} + 1
            }
        }
    }
    If (${end} -eq 0) {
        $zeroCountPt1 = ${zeroCountPt1} + 1
        $zeroCountPt2 = ${zeroCountPt2} + 1
    }
    $zeroCountPt2 = ${zeroCountPt2} + ${zeroPasses}
    $start = ${end}
}
Write-Host "Part 1 solution is ${zeroCountPt1}"
Write-Host "Part 2 solution is ${zeroCountPt2}"
