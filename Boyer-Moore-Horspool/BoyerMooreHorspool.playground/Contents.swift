
/*
 Boyer-Moore string search
 
 代码基于文章 "Faster String Searches" by Costas Menico
 from Dr Dobb's magazine, July 1989.
 */
extension String {
    
    func index(of pattern: String, usingHorspoolImprovement: Bool = false) -> Index? {
        
        let patternLength = pattern.count
        guard patternLength > 0, patternLength <= self.count else {
            return nil
        }
        
        var skipTable = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            skipTable[c] = patternLength - i - 1
        }
        
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
        
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }
        
        while i < endIndex {
            let c = self[i]
            
            if c == lastChar {
                
                if let k = backwards() { return k }
                
                if !usingHorspoolImprovement {
                    i = index(after: i)
                } else {
                    
                    let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                    i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
                }
            } else {
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}


let str = "Hello, World"
str.index(of: "World")?.encodedOffset  // 7

let animals = "🐶🐔🐷🐮🐱"
animals.index(of: "🐮")  // 6

let lorem = "Lorem ipsum dolor sit amet"
lorem.index(of: "sit", usingHorspoolImprovement: true)  // 18
