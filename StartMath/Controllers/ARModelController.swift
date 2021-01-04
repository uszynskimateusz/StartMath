//
//  ARModelController.swift
//  StartMath
//
//  Created by Mateusz Uszyński on 21/12/2020.
//

import UIKit
import SceneKit
import ARKit

enum ARMode: String {
    case showing = "pokazywanie"
    case measurement = "mierzenie"
}

class ARModelController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    var itemArray = [SCNNode]()
    var maxItem: Int = 0
    var counter = 0
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    var type: ARMode = .showing
    var itemSCNScene = ""
    var itemChildNode = ""
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNaviController()
        
        setSceneView()
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
    
    //MARK: - Update UI Methods
    func updateNaviController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setSceneView() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    //MARK: - Touch Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
        }
        
        if let touch = touches.first?.location(in: sceneView) {
            guard let query = sceneView.raycastQuery(from: touch, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return }
            
            let results = sceneView.session.raycast(query)
            
            if let hitResult = results.first {
                switch type {
                case .showing:
                    if counter < maxItem {
                        addItem(at: hitResult)
                        counter += 1
                        navigationController?.navigationBar.topItem?.title = "Umieczono przedmioty: \(counter)"
                    }
                case .measurement:
                    addDot(at: hitResult)
                }
            }
        }
    }
    
    //MARK: Liczby
    func addItem(at location: ARRaycastResult) {
        let itemScene = SCNScene(named: itemSCNScene)
        
        if let itemNode = itemScene?.rootNode.childNode(withName: itemChildNode, recursively: true) {
            itemNode.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y,
                location.worldTransform.columns.3.z)
            
            itemArray.append(itemNode)
            sceneView.scene.rootNode.addChildNode(itemNode)
        }
    }
    
    //MARK: Długości
    func addDot(at hitResult: ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.01)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            updateText()
        }
    }
    
    func calculateDistance(from start: SCNNode, to end: SCNNode) -> Float {
        let x = end.position.x - start.position.x
        let y = end.position.y - start.position.y
        let z = end.position.z - start.position.z
        let distance = abs(sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))
        
        return distance
    }
    
    func updateText() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = calculateDistance(from: start, to: end)
        let textString = String(format:"%.2f m", distance)
        
        let textGeometry = SCNText(string: textString, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode.removeFromParentNode()
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(
            end.position.x - 0.05,
            end.position.y + 0.05,
            end.position.y)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
