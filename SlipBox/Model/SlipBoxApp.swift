//
//  SlipBoxApp.swift
//  SlipBox
//
//  Created by Jacek Kosinski U on 22/06/2023.
//

import SwiftUI

@main
struct SlipBoxApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active: print("app became active")
            case .background: do {
                persistenceController.save()
                print("app went to background")
            }
            case .inactive: print("app became inactive")
            @unknown default:
                print("app became somwhere in space")
            }
        }
        .commands {
            CommandGroup(replacing: .saveItem) {
                Button("Save"){
                    persistenceController.save()
                }
                .keyboardShortcut("S",modifiers: [.command])
            }
        }
    }
}
