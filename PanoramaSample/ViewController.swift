//
//  ViewController.swift
//  PanoramaSample
//
//  Created by Kohei Niimi on 2017/08/30.
//  Copyright © 2017年 Kohei Niimi. All rights reserved.
//

import UIKit
import Metal
import MetalScope

class ViewController: UIViewController {

    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create MTLDevice")
        }
        return device
    }()

    weak var panoramaView: PanoramaView?
    
    private func loadPanoramaView() {
        #if arch(arm) || arch(arm64)
            let panoramaView = PanoramaView(frame: view.bounds, device: device)
        #else
            let panoramaView = PanoramaView(frame: view.bounds) // iOS Simulator
        #endif
        panoramaView.setNeedsResetRotation()
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panoramaView)
        
        // fill parent view
        let constraints: [NSLayoutConstraint] = [
            panoramaView.topAnchor.constraint(equalTo: view.topAnchor),
            panoramaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panoramaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panoramaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        // double tap to reset rotation
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: panoramaView, action: #selector(PanoramaView.setNeedsResetRotation(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        panoramaView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        self.panoramaView = panoramaView
        
        panoramaView.load(#imageLiteral(resourceName: "vr"), format: .mono)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        loadPanoramaView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        panoramaView?.updateInterfaceOrientation(with: coordinator)
    }

}

