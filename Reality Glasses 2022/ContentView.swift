//
//  ContentView.swift
//  Reality Glasses 2022
//
//  Created by notwo on 2/15/22.
//
import ARKit
import SwiftUI
import RealityKit



struct ContentView : View {
    var body: some View {
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return AnyView(ViewOne())
        }
        
        return AnyView(ViewTwo())
    }
}



struct ViewOne : View {
    var body: some View {
        Text("Sorry, face tracking configuration is not supported by your device.").font(.title)
    }
}

struct ViewTwo : View {
    var body: some View {
        
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func createBox() -> Entity {
        // create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        // create entity based on mesh
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    func createCircle(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // create circle mesh
        let circleMesh = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // create material
        let circleMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        
        // create circle entity
        let circleEntity = ModelEntity(mesh: circleMesh, materials: [circleMaterial])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01
        
        
        return circleEntity
    }
    
    func createSphere(x: Float = 0,
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
    
    func makeUIView(context: Context) -> ARView {
        // creating AR view
        let arView = ARView(frame: .zero)
        
        // creating face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // run face tracking session
        arView.session.run(configuration, options: [])
        
        // create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        // adding circles to the face anchor
        faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(createSphere(z: 0.06, radius: 0.025))
        
        // add face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

