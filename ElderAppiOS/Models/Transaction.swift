// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let transaction = try? newJSONDecoder().decode(Transaction.self, from: jsonData)

import Foundation

// MARK: - TransactionElement
class TransactionElement: Codable {
    let id: Int?
    let tranID: String?
    let userID: Int?
    let event: String?
    let amount, giveTake: Int?
    let targetID, createdAt, updatedAt, targetName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case tranID = "tran_id"
        case userID = "user_id"
        case event, amount
        case giveTake = "give_take"
        case targetID = "target_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case targetName = "target_name"
    }
    
    init(id: Int?, tranID: String?, userID: Int?, event: String?, amount: Int?, giveTake: Int?, targetID: String?, createdAt: String?, updatedAt: String?, targetName: String?) {
        self.id = id
        self.tranID = tranID
        self.userID = userID
        self.event = event
        self.amount = amount
        self.giveTake = giveTake
        self.targetID = targetID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.targetName = targetName
    }
}

typealias Transaction = [TransactionElement]
