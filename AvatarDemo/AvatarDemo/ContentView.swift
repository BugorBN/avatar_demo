//
//  ContentView.swift
//  AvatarDemo
//
//  Created by Sergio on 15.06.24.
//

import SwiftUI
import SceneKit
import SpriteKit
import AVFoundation

struct ContentView: View {
    @State private var cameraPosition: SCNVector3 = SCNVector3(0, 0, 5)
    @State private var meshPosition: SCNVector3 = SCNVector3(0, 0, 0)
    @State private var meshRotation: SCNVector3 = SCNVector3(0, 0, 0)
    @State private var meshScale: SCNVector3 = SCNVector3(0.2, 0.2, 0.2)
    @State private var inputText: String = "Do you think this is ok?"

    // Pre-defined phrases from AvatarAI
    let phrases = [
        "Hello! I'm your AR avatar assistant.",
        "Welcome to the world of augmented reality!",
        "Face tracking technology is amazing!",
        "I can speak and animate in real-time.",
        "Let's explore what AR can do together!",
        "This is the future of human-computer interaction.",
        "I'm learning to express emotions through facial animations.",
        "Technology and creativity combined create magic!"
    ]

    var body: some View {
        VStack {
            SceneViewContainer(cameraPosition: $cameraPosition, meshPosition: $meshPosition, meshRotation: $meshRotation, meshScale: $meshScale, avatarConfiguration: AvatarConfiguration.defaultConfiguration)
                .frame(height: 200)
            
            Spacer()
            HStack {
                Spacer()
                Button("Blink left eye") {
                    NotificationCenter.default.post(name: .avatarChangeShapeKey, object: "vrc_blink_left")
                }
                .padding()
                Spacer()
                Button("Blink right eye") {
                    NotificationCenter.default.post(name: .avatarChangeShapeKey, object: "vrc_blink_right")
                }
                .padding()
                Spacer()
            }
            .padding(.bottom, 20)
            
            HStack {
                Spacer()
                Button("Yes") {
                    NotificationCenter.default.post(name: .avatarPerformHeadNod, object: nil)
                }
                Spacer()
                Button("Nop") {
                    NotificationCenter.default.post(name: .avatarPerformHeadShaking, object: nil)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button("Move Head Right") {
                    NotificationCenter.default.post(name: .avatarMoveHeadRight, object: nil)
                }
                .padding()
                Spacer()
                Button("Move Head Left") {
                    NotificationCenter.default.post(name: .avatarMoveHeadLeft, object: nil)
                }
                .padding()
                Spacer()
            }
            .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                Text("Camera Position: x: \(cameraPosition.x), y: \(cameraPosition.y), z: \(cameraPosition.z)")
                Text("Mesh Position: x: \(meshPosition.x), y: \(meshPosition.y), z: \(meshPosition.z)")
                Text("Mesh Rotation: x: \(meshRotation.x), y: \(meshRotation.y), z: \(meshRotation.z)")
                Text("Mesh Scale: x: \(meshScale.x), y: \(meshScale.y), z: \(meshScale.z)")
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            HStack {
                Button("Speak Random Phrase") {
                    inputText = phrases.randomElement() ?? phrases[0]
                    NotificationCenter.default.post(name: .avatarReadText, object: inputText)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }

            Text("Current: \(inputText)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
        }
    }
}



#Preview {
    ContentView()
}
