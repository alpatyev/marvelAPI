import Foundation

// MARK: - Describe data in kilobytes

extension Data {
    func kilobytesString() -> String {
        let sizeInBytes = Double(self.count)
        let sizeInKilobytes = sizeInBytes / 1024.0
        return String(format: "%.2f KB", sizeInKilobytes)
    }
}
