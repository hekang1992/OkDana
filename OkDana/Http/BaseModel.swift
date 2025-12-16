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

class consecutivelyModel: Codable {
    var pairs: String?
    var consists: String?
    var crane: String?
    var stacker: String?
}

class easierModel: Codable {
    var complications: String?
    var despite: [despiteModel]?
    var pspace: String?
    var subclass: String?
    var trail: String?
    var dujals: dujalsModel?
    var genetic: String?
    var optimizations: [optimizationsModel]?
    var hierarchy: String?
    var sanjeev: String?
    var geometric: String?
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
    var dujals: dujalsModel?
}

class optimizationsModel: Codable {
    var geometric: String?
    var markov: String?
}

class dujalsModel: Codable {
    var sdaftg: String?
    var adsfar: String?
    var hafee: String?
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

class artificialModel: Codable {
    var geometric: String?
    var convex: String?
    var insertion: String?
    var constricting: String?
    var entropy: String?
    var simulation: [simulationModel]?
    var inserts: String?
    var concurrent: String?
    var hull: String?
}

class simulationModel: Codable {
    var concurrent: String?
    var complications: String?
    
    enum CodingKeys: String, CodingKey {
        case concurrent, complications
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        concurrent = try container.decodeIfPresent(String.self, forKey: .concurrent)
        if let value = try? container.decode(String.self, forKey: .complications) {
            complications = value
        } else if let value = try? container.decode(Int.self, forKey: .complications) {
            complications = String(value)
        } else {
            complications = nil
        }
    }
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

class userInfoModel: Codable {
    var motorways: String?
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
    var artificial: [artificialModel]?
    var userInfo: userInfoModel?
    
    enum CodingKeys: String, CodingKey {
        case slip, alpha, reflecting, consecutively, easier, inputs, yves,
             combining, virtual, despite, nest, resulting, img_url,
             system, artificial, userInfo
    }
    
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        userInfo = try? c.decode(userInfoModel.self, forKey: .userInfo)
        slip = try? c.decode(String.self, forKey: .slip)
        alpha = try? c.decode(String.self, forKey: .alpha)
        reflecting = try? c.decode(String.self, forKey: .reflecting)
        consecutively = try? c.decode(consecutivelyModel.self, forKey: .consecutively)
        easier = try? c.decode([easierModel].self, forKey: .easier)
        inputs = try? c.decode(String.self, forKey: .inputs)
        yves = try? c.decode(yvesModel.self, forKey: .yves)
        combining = try? c.decode([combiningModel].self, forKey: .combining)
        despite = try? c.decode(despiteModel.self, forKey: .despite)
        nest = try? c.decode([nestModel].self, forKey: .nest)
        resulting = try? c.decode(Int.self, forKey: .resulting)
        img_url = try? c.decode(String.self, forKey: .img_url)
        system = try? c.decode([systemModel].self, forKey: .system)
        artificial = try? c.decode([artificialModel].self, forKey: .artificial)
        if let v = try? c.decode(virtualModel.self, forKey: .virtual) {
            virtual = v
        } else {
            virtual = nil
        }
    }
}

class yvesModel: Codable {
    var evaporation: String?
    var pspace: String?
    var disappear: String?
    var subclass: String?
    var hierarchy: String?
    var proportional: String?
    var laying: String?
    var lays: String?

    enum CodingKeys: String, CodingKey {
        case evaporation, pspace, disappear, subclass,
             hierarchy, proportional, laying, lays
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        evaporation = try? c.decode(String.self, forKey: .evaporation)
        pspace = try? c.decode(String.self, forKey: .pspace)
        disappear = try? c.decode(String.self, forKey: .disappear)
        subclass = try? c.decode(String.self, forKey: .subclass)
        hierarchy = try? c.decode(String.self, forKey: .hierarchy)
        proportional = try? c.decode(String.self, forKey: .proportional)
        laying = try? c.decode(String.self, forKey: .laying)

        // ⭐ lays: String / Int
        if let s = try? c.decode(String.self, forKey: .lays) {
            lays = s
        } else if let i = try? c.decode(Int.self, forKey: .lays) {
            lays = String(i)
        } else {
            lays = nil
        }
    }
}
