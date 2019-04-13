//
//  MenuItemInteractionHandler.swift
//  Twilight
//
//  Created by Chirag Ramani on 13/04/19.
//  Copyright © 2019 Chirag Ramani. All rights reserved.
//

import Cocoa

/// MenuItemInteractionHandler: Handles the toggling of the dark mode.
final class MenuItemInteractionHandler {
  /// Constants
  private enum Constants {
    static var menuBarButtonIconImage: NSImage? = {
      return NSImage(named: NSImage.Name("menuBarButtonIcon"))
    }()
    static var fadeOutDuration: TimeInterval {
      return 1.25
    }
    static var darkModeToggleScript: String {
      return """
      tell application "System Events"
        tell appearance preferences
          set dark mode to not dark mode
        end tell
      end tell
      """
    }
  }
  /// NSStatusItem visible on the System's Menu Bar.
  lazy private var statusItem: NSStatusItem = {
    return NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  }()
  
  /// A Boolean to track the status of the transitions.
  private var isCurrentTransitionInProgress = false
  private var overlayWindows: [NSWindow] = []
  
  func applicationDidFinishLaunching() {
    configureStatusItem()
  }
  
  private func configureStatusItem() {
    guard let statusItemButton = statusItem.button else {
      fatalError("Status Item button should not be nil.")
    }
    statusItem.behavior = [.terminationOnRemoval]
    statusItemButton.target = self
    statusItem.isVisible = true
    statusItemButton.action = #selector(didTapOnStatusBarButton(_:))
    statusItemButton.image = Constants.menuBarButtonIconImage
  }
  
  @objc private func didTapOnStatusBarButton(_: NSStatusBarButton) {
    animateTheme()
  }
  
  private func animateTheme() {
    guard !isCurrentTransitionInProgress else { return }
    isCurrentTransitionInProgress = true
    addOverlaysOnVisibleWindows()
    toggleDarkMode()
    fadeOutOverlayWindows()
  }
  
  private func addOverlaysOnVisibleWindows() {
    overlayWindows = NSScreen.screens.map { $0.addOverlayWindow() }
  }
  
  private func toggleDarkMode() {
    NSAppleScript(source: Constants.darkModeToggleScript)?.executeAndReturnError(nil)
  }
  
  private func fadeOutOverlayWindows() {
    NSAnimationContext.runAnimationGroup({ context in
      context.duration = Constants.fadeOutDuration
      self.overlayWindows.forEach {
        $0.animator().alphaValue = 0
      }
    }, completionHandler: {
      self.overlayWindows.forEach {
        $0.resignKey()
        $0.close()
      }
      self.overlayWindows.removeAll()
      self.isCurrentTransitionInProgress = false
    })
  }
}

