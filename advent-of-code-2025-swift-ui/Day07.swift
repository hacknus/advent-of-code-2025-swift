//
//  Day07.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

func scan_up(x: Int, y: Int, beamsplitters: [(Int,Int)], xmax: Int, ymax: Int, start: (Int,Int)) -> Bool {
    for y_i in (0..<y).reversed() {
        if beamsplitters.contains(where: {$0 == (x, y_i)}) {
            return false
        } else if x > 0 && beamsplitters.contains(where: {$0 == (x - 1, y_i)}) {
            return true
        } else if x < xmax - 1 && beamsplitters.contains(where: {$0 == (x + 1, y_i)}) {
            return true
        } else if (x, y_i) ==  start {
            return true
        }
    }
    return false
}

func walk_down(position: Position, beamsplitters: [Position], xmax: Int, ymax: Int, states: inout [ Position : Int ] ) -> Int {
    var counter = 0
    let x = position.x
    let y = position.y
    var checked_left = false
    var checked_right = false
    if let state = states[position] {
        return state
    }
    for y_i  in y..<ymax {
        if beamsplitters.contains(Position(x: x, y: y_i)) {
            if x > 0 && !checked_left {
                checked_left = true
                counter += walk_down(position: Position(x: x - 1, y: y_i), beamsplitters: beamsplitters, xmax: xmax, ymax: ymax, states: &states)
            }
            
            if x < xmax - 1 && !checked_right {
                checked_right = true
                counter += walk_down(position: Position(x: x + 1, y: y_i), beamsplitters: beamsplitters, xmax: xmax, ymax: ymax, states: &states)
            }
        }
        
        if y_i == ymax - 1 && !checked_right && !checked_left {
            counter = 1
        }
    }
    
    states[position] = counter
    return counter
    
}

struct Position: Hashable {
 var x : Int
 var y : Int
}

class Day07 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var beamsplitters : [(Int,Int)] = []
        var start : (Int,Int) = (0,0)
        for (y, line) in lines.enumerated()  {
            for (x, c) in line.enumerated() {
                if c == "^" {
                    beamsplitters.append((x,y))
                }
                if c == "S" {
                    start = (x,y)
                }
            }
        }
        
        var counter = 0
        
        for beamsplitter in beamsplitters {
            let (x,y) = beamsplitter
            if scan_up(x: x, y: y, beamsplitters: beamsplitters, xmax: lines[0].count, ymax: lines.count, start: start) {
                counter += 1
            }
        }
        
        return "\(counter)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var beamsplitters : [Position] = []
        var start : Position = Position(x: 0, y: 0)
        for (y, line) in lines.enumerated()  {
            for (x, c) in line.enumerated() {
                if c == "^" {
                    beamsplitters.append(Position(x: x, y: y))
                }
                if c == "S" {
                    start = Position(x: x, y: y)
                }
            }
        }
        
        var states: [ Position : Int ] = [:]
        
        let counter = walk_down(position: start, beamsplitters: beamsplitters, xmax: lines[0].count, ymax: lines.count, states: &states)
        
       return "\(counter)"
    }
}
