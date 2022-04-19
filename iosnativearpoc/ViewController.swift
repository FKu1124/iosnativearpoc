//
//  ViewController.swift
//  iosnativearpoc
//
//  Created by Felix Kuhn on 10.03.22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var cityNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new empty scene
        let scene = SCNScene()
        
        // Get city model from file
        // Source: https://www.cgtrader.com/free-3d-models/exterior/cityscape/cartoon-lowpoly-city-free-game-pack
        let cityScene = SCNScene(named: "art.scnassets/Lowpoly_City_Free_Pack.obj")!
        cityNode = cityScene.rootNode
        cityNode.scale = SCNVector3(0.0002, 0.0002, 0.0002)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main)!
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Called when ARKit detectes and adds an anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            NSLog("Anchor detected")
            if imageAnchor.referenceImage.name == "Back" {
            	let size = imageAnchor.referenceImage.physicalSize
                let plane = SCNPlane(width: size.width, height: size.height)
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                plane.cornerRadius = 0.005
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                node.addChildNode(planeNode)
            } else {
                node.addChildNode(cityNode)
            }
        }
        return node
    }

}
