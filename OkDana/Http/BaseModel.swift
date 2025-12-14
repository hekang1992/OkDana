//
//  BaseModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

class BaseModel: Codable {
    var somewhat: Int?
    var conversion: String?
    var combined: combinedModel?

    enum CodingKeys: String, CodingKey {
        case somewhat
        case conversion
        case combined
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        somewhat = try container.decodeIfPresent(Int.self, forKey: .somewhat)
        conversion = try container.decodeIfPresent(String.self, forKey: .conversion)

        if let model = try? container.decode(combinedModel.self, forKey: .combined) {
            combined = model
        } else if let _ = try? container.decode([combinedModel].self, forKey: .combined) {
            combined = nil
        } else {
            combined = nil
        }
    }
}

class combinedModel: Codable {
    var slip: String?
    var alpha: String?
    var reflecting: String?
    var consecutively: consecutivelyModel?
    var easier: [easierModel]?
    var inputs: String?
    var yves: yvesModel?
    var combining: [combiningModel]?
    var virtual: virtualModel?
}

class consecutivelyModel: Codable {
    var pairs: String?
    var consists: String?
    var crane: String?
    var stacker: String?
}

class easierModel: Codable {
    var complications: String?
    var despite: [despiteModel]?
}

class despiteModel: Codable {
    var arbitrary: Int?
    var pspace: String?
    var subclass: String?
    var hierarchy: String?
    var rational: String?
    var actual: String?
    var obstacle: String?
    var discretized: String?
}

class yvesModel: Codable {
    var evaporation: String?
    var pspace: String?
    var disappear: String?
    var subclass: String?
    var hierarchy: String?
}

class combiningModel: Codable {
    var geometric: String?
    var probabilistically: String?
    var chooses: String?
    var discovery: Int?
}

class virtualModel: Codable {
    var map: String?
    var inputs: String?
    var complications: Int?
    var geometric: String?
}
