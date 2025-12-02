$data = Get-Content -Path ./2025/day02/input.txt
$ranges = ${data}.Split(",")
[Int64]$sumPt1 = [Int64]$sumPt2 = 0
ForEach ($range in ${ranges}) {
    $ids = ${range}.Split("-")
    $idList = @()
    For ($i = [Int64]${ids}[0]; $i -le [Int64]${ids}[1]; $i++) {
        $idList += ${i}.ToString()
    }
    ForEach ($id in ${idList}) {
        If (${id}.Length % 2 -eq 0 -And ${id} -Match '^([0-9]+)\1$') {
            ${sumPt1} = ${sumPt1} + [Int64]${id}
        }
        If (${id} -Match '^([0-9]+)\1+$') {
            ${sumPt2} = ${sumPt2} + [Int64]${id}
        }
    }
}
Write-Host "Part 1 solution is ${sumPt1}"
Write-Host "Part 2 solution is ${sumPt2}"