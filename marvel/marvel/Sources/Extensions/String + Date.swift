import Foundation
import CryptoKit

// MARK: - Date with format

extension Date {
    func asString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

// MARK: - Hash from current string

extension String {
    
    func hashedUsingMD5() -> String {
        let dataString = Data(self.utf8)
        let hash = Insecure.MD5.hash(data: dataString)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
