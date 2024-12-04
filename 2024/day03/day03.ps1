$puzzleInput = Get-Content -Path "./2024/day03/input.txt"
$totalScore = 0
$regex = [regex]"mul\([0-9]+,[0-9]+\)"
$matchArray = ${regex}.Matches(${puzzleInput}) | ForEach-Object {$_.Value}
ForEach ($match in ${matchArray}) {
    $strArray = $match.Replace("mul(","").Split(",").Replace(")","")
    $numArray = [int[]] ${strArray}
    $matchScore = ${numArray}[0] * ${numArray}[1]
    ${totalScore} += ${matchScore}
}
Write-Host "Part 1 answer is ${totalScore}"
$totalScore = 0
$enabled = $true
$regex = [regex]"mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\)"
$matchArray = ${regex}.Matches(${puzzleInput}) | ForEach-Object {$_.Value}
ForEach ($match in ${matchArray}) {
    If (${match} -eq "do()") {
        $enabled = $true
    } ElseIf (${match} -eq "don't()") {
        $enabled = $false
    }
    If (${enabled} -And (${match} -ne "do()" -And ${match} -ne "don't()")) {
        $strArray = $match.Replace("mul(","").Split(",").Replace(")","")
        $numArray = [int[]] ${strArray}
        $matchScore = ${numArray}[0] * ${numArray}[1]
        ${totalScore} += ${matchScore}
    }
}
Write-Host "Part 2 answer is ${totalScore}"