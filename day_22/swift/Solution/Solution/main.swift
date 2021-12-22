//
//  main.swift
//  Solution
//

import Foundation

typealias Instruction = (Int, Int, Int, Int, Int, Int, Int)

let pattern = #"(on|off) x=(.*)\.\.(.*),y=(.*)\.\.(.*),z=(.*)\.\.(.*)"#
let expression = try! NSRegularExpression(pattern: pattern)

let contents = try! String(contentsOfFile: "input.data")
let instructions = contents.split(separator: "\n").map { _line -> Instruction in
    let line = String(_line)
    let range = NSMakeRange(0, line.count)
    let match = expression.matches(in: line, options: [], range: range).first!
    
    let cm = String(line[Range(match.range(at: 1), in: line)!])
    let x1 = String(line[Range(match.range(at: 2), in: line)!])
    let x2 = String(line[Range(match.range(at: 3), in: line)!])
    let y1 = String(line[Range(match.range(at: 4), in: line)!])
    let y2 = String(line[Range(match.range(at: 5), in: line)!])
    let z1 = String(line[Range(match.range(at: 6), in: line)!])
    let z2 = String(line[Range(match.range(at: 7), in: line)!])
    
    return (cm == "on" ? 1 : 0, Int(x1)!, Int(x2)!, Int(y1)!, Int(y2)!, Int(z1)!, Int(z2)!)
}

func partOne(_ instructions: [Instruction]) -> Int {

    var grid: [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating: false, count: 101), count: 101), count: 101)
    
    let reducedInstructions = instructions.map { (cmd, x1, x2, y1, y2, z1, z2) in
        return (cmd, max(-50, x1), min(50, x2), max(-50, y1), min(50, y2), max(-50, z1), min(50, z2))
    }
    
    for (cmd, x1, x2, y1, y2, z1, z2) in reducedInstructions {
        let value = cmd == 1
        guard x1 <= x2 && y1 <= y2 && z1 <= z2 else {
            continue
        }
        for i in x1...x2 {
            for j in y1...y2 {
                for k in z1...z2 {
                    grid[i + 50][j + 50][k + 50] = value
                }
            }
        }
    }
    
    return grid.reduce(0) { acc, ys in
        acc + ys.reduce(0, { acc, xs in
            acc + xs.reduce(0, { acc, value in
                acc + (value ? 1 : 0)
            })
        })
    }
}

func partTwo(_ instructions: [Instruction]) -> Int {
    var volumes: [Instruction] = []
    for (cmd1, xMin1, xMax1, yMin1, yMax1, zMin1, zMax1) in instructions {
        volumes.append(contentsOf: volumes.compactMap { (cmd2, xMin2, xMax2, yMin2, yMax2, zMin2, zMax2) in
            let (xMin, xMax) = (max(xMin1, xMin2), min(xMax1, xMax2))
            let (yMin, yMax) = (max(yMin1, yMin2), min(yMax1, yMax2))
            let (zMin, zMax) = (max(zMin1, zMin2), min(zMax1, zMax2))
            guard xMin <= xMax && yMin <= yMax && zMin <= zMax else {
                return nil
            }
            
            return (cmd2 == 1 ? 0 : 1, xMin, xMax, yMin, yMax, zMin, zMax)
        })
        if cmd1 == 1 {
            volumes.append((cmd1, xMin1, xMax1, yMin1, yMax1, zMin1, zMax1))
        }
    }

    return volumes.reduce(0, { acc, arg in
        let (cmd, x1, x2, y1, y2, z1, z2) = arg
        return acc + (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1) * (cmd == 1 ? 1 : -1)
    })
}

print("Part one: \(partOne(instructions))")
print("Part two: \(partTwo(instructions))")
