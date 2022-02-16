//
//  ContentView.swift
//  Reality Glasses 2022
//
//  Created by notwo on 2/15/22.
//
import ARKit
import SwiftUI
import RealityKit

enum GlassColors: String, CaseIterable {
    case red = "red"
    case green = "green"
    case black = "black"
}

struct ContentView : View {
    
    var body: some View {
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return AnyView(ErrorView())
        }
        
        return AnyView(NormalView())
    }
}



struct ErrorView : View {
    var body: some View {
        Text("Sorry, face tracking configuration is not supported by your device.").font(.title)
    }
}

struct NormalView : View {
    @State private var glassColor: GlassColors = .black
    
    var body: some View {
        VStack {
            Section() {
                ARViewContainer(glassColor: glassColor).edgesIgnoringSafeArea(.all)
            }
            // create colors picker
                Picker("", selection: $glassColor) {
                    ForEach(GlassColors.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var glassColor: GlassColors
    
    
    
    func makeUIView(context: Context) -> ARView {
        // creating AR view
        let arView = ARView(frame: .zero)
        
        // creating face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // run face tracking session
        arView.session.run(configuration, options: [])
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // clearing the scene
        uiView.scene.anchors.removeAll()
        
        switch glassColor {
        case .red:
            uiView.scene.anchors.append(createGlasses(color: .red))
        case .green:
            uiView.scene.anchors.append(createGlasses(color: .green))
        case .black:
            uiView.scene.anchors.append(createGlasses(color: .black))
        }
        
    }
    
    // MARK: - Methods
    
    private func createBox() -> Entity {
        // create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        // create entity based on mesh
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    private func createCircle(x: Float = 0, y: Float = 0, z: Float = 0, color: UIColor) -> Entity {
        // create circle mesh
        let circleMesh = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // create material
        var circleMaterial = SimpleMaterial(color: color, isMetallic: false)
        if color == .black {
        circleMaterial.baseColor = MaterialColorParameter.color(color.withAlphaComponent(0.95))
        } else {
            circleMaterial.baseColor = MaterialColorParameter.color(color.withAlphaComponent(0.5))
        }
        
        // create circle entity
        let circleEntity = ModelEntity(mesh: circleMesh, materials: [circleMaterial])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01
        
        
        return circleEntity
    }
    
    private func createGlasses(color: UIColor) -> AnchorEntity {
        // create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.06, color: color))
        faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.06, color: color))
        faceAnchor.addChild(createSphere(z: 0.06, radius: 0.025))
        
        return faceAnchor
    }
    
    private func createSphere(x: Float = 0,
                      y: Float = 0,
                      z: Float = 0,
                      color: UIColor = .red,
                      radius: Float = 0.05) -> Entity {
        // create sphere mesh
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let sphereMaterial = SimpleMaterial(color: color, isMetallic: false)
        
        // create sphere entity
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        sphereEntity.position = SIMD3(x, y, z)
        
        return sphereEntity
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

