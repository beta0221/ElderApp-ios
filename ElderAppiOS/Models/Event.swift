// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let event = try? newJSONDecoder().decode(Event.self, from: jsonData)

import Foundation

// MARK: - EventElement
class EventElement: Codable {
    let id, categoryID, districtID, rewardLevelID: Int?
    let title, body, dateTime: String?
    let dateTime2: String?
    let location, image, deadline, createdAt: String?
    let updatedAt, slug: String?
    let maximum, people, numberOfPeople: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case districtID = "district_id"
        case rewardLevelID = "reward_level_id"
        case title, body, dateTime
        case dateTime2 = "dateTime_2"
        case location, image, deadline
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case slug, maximum, people, numberOfPeople
    }
    
    init(id: Int?, categoryID: Int?, districtID: Int?, rewardLevelID: Int?, title: String?, body: String?, dateTime: String?, dateTime2: String?, location: String?, image: String?, deadline: String?, createdAt: String?, updatedAt: String?, slug: String?, maximum: Int?, people: Int?, numberOfPeople: Int?) {
        self.id = id
        self.categoryID = categoryID
        self.districtID = districtID
        self.rewardLevelID = rewardLevelID
        self.title = title
        self.body = body
        self.dateTime = dateTime
        self.dateTime2 = dateTime2
        self.location = location
        self.image = image
        self.deadline = deadline
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.slug = slug
        self.maximum = maximum
        self.people = people
        self.numberOfPeople = numberOfPeople
    }
}

typealias Event = [EventElement]
