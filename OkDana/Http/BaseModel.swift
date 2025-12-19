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
        case geometric,
             probabilistically,
             somewhat,
             acs
        case complications,
             never,
             heuristically,
             simulation
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

class leftModel: Codable {
    var geometric: String?
    var finds: String?
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
    var inputs: String?
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
    var other_url: [other_urlModel]?
    var left: leftModel?
    var space: String?
    
    enum CodingKeys: String, CodingKey {
        case slip,
             alpha,
             reflecting,
             consecutively,
             easier,
             inputs,
             yves,
             combining,
             virtual,
             despite,
             nest,
             resulting,
             img_url,
             system,
             artificial,
             userInfo,
             other_url,
             left,
             space
    }
    
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        space = try? c.decode(String.self, forKey: .space)
        left = try? c.decode(leftModel.self, forKey: .left)
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
        other_url = try? c.decode([other_urlModel].self, forKey: .other_url)
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
        case evaporation,
             pspace,
             disappear,
             subclass,
             hierarchy,
             proportional,
             laying,
             lays
    }
    
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        evaporation = try? c.decode(String.self, forKey: .evaporation)
        pspace = try? c.decode(String.self, forKey: .pspace)
        disappear = try? c.decode(String.self, forKey: .disappear)
        subclass = try? c.decode(String.self, forKey: .subclass)
        hierarchy = try? c.decode(String.self, forKey: .hierarchy)
        proportional = try? c.decode(String.self, forKey: .proportional)
        
        if let s = try? c.decode(String.self, forKey: .lays) {
            lays = s
        } else if let i = try? c.decode(Int.self, forKey: .lays) {
            lays = String(i)
        } else {
            lays = nil
        }
        
        if let s = try? c.decode(String.self, forKey: .laying) {
            laying = s
        } else if let i = try? c.decode(Int.self, forKey: .laying) {
            laying = String(i)
        } else {
            laying = nil
        }
        
    }
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
    var dujalsArray: [String]?
    
    enum CodingKeys: String, CodingKey {
        case arbitrary, pspace, subclass, hierarchy
        case rational, actual, obstacle, discretized
        case deposited, trail, dujals
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        arbitrary = try container.decodeIfPresent(Int.self, forKey: .arbitrary)
        pspace = try container.decodeIfPresent(String.self, forKey: .pspace)
        subclass = try container.decodeIfPresent(String.self, forKey: .subclass)
        hierarchy = try container.decodeIfPresent(String.self, forKey: .hierarchy)
        rational = try container.decodeIfPresent(String.self, forKey: .rational)
        actual = try container.decodeIfPresent(String.self, forKey: .actual)
        obstacle = try container.decodeIfPresent(String.self, forKey: .obstacle)
        discretized = try container.decodeIfPresent(String.self, forKey: .discretized)
        deposited = try container.decodeIfPresent(String.self, forKey: .deposited)
        trail = try container.decodeIfPresent(String.self, forKey: .trail)
        if let model = try? container.decodeIfPresent(dujalsModel.self, forKey: .dujals) {
            dujals = model
            dujalsArray = nil
        } else if let array = try? container.decodeIfPresent([String].self, forKey: .dujals) {
            dujalsArray = array
            dujals = nil
        } else {
            dujals = nil
            dujalsArray = nil
        }
    }
}

class other_urlModel: Codable {
    var geometric: String?
    var inputs: String?
    var sanjeev: String?
}
