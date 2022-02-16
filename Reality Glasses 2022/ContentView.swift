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
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // create sphere mesh
        let sphereMesh = MeshResource.generateSphere(radius: 0.075)
        
        // create sphere entity
        let sphereEntity = ModelEntity(mesh: sphereMesh)
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
        
        // adding box to the face anchor
        faceAnchor.addChild(createSphere(y: 0.25))
        
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

