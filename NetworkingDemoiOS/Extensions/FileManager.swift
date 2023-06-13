//
//  FileManager.swift
//  NetworkingDemoiOS
//
//  Created by Bruno Campos on 6/13/23.
//

import Foundation

public extension FileManager {
  static var documentsDirectoryURL: URL {
    return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
