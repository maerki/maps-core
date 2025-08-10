/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public
 *  License, v. 2.0. If a copy of the MPL was not distributed with this
 *  file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 *  SPDX-License-Identifier: MPL-2.0
 */

import Foundation
import UIKit
@_exported import MapCoreSharedModule

/// An anchor that links a map coordinate to a screen position for AutoLayout
@MainActor
public class MCMapAnchor: NSObject {
    
    /// The coordinate that this anchor represents
    public var coordinate: MCCoord {
        didSet {
            updateScreenPosition()
        }
    }
    
    /// The current screen position of the coordinate
    private(set) var screenPosition: CGPoint = .zero
    
    /// The map view this anchor belongs to
    weak var mapView: MCMapView?
    
    /// Internal anchor view for layout constraints
    private let anchorView: UIView
    
    /// Center X layout anchor
    public var centerXAnchor: NSLayoutXAxisAnchor {
        anchorView.centerXAnchor
    }
    
    /// Center Y layout anchor  
    public var centerYAnchor: NSLayoutYAxisAnchor {
        anchorView.centerYAnchor
    }
    
    /// Leading layout anchor
    public var leadingAnchor: NSLayoutXAxisAnchor {
        anchorView.leadingAnchor
    }
    
    /// Trailing layout anchor
    public var trailingAnchor: NSLayoutXAxisAnchor {
        anchorView.trailingAnchor
    }
    
    /// Top layout anchor
    public var topAnchor: NSLayoutYAxisAnchor {
        anchorView.topAnchor
    }
    
    /// Bottom layout anchor
    public var bottomAnchor: NSLayoutYAxisAnchor {
        anchorView.bottomAnchor
    }
    
    /// Initialize an anchor with a coordinate
    /// - Parameter coordinate: The map coordinate for this anchor
    init(coordinate: MCCoord) {
        self.coordinate = coordinate
        self.anchorView = UIView()
        super.init()
        
        // Configure the anchor view
        anchorView.translatesAutoresizingMaskIntoConstraints = false
        anchorView.isUserInteractionEnabled = false
        anchorView.backgroundColor = .clear
        anchorView.isHidden = true // Hidden but still participates in layout
    }
    
    /// Update the screen position based on current coordinate and map view state
    func updateScreenPosition() {
        guard let mapView = mapView else { return }
        
        // Convert coordinate to screen position using the map camera
        let camera = mapView.camera
        
        // Convert to screen coordinates
        let screenCoord = camera.coordToViewPosition(coordinate)
        
        guard let screenCoord = screenCoord else {
            // Coordinate is not visible, position offscreen
            screenPosition = CGPoint(x: -10000, y: -10000)
            updateAnchorViewPosition()
            return
        }
        
        // Convert from map view coordinates to screen coordinates
        let newPosition = CGPoint(
            x: CGFloat(screenCoord.x),
            y: CGFloat(screenCoord.y)
        )
        
        screenPosition = newPosition
        updateAnchorViewPosition()
    }
    
    /// Update the anchor view's position constraints
    private func updateAnchorViewPosition() {
        guard let mapView = mapView, anchorView.superview == mapView else { return }
        
        // Remove existing position constraints
        anchorView.constraints.forEach { constraint in
            if constraint.firstAttribute == .centerX || constraint.firstAttribute == .centerY {
                constraint.isActive = false
            }
        }
        
        // Add new position constraints
        NSLayoutConstraint.activate([
            anchorView.centerXAnchor.constraint(equalTo: mapView.leadingAnchor, constant: screenPosition.x),
            anchorView.centerYAnchor.constraint(equalTo: mapView.topAnchor, constant: screenPosition.y),
            anchorView.widthAnchor.constraint(equalToConstant: 0),
            anchorView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    /// Add this anchor to a map view
    func addToMapView(_ mapView: MCMapView) {
        self.mapView = mapView
        mapView.addSubview(anchorView)
        updateScreenPosition()
    }
    
    /// Remove this anchor from its map view
    func removeFromMapView() {
        anchorView.removeFromSuperview()
        self.mapView = nil
    }
}