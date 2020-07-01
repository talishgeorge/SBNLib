//
//  RequestHandler.swift
//  WeatherForecast
//
//  Created by Talish George on 07/06/20.
//  Copyright © 2020 Talish George. All rights reserved.
//

import Alamofire
import UIKit


public typealias RequestHandlerCompletionBlock = (_ resoponse: ([String: Any])) -> Void
public typealias FailureBlock = (_ error: Error?) -> Void

public class RequestHandler {
    
    /// Shared variable
    public static var sharedRequestHandler: RequestHandler = {
        let requestHandler = RequestHandler()
        return requestHandler
    }()
    
    /// Return shared request handler
    public class func shared() -> RequestHandler {
        return sharedRequestHandler
    }
    
    /// API Request
    /// - Parameters:
    ///   - requestModel:APIRequestModel
    ///   - success:response
    public func request(requestModel: APIRequestModel,
                        success: @escaping ( _ response: DataResponse<Any>) -> Void) {
        let sessionManager: Alamofire.SessionManager
        sessionManager = Alamofire.SessionManager.default
        if let baseURL = requestModel.url {
            sessionManager.request(baseURL, method: requestModel.httpMethod, parameters: requestModel.parameters, encoding: requestModel.encoding, headers: requestModel.headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    success(response)
            }
        }
    }
    
    public static func configureRequest(url: URL, success: @escaping RequestHandlerCompletionBlock, failure: @escaping FailureBlock) {
        let requestModel = APIRequestModel(url: url,
                                           httpMethod: .get,
                                           parameters: nil,
                                           encoding: URLEncoding.default,
                                           headers: nil)
        RequestHandler.shared().request(requestModel: requestModel) { response in
            self.handleResponseJSON(response, success: success, failure: failure)
        }
    }
    
    /// Handle JSON response from API
    /// - Parameters:
    ///   - response:The server's response to the URL request.
    ///   - success: SuccessCompletionBlock
    ///   - failure: FailureBlock
    public static func handleResponseJSON(_ response: DataResponse<Any>, success: @escaping RequestHandlerCompletionBlock, failure: @escaping FailureBlock) {
        switch response.result {
        case .success:
            if let json = response.result.value as? [String: Any] {
                success(json)
            } else {
                extractErrorValues(response: response)
            }
        case .failure(let error):
            guard let code = response.response?.statusCode else {
                _ = CommonErrorsUtility(jsonData: response.data, withOption: .mutableContainers)
                print("Invalid status code")
                failure(nil)
                return
            }
            let errorHandler = CommonErrorsUtility(jsonData: response.data, withOption: .mutableContainers)
            let customError = NSError(domain: "", code: errorHandler.errorCode ?? code, userInfo: [ NSLocalizedDescriptionKey: error.localizedDescription ]) as Error
            _ = ErrorProvider(handler: errorHandler)
            extractErrorValues(response: response)
            failure(customError)
        }
    }
    
    /// Error for each case
    /// - Parameter error: Alamofire Error type
    public static func extractError(_ error: AFError) {
        switch error {
        case .invalidURL(let url):
            print("Invalid URL: \(url) - \(error.localizedDescription)")
        case .parameterEncodingFailed(let reason):
            print("Parameter encoding failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        case .multipartEncodingFailed(let reason):
            print("Multipart encoding failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        case .responseValidationFailed(let reason):
            print("Response validation failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
            
            switch reason {
            case .dataFileNil, .dataFileReadFailed:
                print("Downloaded file could not be read")
            case .missingContentType(let acceptableContentTypes):
                print("Content Type Missing: \(acceptableContentTypes)")
            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
            case .unacceptableStatusCode(let code):
                print("Response status code was unacceptable: \(code)")
            }
        case .responseSerializationFailed(let reason):
            print("Response serialization failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        }
    }
    
    /// Show error based on response
    /// - Parameter response:The server's response to the URL request.
    public static func extractErrorValues(response: DataResponse<Any>) {
        guard case let .failure(error) = response.result else { return }
        
        if let error = error as? AFError {
            extractError(error)
            print("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = error as? URLError {
            print("URLError occurred: \(error)")
        } else {
            print("Unknown error: \(error)")
        }
    }
}
