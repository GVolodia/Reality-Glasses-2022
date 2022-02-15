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
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

