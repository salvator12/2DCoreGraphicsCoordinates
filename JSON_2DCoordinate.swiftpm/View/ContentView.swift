import SwiftUI
import CoreGraphics

struct ContentView: View {
    @StateObject var jsonManager = JSONManager()
    
    @State var buttonName: KeypointsType = .TW
    var body: some View {
        GeometryReader { geo in
            VStack {
                Path { path in
                    if buttonName == .TW {
                        path.addLines(
                            createTWCGPoint(
                                geo.size.width,
                                height: geo.size.height
                            )
                        )
                    } else {
                        path.addLines(
                            createCACGPoint(
                                geo.size.width,
                                height: geo.size.height
                            )
                        )
                    }
                    
                }
                .stroke(Color.black, lineWidth: 2.0)
                
                Button {
                    if buttonName == .TW {
                        buttonName = .CA
                    } else {
                        buttonName = .TW
                    }
                } label: {
                    Text("Switch to \(buttonName == .TW ? "CA" : "TW") Keypoints")
                }
            }
        }
        
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                jsonManager.fetchDataCA()
                jsonManager.fetchDataTW()
            }
            
        }
    }
    
    func createCACGPoint(_ width: Double, height: Double) -> [CGPoint] {
        var points = [CGPoint]()
        
        // Determine the bounding box of the keypoints
        let minX = jsonManager.CAcoordinates.map { $0.keypoints[0] }.min() ?? 0
        let minY = jsonManager.CAcoordinates.map { $0.keypoints[1] }.min() ?? 0
        let maxX = jsonManager.CAcoordinates.map { $0.keypoints[0] }.max() ?? 0
        let maxY = jsonManager.CAcoordinates.map { $0.keypoints[1] }.max() ?? 0
        
        let boundingBoxWidth = maxX - minX
        let boundingBoxHeight = maxY - minY
        
        
        // Determine the scaling factors
        let scaleX = width / boundingBoxWidth
        let scaleY = height / boundingBoxHeight
        let scale = min(scaleX, scaleY)
        
        // Apply scaling and translation
        let offsetX = (width - boundingBoxWidth * scale) * 0.5 - minX * scale
        let offsetY = (height - boundingBoxHeight * scale) * 0.5 - minY * scale
        
        for keypoints in jsonManager.CAcoordinates {
            let normalizedX = keypoints.keypoints[0] * (scale * 0.8) + offsetX
            let normalizedY = keypoints.keypoints[1] * scale + offsetY
            points.append(
                CGPoint(
                    x: normalizedX,
                    y: normalizedY
                )
            )
        }
        return points
    }
    
    func createTWCGPoint(_ width: Double, height: Double) -> [CGPoint] {
        var points = [CGPoint]()
        
        // Determine the bounding box of the keypoints
        let minX = jsonManager.TWcoordinates.map { $0.keypoints[0] }.min() ?? 0
        let minY = jsonManager.TWcoordinates.map { $0.keypoints[1] }.min() ?? 0
        let maxX = jsonManager.TWcoordinates.map { $0.keypoints[0] }.max() ?? 0
        let maxY = jsonManager.TWcoordinates.map { $0.keypoints[1] }.max() ?? 0
        
        let boundingBoxWidth = maxX - minX
        let boundingBoxHeight = maxY - minY
        
        // Determine the scaling factors
        let scaleX = width  / boundingBoxWidth
        let scaleY = height / boundingBoxHeight
        let scale = min(scaleX, scaleY)
        
        // Apply scaling and translation
        let offsetX = (width - boundingBoxWidth * scale) / 1 - minX * scale
        let offsetY = (height - boundingBoxHeight * scale) / 2.0 - minY * scale
        
        for keypoints in jsonManager.TWcoordinates {
            let normalizedX = keypoints.keypoints[0] * (scale * 0.8) + offsetX
            let normalizedY = keypoints.keypoints[1] * scale + offsetY
            points.append(
                CGPoint(
                    x: normalizedX,
                    y: normalizedY
                )
            )
        }
        return points
    }
}
