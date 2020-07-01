//
//  File.swift
//  
//
//  Created by Talish George on 01/07/20.
//

import Foundation
import Alamofire

/// Class for check Connectivity
final public class Connectivity {
    
    /// Check network reachable
    static public var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
