import Foundation
import CommonCrypto

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
        let string = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_MD5(string, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLength { hash.appendFormat("%02x", result[i]) }
        result.deallocate()
        return String(format: hash as String)
    }
}
