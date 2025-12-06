//
//  Day05.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

struct IntRange: Hashable {
    var lower: Int
    var upper: Int
}

class Day05 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var ranges : [(Int, Int)] = []
        var ingredients : [Int] = []
        
        for line in lines {
            if line.contains("-") {
                let split = line.split(separator: "-")
                let start = Int(split.first!)!
                let end = Int(split.last!)!
                ranges.append((start, end))
            } else {
                ingredients.append(Int(line)!)
            }
        }

        var counter = 0
        for ingredient in ingredients {
            var is_in_range = false
            for range in ranges {
                if ingredient >= range.0 && ingredient <= range.1 {
                    is_in_range = true
                }
            }
            
            if is_in_range {
                counter += 1
            }
            
        }
        
        return "\(counter)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var fresh_sets: [IntRange] = []
        
        for line in lines {
            if !line.contains("-") {
                break
            }
                        
            let split = line.split(separator: "-")
            let start = Int(split.first!)!
            let end = Int(split.last!)!
            
            if fresh_sets.isEmpty {
                fresh_sets.append(IntRange(lower : start, upper : end))
            } else {
                var no_overlaps = true
                
                for i in fresh_sets.indices {
                    var set = fresh_sets[i]
                    if start >= set.lower && start <= set.upper {
                        no_overlaps = false
                        set.upper = max(set.upper, end)
                        // start is inside first set
                        // update end of first set
                    } else if end >= set.lower && end <= set.upper {
                        // end is inside first set
                        // update start of first set
                        no_overlaps = false
                        set.lower = min(set.lower, start)
                    }
                    fresh_sets[i] = set
                }
                if no_overlaps {
                    fresh_sets.append(IntRange(lower:start, upper:end))
                }
                
                // delete overlaps
                var to_drop = Set<IntRange>()
                let other_sets = fresh_sets
                
                for i in other_sets.indices {
                    let other_set = other_sets[i]
                    for j in fresh_sets.indices {
                        var set = fresh_sets[j]
                        if other_set == set || to_drop.contains(set) || to_drop.contains(other_set) {
                            continue
                        }
                        if other_set.lower >= set.lower && other_set.lower <= set.upper {
                            set.upper = max(set.upper, other_set.upper)
                            to_drop.insert(other_set)
                            // start is inside first set
                            // update end of first set
                        } else if other_set.upper >= set.lower && other_set.upper <= set.upper {
                            // end is inside first set
                            // update start of first set
                            set.lower = min(set.lower, other_set.lower)
                            to_drop.insert(other_set)
                        }
                        fresh_sets[j] = set
                    }
                }
                for drop in to_drop {
                    fresh_sets.removeAll { $0 == drop }
                }
            }
          
        }

        var counter = 0
        for set in fresh_sets {
            counter += set.upper - set.lower + 1
        }
        
        return "\(counter)"
    }
}
