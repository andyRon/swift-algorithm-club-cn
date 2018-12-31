import Foundation

public func random(min min: Int, max: Int) -> Int {
    assert(min < max)
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func select<T>(from a: [T], count k: Int) -> [T] {
    var a = a
    for i in 0..<k {
        let r = random(min: i, max: a.count - 1)
        if i != r {
//            swap(&a[i], &a[r])
        a.swapAt(&a[i], &a[r])
            
        }
    }
    return Array(a[0..<k])
}

func reservoirSample<T>(from a: [T], count k: Int) -> [T] {
    precondition(a.count >= k)
    
    var result = [T]()
    
    for i in 0..<k {
        result.append(a[i])
    }
    
    for i in k..<a.count {
        let j = random(min: 0, max: i)
        if j < k {
            result[j] = a[i]
        }
    }
    return result
}

func select<T>(from a: [T], count requested: Int) -> [T] {
    var examined = 0
    var selected = 0
    var b = [T]()
    
    while selected < requested {
        
        let r = Double(arc4random()) / 0x100000000
        
        let leftToExamine = a.count - examined
        let leftToAdd = requested - selected
        
        if Double(leftToExamine) * r < Double(leftToAdd) {
            selected += 1
            b.append(a[examined])
        }
        
        examined += 1
    }
    return b
}
