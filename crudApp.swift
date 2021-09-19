//
//  crudApp.swift
//  crud
//
//  Created by user on 15/09/2021.
//

import SwiftUI

@main
struct crudApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
