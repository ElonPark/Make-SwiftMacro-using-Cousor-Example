/// 프로퍼티의 정보를 담는 모델
struct PropertyInfo {
    let name: String
    let customKey: String?
    
    var codingKeyDeclaration: String {
        if let customKey = customKey {
            return "case \(name) = \(customKey)"
        }
        return "case \(name)"
    }
} 