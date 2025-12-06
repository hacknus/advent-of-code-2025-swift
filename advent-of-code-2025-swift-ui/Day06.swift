//
//  Day06.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

class Day06 : Day {
    override func part_1(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        
        var problems: [[Int]] = []
        for _ in lines.first!.split(separator: " ") {
            problems.append([])
        }
        
        var operators: [String] = []
        for line in lines{
            let line = line.split(separator: " ")
            if Int(String(line.first!)) != nil {
                for (i, element) in line.enumerated() {
                    problems[i].append(Int(String(element))!)
                }
            } else {
                for element in line {
                    operators.append(String(element))
                }
            }
            
        }
        
        var counter = 0
        for (i, problem) in problems.enumerated( ) {
            switch operators[i] {
            case "+":
                counter += problem.reduce(0, +)
                break
            case "*":
                counter += problem.reduce(1, *)
                break
            default:
                break
            }
        }
        
        return "\(counter)"

    }
    
    override func part_2(filename: String = "input") -> String {
        let input = readInput(filename: filename)
        let lines = input.split(separator: "\n")
        

        var operators: [(Int, String)] = []
        var separators = 1
        
        for c in lines.last!.reversed() {
            switch c {
            case "+":
                operators.append((separators, "+"))
                separators = 0
            case "*":
                operators.append((separators, "*"))
                separators = 0
            default:
                separators += 1

            }
            
        }
        operators.reverse()
        
        print("\(operators)")
        
        var problems = Array(
            repeating: Array(
                repeating: Array<String>(),
                count: lines.count - 1
            ),
            count: operators.count
        )

        for line_i in 0 ..< lines.count - 1 {
            let line = lines[line_i]
            let bytes = Array(line.utf8)
            var i = 0

            for (operator_i, op) in operators.enumerated() {
                if i >= bytes.count {
                    problems[operator_i][line_i] = []
                } else {
                    let endExclusive = min(bytes.count, i + op.0)
                    let segmentBytes = bytes[i ..< endExclusive]
                    problems[operator_i][line_i] =
                        segmentBytes.map { String(UnicodeScalar($0)) }
                }
                i += op.0 + 1
            }
        }
        
        print("\(problems)")
        
        var counter = 0
        for (i, problem)  in problems.enumerated() {
            switch operators[i] {
            case (_, "+"):
                var res = 0
                let n = problem.first!.count
                for j in 0..<n {
                    var val = ""
                    for p in problem {
                        let idx = p.index(p.startIndex, offsetBy: j)
                        val += String(p[idx])
                    }
                    print("\(val)")
                    res += Int(val.trimmingCharacters(in: .whitespacesAndNewlines))!
                }
                print("\(res)")
                counter += res
            case (_, "*"):
                var res = 1
                let n = problem.first!.count
                for j in 0..<n {
                    var val = ""
                    for p in problem {
                        let idx = p.index(p.startIndex, offsetBy: j)
                        val += String(p[idx])
                    }
                    print("\(val)")

                    res *= Int(val.trimmingCharacters(in: .whitespacesAndNewlines))!
                }
                print("\(res)")
                counter += res
            default:
                break
            }
        }
        
        return "\(counter)"
    }
}
