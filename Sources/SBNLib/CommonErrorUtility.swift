//
//  CommonErrorUtility.swift
//  WeatherForecast
//
//  Created by Talish George on 07/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import UIKit

/// Error Keys
private enum ErrorKey: String {
    case errors = "errors",
    code = "code",
    description = "description",
    error = "_errors",
    name = "name",
    errorResponse = "errorResponse",
    errorId = "errorId",
    errorDetails = "errorDetails",
    errorDescription = "error_description",
    errorCode = "error_code",
    cod = "cod",
    message = "message"
    
}

final public class CommonErrorsUtility {
    // MARK: - Properties

     static let shared = CommonErrorsUtility()
     var code: String?
     var errorDescription: String?
     var dictionary: [String: Any]?
     var name: String?
     var errorId: String?
     var logTrackCode: String?
     var errorArray: [[String: Any]]?
     public var errorCode: Int?
     var message: String?
    
    // MARK: - Initilization
    
    /// Decode JSON
    /// - Parameter json: Dictionary
    convenience public init(json: [String: Any]) {
        self.init()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let decodedJson = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictionaryJson = decodedJson as? [String: Any] {
                self.extractErrorValues(dictionaryJson: dictionaryJson)
            }
        } catch {
        }
    }
    
    /// Init
    /// - Parameters:
    ///   - jsonData: Data
    ///   - readingOption: JSONSerialization.ReadingOptions
    convenience public init(jsonData: Data?, withOption readingOption: JSONSerialization.ReadingOptions) {
        self.init()
        guard let data = jsonData else {
            return
        }
        do {
            let decodedJson = try JSONSerialization.jsonObject(with: data, options: readingOption)
            if let dictionaryJson = decodedJson as? [String: Any] {
                errorDescription = dictionaryJson[ErrorKey.errorDescription.rawValue] as? String
                code = dictionaryJson[ErrorKey.errorCode.rawValue] as? String
                errorDescription = dictionaryJson[ErrorKey.errorDescription.rawValue] as? String
                code = dictionaryJson[ErrorKey.errorCode.rawValue] as? String
                self.errorCode = dictionaryJson["cod"] as? Int
                self.message = dictionaryJson[ErrorKey.message.rawValue] as? String
                self.extractErrorValues(dictionaryJson: dictionaryJson)
            }
        } catch {
        }
    }
    
    /// Return Error
    /// - Parameter dictionaryJson:Dictionary
    private func extractErrorValues(dictionaryJson: [String: Any]) {
        errorCode = dictionaryJson[ErrorKey.cod.rawValue] as? Int
        message = dictionaryJson[ErrorKey.message.rawValue] as? String
        if
            let keyString = getErrorKeyString(from: dictionaryJson),
            let errors: [[String: Any]] = dictionaryJson[keyString] as? [[String: Any]] {
            errorArray = errors
            dictionary = dictionaryJson
            if !errors.isEmpty {
                code = errors[0][ErrorKey.code.rawValue] as? String
                name = errors[0][ErrorKey.name.rawValue] as? String
                errorDescription = errors[0][ErrorKey.description.rawValue] as? String
            }
        } else {
            code = ""; name = ""; errorDescription = ""
        }
        guard let errorResponse = dictionaryJson[ErrorKey.errorResponse.rawValue] as? [String: Any] else {
            errorId = ""; logTrackCode = ""
            return }
        errorId = errorResponse[ErrorKey.errorId.rawValue] as? String
    }
    
    /// Return Error as String
    /// - Parameter errorDictionary: Dictionary
    private func getErrorKeyString(from errorDictionary: [String: Any]) -> String? {
        if errorDictionary.keys.contains(ErrorKey.errors.rawValue) {
            return ErrorKey.errors.rawValue
        } else if errorDictionary.keys.contains(ErrorKey.error.rawValue) {
            return ErrorKey.error.rawValue
        } else if errorDictionary.keys.contains(ErrorKey.cod.rawValue) {
            return ErrorKey.cod.rawValue
        } else if errorDictionary.keys.contains(ErrorKey.message.rawValue) {
            return ErrorKey.message.rawValue
        } else {
            return nil
        }
    }
}
