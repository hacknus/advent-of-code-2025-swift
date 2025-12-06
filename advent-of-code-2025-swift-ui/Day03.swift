//
//  Day03.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

import Foundation

class Day03 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var s = 0

        for bank in lines {
            let batteries = bank.map { Int(String($0))! }
            let batteries_sorted = batteries.sorted()
            var battery_1 = batteries_sorted.last!
            var pos_1 = batteries.firstIndex(of: battery_1)!
            
            if pos_1 == batteries.count - 1 {
                battery_1 = batteries_sorted[batteries.count - 2]
                pos_1 = batteries.firstIndex(of: battery_1)!
            }
            
            let batteries_slice_sorted = batteries[(pos_1 + 1)...].sorted()
            let battery_2 = batteries_slice_sorted.last!
            
            let joltage = battery_2 + 10 * battery_1
            s += joltage
        }
        
        return "\(s)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        let num_batteries = 12
        
        var s = 0

        for bank in lines {
            let batteries: [(Int, Int)] = bank.enumerated().map { i, c in
                (i, Int(String(c))!)
            }
            
            let batteries_sorted = batteries.sorted(by: {$0.1 < $1.1})
            
            // take highest one
            var battery_1 = batteries_sorted.last!
            
            // check that there is enough space left for the other batteries
            var i = 1
            while battery_1.0 > batteries.count - 1 - num_batteries + 1 {
                battery_1 = batteries_sorted[batteries.count - 1 - i]
                i += 1
            }
            
            // if there are multiple batteries with the same value, pick the first one
            var filtered_batteries = batteries_sorted.filter { $0.1 == battery_1.1 }
            filtered_batteries.sort(by : { $0.0 < $1.0 })
            battery_1 = filtered_batteries.first!
            
            var last_pos = battery_1.0
            var selected_batteries = [battery_1]
            
            for n_i in 1..<num_batteries {
                let batteries_slice_sorted = batteries[(last_pos + 1)...].sorted(by: { $0.1 < $1.1 } )
                var this_battery = batteries_slice_sorted.last!
                
                // if there are multiple batteries with the same value, pick the first one
                var filtered_batteries = batteries_slice_sorted.filter { $0.1 == this_battery.1 }
                filtered_batteries.sort(by : { $0.0 < $1.0 })
                this_battery = filtered_batteries.first!
                
                // check that there is enough space left for the other batteries
                var i = 1
                while this_battery.0  > batteries.count - 1 - num_batteries + n_i + 1 {
                    this_battery = batteries_slice_sorted[batteries_slice_sorted.count - 1 - i]
                    
                    var filtered_batteries = batteries_slice_sorted.filter { $0.1 == this_battery.1 }
                    filtered_batteries.sort(by : { $0.0 < $1.0 })
                    this_battery = filtered_batteries.first!
                    i += 1
                }
                
                last_pos = this_battery.0
                selected_batteries.append(this_battery)

            }

            var joltage = 0
            for (i, bat) in   selected_batteries.enumerated() {
                joltage += (bat.1 * Int(pow(10, Double(num_batteries - i - 1))))
            }
            
            s += joltage
        }
        
        return "\(s)"
    }
}
