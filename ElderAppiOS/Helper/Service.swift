//
//  Service.swift
//  D+AF
//
//  Created by Movark on 2019/8/21.
//  Copyright © 2019 Movark. All rights reserved.
//

import Foundation
// 导入CommonCrypto
import CommonCrypto
import CoreData

enum APIError:Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}
    

struct Service {
    
    let host:String
    
    init() {
        host = "https://m.daf-shoes.com"
    }
    
    private func printJsonData(jsonData:Data){
        let string = String(data: jsonData, encoding: String.Encoding.utf8) as String?
        print(string ?? "")
    }
    
    
    
    
    
    
    
    
    
    
}




extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}


