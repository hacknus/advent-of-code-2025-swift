//
//  Day04.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//


func lookAround(_ map: [[Int]], _ pos: (Int,Int)) -> Bool {
    let directions = [
        (0, 1),
        (1, 0),
        (0, -1),
        (-1, 0),
        (1, 1),
        (1, -1),
        (-1, 1),
        (-1, -1),
    ]
    var counter = 0
    for dir in directions {
        let new_x = pos.0 + dir.0
        let new_y = pos.1 + dir.1
        if new_x >= 0, new_x < map[0].count, new_y >= 0, new_y < map.count {
            if map[new_y][new_x] == 1 {
                counter += 1
            }
        }
    }
    return counter < 4
}

class Day04 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        let width = lines.first!.count
        let height = lines.count
        var map = Array(
            repeating: Array(repeating: 0, count: width),
            count: height
        )
        
        for (y, line) in lines.enumerated() {
            for (x, c) in line.enumerated() {
                if c == "@" {
                    map[y][x] = 1
                } else {
                    map[y][x] = 0
                }
            }
        }
        
        var count = 0
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == 1 {
                    if lookAround(map, (x,y)) {
                        count += 1
                    }
                }
                
            }
        }
        
        return "\(count)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        let width = lines.first!.count
        let height = lines.count
        var map = Array(
            repeating: Array(repeating: 0, count: width),
            count: height
        )
        
        for (y, line) in lines.enumerated() {
            for (x, c) in line.enumerated() {
                if c == "@" {
                    map[y][x] = 1
                } else {
                    map[y][x] = 0
                }
            }
        }
        
        var count = 0
        var last_count = -1
        while true {
            var new_map = map
            for y in 0..<map.count {
                for x in 0..<map[y].count {
                    if map[y][x] == 1 {
                        if lookAround(map, (x,y)) {
                            new_map[y][x] = 0
                            count += 1
                        }
                    }
                    
                }
            }
            map = new_map
            if last_count == count {
                break;
            }
            last_count = count
        }
        
        return "\(count)"
    }
}
