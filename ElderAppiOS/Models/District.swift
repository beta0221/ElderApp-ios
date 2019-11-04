// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let district = try? newJSONDecoder().decode(District.self, from: jsonData)

import Foundation

// MARK: - DistrictElement
class DistrictElement: Codable {
    let id: Int?
    let group: Group?
    let name: String?
    
    init(id: Int?, group: Group?, name: String?) {
        self.id = id
        self.group = group
        self.name = name
    }
}

enum Group: String, Codable {
    case district = "district"
}

typealias District = [DistrictElement]
