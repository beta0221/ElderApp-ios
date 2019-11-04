// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eventCategory = try? newJSONDecoder().decode(EventCategory.self, from: jsonData)

import Foundation

// MARK: - EventCategoryElement
class EventCategoryElement: Codable {
    let id: Int?
    let name, slug: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int?, name: String?, slug: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.name = name
        self.slug = slug
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

typealias EventCategory = [EventCategoryElement]
