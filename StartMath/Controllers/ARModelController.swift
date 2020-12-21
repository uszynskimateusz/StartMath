//
//  ARModelController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 21/12/2020.
//

import UIKit
import SceneKit
import ARKit

class ARModelController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    var itemArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    //MARK: - Rendering Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addItem(at: hitResult)
            }
        }
    }
    
    func addItem(at location: ARHitTestResult) {
        let itemScene = SCNScene(named: "arModels/apple.scn")
        
        if let itemNode = itemScene?.rootNode.childNode(withName: "Apple", recursively: true) {
            itemNode.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y + itemNode.boundingSphere.radius,
                location.worldTransform.columns.3.z)
            
            itemArray.append(itemNode)
            
            sceneView.scene.rootNode.addChildNode(itemNode)
        }
    }
}
