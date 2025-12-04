$data = Get-Content -Path ./2025/day01/input.txt
$start = 50
$zeroCount = $zeroCountPt2 = 0
ForEach ($inst in ${data}) {
    $zeroPasses = 0
    $direction = ${inst}.Substring(0,1)
    $count = [int]${inst}.Substring(1)
    If (${count}.ToString().Length -gt 2) {
        $zeroPasses = [int]${count}.ToString().Substring(0,1)
        $count = [int]${count}.ToString().Substring(1)
    }
    If (${direction} -eq "L") {
        $count = ${count} * -1
    }
    $end = ${start} + ${count}
    If (${end} -lt 0) {
        $end = 100 - [Math]::Abs(${end})
        If (${start} -ne 0) {
            $zeroPasses = ${zeroPasses} + 1
        }
    } ElseIf (${end} -gt 99) {
        $end = ${end} - 100
        If (${end} -ne 0) {
            $zeroPasses = ${zeroPasses} + 1
        }
    }
    If (${end} -eq 0) {
        $zeroCount = ${zeroCount} + 1
        $zeroCountPt2 = ${zeroCountPt2} + 1
    }
    $zeroCountPt2 = ${zeroCountPt2} + ${zeroPasses}
    $start = ${end}
}
Write-Host "Day 1 Part 1 solution is ${zeroCount}"
Write-Host "Day 1 Part 2 solution is ${zeroCountPt2}"