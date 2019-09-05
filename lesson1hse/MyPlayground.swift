//
//  MyPlayground.swift
//  Lesson1Lecture
//
//  Created by Анастасия Распутняк on 08.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

func print7NumbersInRange(a : Int, b : Int, n : Int) {
    var count = 0
    var exist = false
    for i in a...b {
        let strInt = String(i)
        for j in 0..<strInt.count {
            if strInt[j] == "7" {
                count += 1
            }
        }
        
        if count == n {
            print(strInt)
            if !exist {
                exist = true
            }
        }
    }
    
    if !exist {
        print("no such numbers in this interval")
    }
}


func printReversedNumber(number : Int) {
    switch number / 100 {
    case 0:
        print("this number is too small")
        return
    case 1...9:
        let first = number % 10
        let midd = (number % 100 ) / 10
        let last : Int = number / 100
        let result = first * 100 + midd * 10 + last
        print(result)
        return
    default:
        print("this number is too big")
        return
    }
}

func isLucky(number : Int) {
    let isFourSigned : Int = number / 1000
    if isFourSigned > 0 && isFourSigned < 10 {
        let a = isFourSigned
        let b = (number % 1000) / 100
        let c = (number % 100) / 10
        let d = number % 10
        if a + b == c + d {
            print("number is lucky")
        } else {
            print("number is ordinary")
        }
    } else {
        print("number is not foursigned~")
        return
    }
}


func factorial(number : Int) -> Int? {
    if number < 0 {
        print("factorial is for non-negative numbers!")
        return nil
    }
    
    var result = 1
    
    if number == 1 {
        return result
    }
    
    for i in 1...number {
        result *= i
    }
    
    return result
}


func getFunctionResult(x : Double) -> Double {
    switch x {
    case let xx where xx <= -0.5:
        return 0.5
    case let xx where xx > -0.5 && xx <= 0:
        return xx + 1
    case let xx where xx > 0 && xx <= 1:
        return xx * xx + 1
    default:
        return x - 1
    }
}


func getFunction2Result(x : Double) -> Double {
    switch x {
    case let xx where xx <= 0.5:
        return sin(.pi / 2)
    default:
        return sin((x - 1) * .pi / 2)
    }
}


func reduceFraction(nominator : Int, denominator : Int) -> (nominator : Int, denominator : Int) {
    let nod = euklidAlg(a: nominator, b: denominator)
    return (nominator / nod, denominator / nod)
}

func euklidAlg(a : Int, b : Int) -> Int {
    var maxVal = max(a, b)
    var minVal = min(a, b)
    
    var mod = -1
    while mod != 0 {
        mod = maxVal % minVal
        
        maxVal = minVal
        minVal = mod
    }
    
    return maxVal
}


func printCubNumbers() {
    for i in 100...999 {
        let first = i % 10
        let midd = (i % 100 ) / 10
        let last : Int = i / 100
        
        if Int(pow(Double(first), 3) + pow(Double(midd), 3) + pow(Double(last), 3)) == i {
            print(i)
        }
    }
}


func getCifer(k : Int, fromNumber n : Int) -> Int {
    let pow1 = pow(Double(10), Double(k))
    let pow2 = pow1 / 10
    
    let result = (n % Int(pow1)) / Int(pow2)
    return result
}


func fibonacci1(k : Int) -> Int? {
    if k < 0 {
        print("wrong k, k must be non-negative!")
        return nil
    }
    
    if k < 2 {
        return 1
    } else {
        return fibonacci1(k: k - 1)! + fibonacci1(k: k - 2)!
    }
}

func fibonacci2(k : Int) -> Int? {
    if k < 0 {
        print("wrong k, k must be non-negative!")
        return nil
    }
    
    if k == 0 || k == 1 {
        return 1
    }
    
    var fibonacci = [Int]()
    fibonacci.append(1)
    fibonacci.append(1)
    
    for i in 2..<k {
        fibonacci.append(fibonacci[i - 1] + fibonacci[i - 2])
    }
    
    return fibonacci[k - 1]
}


func getPrimeNumbers(n : Int) -> Int {
    var randomNumbers = generateRandomArray(n: n)
    var count = 0
    
    for i in 0..<n {
        if isPrime(number: randomNumbers[i]) {
            count += 1
        }
    }
    
    return count
}

func isPrime(number : Int) -> Bool {
    let upperBound = Int(pow(Double(number), 0.5)) + 1
    
    for i in 2...upperBound {
        if number % i == 0 {
            return false
        }
    }
    
    return true
}

func generateRandomArray(n : Int) -> [Int] {
    var randomNumbers = [Int]()
    
    for _ in 0..<n {
        randomNumbers.append(Int(arc4random()) % 201)
    }
    
    return randomNumbers
}


func getMinMax(n : Int) -> (min : Int, max : Int) {
    var randomNumbers = generateRandomArray(n: n)
    
    var min = randomNumbers[0]
    var max = randomNumbers[0]
    
    for i in 1..<randomNumbers.count {
        if randomNumbers[i] < min {
            min = randomNumbers[i]
        }
        
        if randomNumbers[i] > max {
            max = randomNumbers[i]
        }
    }
    
    return (min : min, max : max)
}


func sumDiagonals(n : Int) -> (main : Int, ortog : Int) {
    var twoDimArray = [[Int]]()
    var mainSum = 0
    var ortogSum = 0
    
    for _ in 0..<n {
        twoDimArray.append(generateRandomArray(n: n))
    }
    
    for i in 0..<n {
        mainSum += twoDimArray[i][i]
        ortogSum += twoDimArray[i][n - i - 1]
    }
    
    return (main : mainSum, ortog : ortogSum)
}


func biggestDiff(n : Int) -> (elem1 : Int, elem2 : Int) {
    var array = [Int]()
    
    for _ in 0..<n {
        array.append(Int(arc4random()) % 25 - 5)
    }
    
    var elem1 = array[0]
    var elem2 = elem1
    var difference = -100
    
    for i in 0..<n {
        for j in 0..<n {
            if i != j {
                let diff1 = array[i] - array[j]
                let diff2 = array[j] - array[i]
                
                if diff1 > difference || diff2 > difference {
                    if diff1 > diff2 {
                        elem1 = array[i]
                        elem2 = array[j]
                        difference = diff1
                    } else {
                        elem1 = array[j]
                        elem2 = array[i]
                        difference = diff2
                    }
                }
            }
        }
    }
    
    return (elem1: elem1, elem2: elem2)
}
