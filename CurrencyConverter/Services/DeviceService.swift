//
//  DeviceService.swift
//  CurrencyConverter
//
//  Created by Irina on 18.08.2025.
//

import UIKit

enum Device {
    static var width = CGFloat()
    static var isIpad = UIDevice().userInterfaceIdiom == .pad
    static var baseInset = Device.isIpad ? 30.0 : 20.0
}

class DeviceService {
    static var keyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        for scene in allScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                
                return window
            }
        }
        
        return nil
    }
    
     static func setDeviceParametres() {
        let size = keyWindow?.bounds.size ?? CGSize(width: 0, height: 0)
        Device.width = size.width
    }
}
