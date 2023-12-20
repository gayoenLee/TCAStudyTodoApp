//
//  WritingMemo.swift
//  StandingCoffee
//
//  Created by 이은호 on 2023/12/05.
//

import ComposableArchitecture
import SwiftUI 

@Reducer
struct WritingMemoFeature {
    struct State: Equatable {
        var memo: Memo
       
    }
    
    enum Action {
        case saveMemoTapped
        case cancelMemoTapped
        case filledContents(String)
        case delegate(Delegate)
        
        enum Delegate {
            //case cancel
            case saveMemo(Memo)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .saveMemoTapped:
                //return .send(.delegate(.saveMemo(state.memo)))
                return .run { [memo = state.memo] send in
                    await send(.delegate(.saveMemo(memo)))
                    await self.dismiss()
                }
            case .cancelMemoTapped:
                //return .send(.delegate(.cancel))
                return .run { _ in await self.dismiss() }
            case let .filledContents(contents):
                state.memo.title = contents
                return .none
            case .delegate:
                return .none
            }
                
        }
    }
}

struct WritingMemoView: View {
    let store: StoreOf<WritingMemoFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewstore in
            Form {
                TextField("내용", text: viewstore.binding(get: \.memo.title, send: { .filledContents($0)}))
                Button("Save") {
                    viewstore.send(.saveMemoTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        viewstore.send(.cancelMemoTapped)
                    }
                }
            }
        }
    }
}
