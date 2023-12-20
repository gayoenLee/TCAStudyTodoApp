//
//  StandingCoffeeApp.swift
//  StandingCoffee
//
//  Created by 이은호 on 2023/12/05.
//

import SwiftUI
import ComposableArchitecture

@main
struct StandingCoffeeApp: App {
    var body: some Scene {
        WindowGroup {
            MainMemoView(
                store: Store(initialState: MemoFeature.State()){
                    MemoFeature()._printChanges()
                }
            )
        }
    }
}
