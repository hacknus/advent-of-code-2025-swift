//
//  Day08.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

import Foundation

class Box {
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    func distance(other: Box) -> Int {
        let x = pow(Double(self.x - other.x), 2)
        let y = pow(Double(self.y - other.y), 2)
        let z = pow(Double(self.z - other.z), 2)
        return Int((x + y + z).squareRoot())
    }
}



class Day08 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        let n_to_connect = 1000;
        var boxes: [Box] = []
        
        for line in lines {
            let pos = line.split(separator: ",").map { Int($0)! }
            let b = Box(x: pos[0], y: pos[1], z: pos[2])
            boxes.append(b)
        }
        
        var distances :[(Int, (Int, Int))] = []
        for i in 0..<boxes.count {
            for j in (i + 1)..<boxes.count {
                let dist = boxes[i].distance(other: boxes[j])
                distances.append((dist, (i, j)))
            }
        }
        
        distances.sort(by:  {$0.0 < $1.0})
        
        var circuits : [Set<Int>] = []
        
        for k in 0..<n_to_connect {
            let (d, (i, j)) = distances[k]
            
            var solo = true
            
            for idx in 0..<circuits.count {
                if circuits[idx].contains(i) {
                    circuits[idx].insert(j)
                    solo = false
                }
            }
            
            for idx in 0..<circuits.count {
                if circuits[idx].contains(j) {
                    circuits[idx].insert(i)
                    solo = false
                }
            }
            
            if solo {
                var new_circuit : Set<Int> = []
                new_circuit.insert(i)
                new_circuit.insert(j)
                circuits.append(new_circuit)
            }
            
            // merge
            var to_merge: [Int] = [];
            for index in 0..<circuits.count {
                if circuits[index].contains(i) || circuits[index].contains(j) {
                    to_merge.append(index);
                }
            }
            if to_merge.count > 1 {
                var new_circuit : Set<Int> = [];
                for index in to_merge.reversed() {
                    let circuit = circuits.remove(at: index);
                    for box_index in circuit {
                        new_circuit.insert(box_index);
                    }
                }
                circuits.append(new_circuit);
            }
        }
        
        circuits.sort(by: {$0.count < $1.count})
        circuits.reverse()
        
        var prod = 1
        for i in 0..<3 {
            prod *= circuits[i].count
        }
        
        return "\(prod)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        let n_to_connect = 1000;
        var boxes: [Box] = []
        
        for line in lines {
            let pos = line.split(separator: ",").map { Int($0)! }
            let b = Box(x: pos[0], y: pos[1], z: pos[2])
            boxes.append(b)
        }
        
        var distances :[(Int, (Int, Int))] = []
        for i in 0..<boxes.count {
            for j in (i + 1)..<boxes.count {
                let dist = boxes[i].distance(other: boxes[j])
                distances.append((dist, (i, j)))
            }
        }
        
        distances.sort(by:  {$0.0 < $1.0})
        
        var circuits: [Set<Int>] = boxes.enumerated().map { index, _ in
            Set([index])
        }
        var x_prod = 0
        var k = 0
        
        while circuits.count != 1 {
            let (d, (i, j)) = distances[k]
            
            var solo = true
            
            for idx in 0..<circuits.count {
                if circuits[idx].contains(i) {
                    circuits[idx].insert(j)
                    solo = false
                }
            }
            
            for idx in 0..<circuits.count {
                if circuits[idx].contains(j) {
                    circuits[idx].insert(i)
                    solo = false
                }
            }
            
            if solo {
                var new_circuit : Set<Int> = []
                new_circuit.insert(i)
                new_circuit.insert(j)
                circuits.append(new_circuit)
            }
            
            // merge
            var to_merge: [Int] = [];
            for index in 0..<circuits.count {
                if circuits[index].contains(i) || circuits[index].contains(j) {
                    to_merge.append(index);
                }
            }
            if to_merge.count > 1 {
                var new_circuit : Set<Int> = [];
                for index in to_merge.reversed() {
                    let circuit = circuits.remove(at: index);
                    for box_index in circuit {
                        new_circuit.insert(box_index);
                    }
                }
                circuits.append(new_circuit);
            }
            
            x_prod = boxes[i].x * boxes[j].x;

            k += 1
        }
        
        return "\(x_prod)"
    }
}
