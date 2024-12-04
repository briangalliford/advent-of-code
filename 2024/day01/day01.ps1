$puzzleInput = Get-Content -Path "./2024/day01/input.txt"
$list1=$list2=@()
ForEach ($line in ${puzzleInput}) {
    $list1 += ${line}.Split("   ")[0]
    $list2 += ${line}.Split("   ")[1]
}
$list1 = ${list1} | Sort-Object
$list2 = ${list2} | Sort-Object
$sum1 = 0
For ($i=0; $i -le 999; $i++) {
    $sum1 += [Math]::Abs($list1[$i] - $list2[$i])
}
$sum2 = 0
Write-Host "Part 1 answer is ${sum1}"
ForEach ($value in ${list1}) {
    $count = (${list2} | Where-Object {$_ -eq ${value}}).Count
    If ($count -gt 0) {
        $sum2 += ([int]$value * [int]$count)
    }
}
Write-Host "Part 2 answer is ${sum2}"