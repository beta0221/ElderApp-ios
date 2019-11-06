// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
class User: Codable {
    let id: Int?
    let idCode, name, email: String?
    let emailVerifiedAt: JSONNull?
    let wallet, rank, gender: Int?
    let birthdate, phone, tel, address: String?
    let img: JSONNull?
    let idNumber, districtID: String?
    let districtName, inviterID, inviter, inviterPhone: JSONNull?
    let emgContact, emgPhone, orgRank: JSONNull?
    let payStatus, payMethod: Int?
    let joinDate, lastPayDate: JSONNull?
    let valid: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case idCode = "id_code"
        case name, email
        case emailVerifiedAt = "email_verified_at"
        case wallet, rank, gender, birthdate, phone, tel, address, img
        case idNumber = "id_number"
        case districtID = "district_id"
        case districtName = "district_name"
        case inviterID = "inviter_id"
        case inviter
        case inviterPhone = "inviter_phone"
        case emgContact = "emg_contact"
        case emgPhone = "emg_phone"
        case orgRank = "org_rank"
        case payStatus = "pay_status"
        case payMethod = "pay_method"
        case joinDate = "join_date"
        case lastPayDate = "last_pay_date"
        case valid
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int?, idCode: String?, name: String?, email: String?, emailVerifiedAt: JSONNull?, wallet: Int?, rank: Int?, gender: Int?, birthdate: String?, phone: String?, tel: String?, address: String?, img: JSONNull?, idNumber: String?, districtID: String?, districtName: JSONNull?, inviterID: JSONNull?, inviter: JSONNull?, inviterPhone: JSONNull?, emgContact: JSONNull?, emgPhone: JSONNull?, orgRank: JSONNull?, payStatus: Int?, payMethod: Int?, joinDate: JSONNull?, lastPayDate: JSONNull?, valid: Int?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.idCode = idCode
        self.name = name
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
        self.wallet = wallet
        self.rank = rank
        self.gender = gender
        self.birthdate = birthdate
        self.phone = phone
        self.tel = tel
        self.address = address
        self.img = img
        self.idNumber = idNumber
        self.districtID = districtID
        self.districtName = districtName
        self.inviterID = inviterID
        self.inviter = inviter
        self.inviterPhone = inviterPhone
        self.emgContact = emgContact
        self.emgPhone = emgPhone
        self.orgRank = orgRank
        self.payStatus = payStatus
        self.payMethod = payMethod
        self.joinDate = joinDate
        self.lastPayDate = lastPayDate
        self.valid = valid
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
