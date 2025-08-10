/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public
 *  License, v. 2.0. If a copy of the MPL was not distributed with this
 *  file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 *  SPDX-License-Identifier: MPL-2.0
 */

import UIKit
import MapCoreSharedModule

/// Example showing how to use MCMapAnchor for AutoLayout with map coordinates
class AnchorExampleViewController: UIViewController {
    
    private lazy var mapView: MCMapView = {
        let mapView = MCMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var pinView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.text = "Zurich"
        label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAnchors()
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(pinView)
        view.addSubview(labelView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pinView.widthAnchor.constraint(equalToConstant: 20),
            pinView.heightAnchor.constraint(equalToConstant: 20),
            
            labelView.heightAnchor.constraint(equalToConstant: 30),
            labelView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupAnchors() {
        // Create a coordinate for Zurich
        let zurichCoord = MCCoord(lat: 47.3769, lon: 8.5417)
        
        // Create an anchor for this coordinate
        let zurichAnchor = mapView.createAnchor(for: zurichCoord)
        
        // Position the pin view at the anchor
        NSLayoutConstraint.activate([
            pinView.centerXAnchor.constraint(equalTo: zurichAnchor.centerXAnchor),
            pinView.centerYAnchor.constraint(equalTo: zurichAnchor.centerYAnchor)
        ])
        
        // Position the label above the pin
        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: zurichAnchor.centerXAnchor),
            labelView.bottomAnchor.constraint(equalTo: zurichAnchor.topAnchor, constant: -10)
        ])
        
        // Center the map on Zurich
        mapView.camera.move(toCenterPositionZoom: zurichCoord, zoom: 10.0, animated: false)
    }
}