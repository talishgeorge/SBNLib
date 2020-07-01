//
//  Headers.swift
//  WeatherForecast
//
//  Created by Talish George on 07/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

/// API Header keys Model
struct APIHeaderKeys {
    static let accept = "Accept"
    static let contentType = "Content-Type"
    static let acceptLanguage = "Accept-Language"
    static let charSet = "charset"
}

/// API Header  Model
struct APIHeaders {
    
    /// Common Header
    static var common: [String: String] {
        let language = "en"
        return [
                APIHeaderKeys.accept: "application/json",
                APIHeaderKeys.contentType: "application/json",
                APIHeaderKeys.acceptLanguage: language
               ]
    }
    
    /// Generic header
    static var generic: [String: String] {
        let language = "en"
        return [
                APIHeaderKeys.accept: "application/json",
                APIHeaderKeys.contentType: "application/json",
                APIHeaderKeys.acceptLanguage: language
               ]
    }
}
