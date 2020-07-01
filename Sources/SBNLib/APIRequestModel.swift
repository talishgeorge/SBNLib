//
//  APIRequestModel.swift
//  WeatherForecast
//
//  Created by Talish George on 07/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Alamofire
import UIKit

/// API Request Model
public struct APIRequestModel {
    
    public init(url: URL?, httpMethod: HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: [String: String]?) {
        self.url = url
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        
    }
    
    public var url: URL?
    public var httpMethod: HTTPMethod = .get
    public var parameters: [String: Any]?
    public var encoding: ParameterEncoding = JSONEncoding.default
    public var headers: [String: String]?
}
