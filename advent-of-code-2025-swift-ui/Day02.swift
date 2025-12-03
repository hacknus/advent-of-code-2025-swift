//
//  Day02.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

func getInvalidRanges(start: Int, end: Int) -> Array<Int> {
    var ids = Array<Int>()
    for i in start...end {
        let i_string = String(i)
        for j in i_string.indices {
            let slice = i_string[..<j]
            if slice + slice == i_string {
                ids.append(i)
                break
            }
        }
    }
    return ids
}

func getInvalidRangesAtLeast2(start: Int, end: Int) -> Array<Int> {
    var ids = Array<Int>()
    for i in start...end {
        let i_string = String(i)
        let n = i_string.count
        for j in i_string.indices {
            let slice = i_string[..<j]
            let n_i = String(slice).count
            if n_i == 0 || n / n_i < 2 { continue }
            let count = n / n_i
            var repeated = ""
            for _ in 0..<count {
                repeated += slice
            }
            if repeated == i_string {
                ids.append(i)
                break
            }
        }
    }
    return ids
}


class Day02 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename).split(separator: "\n")[0]
        let ranges = input.split(separator: ",")
        
        var sum = 0;
        
        for range in ranges {
            let bounds = range.split(separator: "-")
            let start = Int(bounds[0])!
            let end = Int(bounds[1])!
            sum += getInvalidRanges(start: start, end: end).reduce(0,+)
        }
        return String(sum)
    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename).split(separator: "\n")[0]
        let ranges = input.split(separator: ",")
        
        var sum = 0;
        
        for range in ranges {
            let bounds = range.split(separator: "-")
            let start = Int(bounds[0])!
            let end = Int(bounds[1])!
            
            sum += getInvalidRangesAtLeast2(start: start, end: end).reduce(0,+)
        }
       return "\(sum)"
    }
}
