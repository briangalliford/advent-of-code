$data = Get-Content -Path ./2025/day03/input.txt
$sumPt1 = [Int64]$sumPt2 = 0
ForEach ($bank in ${data}) {
    $doubles = ForEach ($i in 0..(${bank}.Length -2)) {
        ForEach ($j in ($i + 1)..(${bank}.Length - 1)) {
            [Int]"$(${bank}[${i}])$(${bank}[${j}])"
        }
    }
    $largest = (${doubles} | Measure-Object -Maximum).Maximum
    $sumPt1 = ${sumPt1} + ${largest}
    $maxLength = 12
    $maxJolt = ""
    $start = 0
    For ($i = 1; $i -le ${maxLength}; $i++) {
        $remaining = ${maxLength} - $i
        $end = ${bank}.Length - ${remaining}
        $length = [Math]::Max(0, ${end} - ${start})
        $maxDigit = ${bank}.Substring(${start}, ${length}) -Split "" | Sort-Object -Descending | Select-Object -First 1
        ${maxJolt} += ${maxDigit}
        $start = ${bank}.IndexOf(${maxDigit}, ${start}) + 1
    }
    $sumPt2 = ${sumPt2} + [Int64]${maxJolt}
}
Write-Host "Part 1 solution is ${sumPt1}"
Write-Host "Part 2 solution is ${sumPt2}"