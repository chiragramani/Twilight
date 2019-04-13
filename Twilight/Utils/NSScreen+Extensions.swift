//
//  NSScreen+Extensions.swift
//  Twilight
//
//  Created by Chirag Ramani on 13/04/19.
//  Copyright © 2019 Chirag Ramani. All rights reserved.
//

import Cocoa

extension NSScreen {
  var screenshot: NSImage {
    guard let cgImage = CGWindowListCreateImage(frame,
                                                .optionAll,
                                                kCGNullWindowID,
                                                .bestResolution) else {
                                                  fatalError("Error in taking a screenshot.")
    }
    let bitmapImageRepresentation = NSBitmapImageRep(cgImage: cgImage)
    let image = NSImage()
    image.addRepresentation(bitmapImageRepresentation)
    return image
  }
  
  @discardableResult func addOverlayWindow() -> NSWindow {
    let imageView = NSImageView(image: self.screenshot)
    let overlayWindow = NSWindow(contentRect: self.frame,
                                 styleMask: .fullScreen,
                                 backing: .buffered,
                                 defer: false,
                                 screen: self)
    overlayWindow.isReleasedWhenClosed = false
    overlayWindow.level = .floating
    overlayWindow.contentView = imageView
    overlayWindow.ignoresMouseEvents = true
    overlayWindow.makeKeyAndOrderFront(nil)
    return overlayWindow
  }
}
