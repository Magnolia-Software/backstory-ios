//import Foundation
//import CommonCrypto
//
//class DataEncryption {
//
//    static func encrypt(data: Data, key: Data) throws -> Data {
//        var numBytesEncrypted: size_t = 0
//        var encryptedData = Data(count: data.count + kCCBlockSizeAES128)
//        
//        let cryptStatus = encryptedData.withUnsafeMutableBytes { encryptedBytes in
//            let encryptedBytesPointer = encryptedBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//            return data.withUnsafeBytes { dataBytes in
//                let dataBytesPointer = dataBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//                return key.withUnsafeBytes { keyBytes in
//                    let keyBytesPointer = keyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//                    return CCCrypt(
//                        CCOperation(kCCEncrypt),
//                        CCAlgorithm(kCCAlgorithmAES128),
//                        CCOptions(kCCOptionPKCS7Padding),
//                        keyBytesPointer, kCCKeySizeAES256,
//                        nil,
//                        dataBytesPointer, data.count,
//                        encryptedBytesPointer, encryptedData.count,
//                        &numBytesEncrypted
//                    )
//                }
//            }
//        }
//        
//        guard cryptStatus == kCCSuccess else {
//            throw NSError(domain: "EncryptionError", code: Int(cryptStatus), userInfo: nil)
//        }
//        
//        encryptedData.removeSubrange(numBytesEncrypted..<encryptedData.count)
//        return encryptedData
//    }
//    
//    static func decrypt(data: Data, key: Data) throws -> Data {
//        var numBytesDecrypted: size_t = 0
//        var decryptedData = Data(count: data.count)
//        
//        let cryptStatus = decryptedData.withUnsafeMutableBytes { decryptedBytes in
//            let decryptedBytesPointer = decryptedBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//            return data.withUnsafeBytes { dataBytes in
//                let dataBytesPointer = dataBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//                return key.withUnsafeBytes { keyBytes in
//                    let keyBytesPointer = keyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
//                    return CCCrypt(
//                        CCOperation(kCCDecrypt),
//                        CCAlgorithm(kCCAlgorithmAES128),
//                        CCOptions(kCCOptionPKCS7Padding),
//                        keyBytesPointer, kCCKeySizeAES256,
//                        nil,
//                        dataBytesPointer, data.count,
//                        decryptedBytesPointer, decryptedData.count,
//                        &numBytesDecrypted
//                    )
//                }
//            }
//        }
//        
//        guard cryptStatus == kCCSuccess else {
//            throw NSError(domain: "DecryptionError", code: Int(cryptStatus), userInfo: nil)
//        }
//        
//        decryptedData.removeSubrange(numBytesDecrypted..<decryptedData.count)
//        return decryptedData
//    }
//}
////
////// Usage example
////let key = "your-256-bit-key-your-256-bit-key".data(using: .utf8)!
////let dataToEncrypt = "Sensitive data".data(using: .utf8)!
////
////do {
////    let encryptedData = try DataEncryption.encrypt(data: dataToEncrypt, key: key)
////    let decryptedData = try DataEncryption.decrypt(data: encryptedData, key: key)
////    let decryptedString = String(data: decryptedData, encoding: .utf8)
////    print("Decrypted String: \(decryptedString ?? "")")
////} catch {
////    print("Encryption/Decryption error: \(error)")
////}
