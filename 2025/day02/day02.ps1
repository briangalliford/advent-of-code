$data = Get-Content -Path ./2025/day02/input.txt
$ranges = ${data}.Split(",")
$idsList = ForEach ($range in ${ranges}) {
    $ids = ${range}.Split("-")
    [Int64]$start = ${ids}[0]
    [Int64]$end = ${ids}[1]
    0..(${end} - ${start}) | ForEach-Object {
        ${start} + $_
    }
}
$part1 = (${idsList} | Where-Object { $_ -Match '^([0-9]+)\1$' } | Measure-Object -Sum).Sum
$part2 = (${idsList} | Where-Object { $_ -Match '^([0-9]+)\1+$' } | Measure-Object -Sum).Sum
Write-Host "Day 2 Part 1 solution is ${part1}"
Write-Host "Day 2 Part 2 solution is ${part2}"