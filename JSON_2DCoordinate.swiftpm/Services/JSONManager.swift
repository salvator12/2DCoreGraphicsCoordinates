//
//  File.swift
//
//
//  Created by Yehezkiel Salvator Christanto on 05/07/24.
//

import Foundation
import SwiftUI
import CoreGraphics

class JSONManager: ObservableObject {
    @Published var CAcoordinates = [Coordinates]()
    @Published var TWcoordinates = [Coordinates]()
    @Published var CAPath = Path()
    
    // Function to fetch data from the JSON file
    func fetchDataCA() {
        guard let url = Bundle.main.url(forResource: "CA_Keypoints", withExtension: "json") else {
            print("json file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("data: \(data)")
            let coordinates = try JSONDecoder().decode([Coordinates].self, from: data)
            DispatchQueue.main.async { [weak self] in
                self?.CAcoordinates = coordinates
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func fetchDataTW() {
        guard let url = Bundle.main.url(forResource: "TW_Keypoints", withExtension: "json") else {
            print("json file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("data: \(data)")
            let coordinates = try JSONDecoder().decode([Coordinates].self, from: data)
            DispatchQueue.main.async { [weak self] in
                self?.TWcoordinates = coordinates
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func normalizedCAKeypoints() {
        
    }
    
    func normalizedTWKeypoints() {
        
    }
}
