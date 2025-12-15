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
    var despite: despiteModel?
    var nest: [nestModel]?
    var resulting: Int?
    var img_url: String?
    var system: [systemModel]?
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
    var deposited: String?
    var trail: String?
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
    var map: String?
}

class virtualModel: Codable {
    var map: String?
    var inputs: String?
    var complications: Int?
    var geometric: String?
}

class nestModel: Codable {
    var food: String?
    var ants: String?
    var somewhat: String?
}

class simulationModel: Codable {
    var concurrent: String?
    var complications: Int?
}

class systemModel: Codable {
    var geometric: String?
    var probabilistically: String?
    var somewhat: String?
    var acs: String?
    var complications: String?
    var never: String?
    var heuristically: Int?
    var simulation: [simulationModel]?

    enum CodingKeys: String, CodingKey {
        case geometric, probabilistically, somewhat, acs
        case complications, never, heuristically, simulation
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        geometric = try container.decodeIfPresent(String.self, forKey: .geometric)
        probabilistically = try container.decodeIfPresent(String.self, forKey: .probabilistically)
        somewhat = try container.decodeIfPresent(String.self, forKey: .somewhat)
        acs = try container.decodeIfPresent(String.self, forKey: .acs)
        never = try container.decodeIfPresent(String.self, forKey: .never)
        heuristically = try container.decodeIfPresent(Int.self, forKey: .heuristically)
        simulation = try container.decodeIfPresent([simulationModel].self, forKey: .simulation)

        if let str = try? container.decode(String.self, forKey: .complications) {
            complications = str
        } else if let int = try? container.decode(Int.self, forKey: .complications) {
            complications = String(int)
        } else {
            complications = nil
        }
    }
}
