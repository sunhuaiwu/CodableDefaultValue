//
//  Codable+DefaultValue.swift
//  CodableDefaultValue
//
//  Created by 孙怀武 on 2021/6/30.
//

import Foundation

struct HWIntOrString: Codable {
    var int: Int {
        didSet {
            let stringValue = "\(int)"
            if string != stringValue {
                string = stringValue
            }
        }
    }
    var string: String {
        didSet {
            let intValue = Int(string) ?? 0
            if int != intValue {
                int = intValue
            }
        }
    }
    
    init() {
        int = 0
        string = "0"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            int = intValue
            string = "\(int)"
        } else if let stringValue = try? container.decode(String.self) {
            string = stringValue
            int = Int(stringValue) ?? 0
        } else {
            int = 0
            string = "0"
        }
    }
}

//MARK: -------- Codable Default Value
protocol HWDefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value {get set}
}

@propertyWrapper
struct HWDefault<T: HWDefaultValue> {
    var wrappedValue: T.Value
}
extension HWDefault: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}
extension KeyedDecodingContainer {
    func decode<T>(_ type: HWDefault<T>.Type, forKey key: Key) throws -> HWDefault<T> where T: HWDefaultValue {
        (try decodeIfPresent(type, forKey: key)) ?? HWDefault.init(wrappedValue: T.defaultValue)
    }
}
extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: HWDefault<T>, forKey key: Key) throws where T : HWDefaultValue {
        try encodeIfPresent(value.wrappedValue, forKey: key)
    }
}

//MARK: -------- Set Default Value
extension Int: HWDefaultValue {
    static var defaultValue = 0
}

extension String {
    struct NULL: HWDefaultValue {
        static var defaultValue = "null"
    }
    struct UNNAMED: HWDefaultValue {
        static var defaultValue = "unnamed"
    }
    struct UNKNOWN: HWDefaultValue {
        static var defaultValue = "unknown"
    }
}

extension HWIntOrString: HWDefaultValue {
    static var defaultValue = HWIntOrString()
}
