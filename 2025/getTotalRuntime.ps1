$totalSeconds = `
    (Measure-Command {./2025/day01/day01.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day02/day02.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day03/day03.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day04/day04.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day05/day05.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day06/day06.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day07/day07.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day08/day08.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day09/day09.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day10/day10.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day11/day11.ps1}).TotalSeconds + `
    (Measure-Command {./2025/day12/day12.ps1}).TotalSeconds
$totalSeconds = [Math]::Round(${totalSeconds},2)
Write-Host "Total runtime ${totalSeconds} seconds"