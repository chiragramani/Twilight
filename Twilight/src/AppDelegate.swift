//
//  AppDelegate.swift
//  Twilight
//
//  Created by Chirag Ramani on 13/04/19.
//  Copyright © 2019 Chirag Ramani. All rights reserved.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
  /// MenuItemInteractionHandler
  let menuItemInteractionHandler: MenuItemInteractionHandler
  
  /// Sets up the menuItemInteractionHandler.
  override init() {
    menuItemInteractionHandler = MenuItemInteractionHandler()
    super.init()
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    menuItemInteractionHandler.applicationDidFinishLaunching()
  }
}
