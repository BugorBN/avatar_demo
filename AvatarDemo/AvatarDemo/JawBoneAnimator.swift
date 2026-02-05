//
//  JawBoneAnimator.swift
//  AvatarDemo
//
//  Jaw bone-based lip sync for CC3 models
//

import Foundation
import SceneKit

class JawBoneAnimator {
    private weak var jawBone: SCNNode?
    private let configuration: AvatarConfiguration
    
    // Jaw rotation amounts for different mouth shapes (in radians)
    private let jawRotations: [String: Float] = [
        "a": 0.3,      // Wide open (ah)
        "e": 0.15,     // Half open (eh)
        "i": 0.1,      // Slightly open (ee)
        "o": 0.25,     // Open rounded (oh)
        "u": 0.15,     // Pursed (oo)
        "th": 0.2,     // Tongue between teeth
        "s": 0.05,     // Barely open (ss)
        "r": 0.2,      // Open (rr)
        "p": 0.0,      // Closed (pp)
        "f": 0.1,      // Lower lip to teeth (ff)
        "d": 0.2,      // Open (dd)
        "ch": 0.1,     // Slightly open
        "n": 0.15,     // Half open (nn)
        "k": 0.2,      // Open (kk)
        "sil": 0.0     // Closed/silent
    ]
    
    init(rootNode: SCNNode, configuration: AvatarConfiguration) {
        self.configuration = configuration
        self.jawBone = rootNode.childNode(withName: "CC_Base_JawRoot", recursively: true)
        
        if jawBone != nil {
            print("✅ JawBoneAnimator: Found jaw bone")
        } else {
            print("❌ JawBoneAnimator: Jaw bone not found!")
        }
    }
    
    /// Animate jaw bone for a sequence of syllables
    func animateSyllables(_ syllables: [String], totalDuration: TimeInterval) {
        guard let jawBone = jawBone else {
            print("❌ Cannot animate: jaw bone not found")
            return
        }
        
        guard !syllables.isEmpty else { return }
        
        let syllableDuration = totalDuration / Double(syllables.count)
        
        // Create animation sequence
        var actions: [SCNAction] = []
        
        for syllable in syllables {
            let rotation = jawRotations[syllable.lowercased()] ?? 0.15
            
            // Rotate jaw open
            let openAction = SCNAction.rotateTo(
                x: CGFloat(rotation),
                y: 0,
                z: 0,
                duration: syllableDuration * 0.3
            )
            openAction.timingMode = .easeOut
            
            // Hold briefly
            let holdAction = SCNAction.wait(duration: syllableDuration * 0.4)
            
            // Return to closed
            let closeAction = SCNAction.rotateTo(
                x: 0,
                y: 0,
                z: 0,
                duration: syllableDuration * 0.3
            )
            closeAction.timingMode = .easeIn
            
            actions.append(contentsOf: [openAction, holdAction, closeAction])
        }
        
        // Run the sequence
        let sequence = SCNAction.sequence(actions)
        jawBone.runAction(sequence)
        
        print("🎬 Animating jaw for \(syllables.count) syllables over \(totalDuration)s")
    }
    
    /// Simple open/close animation for testing
    func testAnimation() {
        guard let jawBone = jawBone else { return }
        
        let open = SCNAction.rotateTo(x: 0.3, y: 0, z: 0, duration: 0.3)
        let close = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.3)
        let sequence = SCNAction.sequence([open, close, open, close])
        
        jawBone.runAction(sequence)
        print("🎬 Running test jaw animation")
    }
}
