//
//  ErrorHandler.swift
//  WeatherForecast
//
//  Created by Talish George on 07/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Foundation

protocol APIError {

    init?(code: Int, message: String?, description: String?)

    init?(json: [String: Any])

    // MARK: - Variables
    
    var code: Int? { get }
    var message: String? { get }
    var description: String? { get }
}

extension APIError {
    
    /// Error
    /// - Parameter data: Data
    static func error<E: APIError>(with data: Data) -> E? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return nil
            }

            return E(json: json)
        } catch {
            return nil
        }
    }
    
    /// Errors
    /// - Parameters:
    ///   - data: Data
    ///   - key: String
    static func errors<E: APIError>(with data: Data, errorKey key: String = "errors") -> [E] {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let errorsDicts = json[key] as? [[String: Any]] else {
                return []
            }

            var errors: [E] = []
            errorsDicts.forEach {
                if let error = E(json: $0) {
                    errors.append(error)
                }
            }
            return errors
        } catch {
            return []
        }
    }
}

enum GenericError: APIError {
    case undefined
    case noNetwork
    case noProviderFound
    case baseURLNotFound
    case endPointUndefined
    case http(error: APIError)
    case jsonParsing

    internal struct ConstantCode {
        static let undefined = 100000
        static let noNetwork = 100001
        static let noProviderFound = 100002
        static let baseURLNotFound = 100003
        static let endPointUndefined = 100004
        static let jsonParsing = 100005
    }

    // MARK: - Init
    
    /// Init
    /// - Parameters:
    ///   - code: Int
    ///   - message: String
    ///   - description: String
    public init?(code: Int, message: String?, description: String?) {
        switch code {
        case ConstantCode.undefined:
            self = .undefined
        case ConstantCode.noNetwork:
            self = .noNetwork
        case ConstantCode.noProviderFound:
            self = .noProviderFound
        case ConstantCode.baseURLNotFound:
            self = .baseURLNotFound
        case ConstantCode.endPointUndefined:
            self = .endPointUndefined
        case ConstantCode.jsonParsing:
            self = .jsonParsing
        default:
            return nil
        }
    }

    public init?(json: [String: Any]) {
        return nil
    }

    // MARK: - Variables
    public var code: Int? {
        switch self {
        case .undefined:
            return ConstantCode.undefined
        case .noNetwork:
            return ConstantCode.noNetwork
        case .noProviderFound:
            return ConstantCode.noProviderFound
        case .baseURLNotFound:
            return ConstantCode.baseURLNotFound
        case .endPointUndefined:
            return ConstantCode.endPointUndefined
        case .jsonParsing:
            return ConstantCode.jsonParsing
        case .http(let error):
            return error.code
        }
    }

    public var message: String? {
        switch self {
        case .http(let error):
            return error.message
        default:
            return nil
        }
    }

    public var description: String? {
        switch self {
        case .http(let error):
            return error.description
        default:
            return nil
        }
    }
}
