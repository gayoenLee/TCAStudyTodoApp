//
//  Memo.swift
//  StandingCoffee
//
//  Created by 이은호 on 2023/12/06.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct Memofff {
    struct State: Equatable, Identifiable {
        var id: UUID = UUID()
        var contetns: String
        
    }
    
    enum Action {
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            }
            
        }
    }
}

struct MemoView: View {
    let store: StoreOf<Memofff>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Text("메모1개")
                Text("\(viewStore.contetns)")
                
                Spacer()
                
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.horizontal)
            .listRowBackground(Color(.systemGray6))
        }
    }
}
