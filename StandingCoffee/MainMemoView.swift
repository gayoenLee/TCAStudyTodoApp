//
//  ContentView.swift
//  StandingCoffee
//
//  Created by 이은호 on 2023/12/05.
//

import SwiftUI
import ComposableArchitecture

struct Memo: Identifiable, Equatable {
    var id = UUID()
    var title: String
}

@Reducer
struct MemoFeature {
    struct State: Equatable {
        @PresentationState var addMemo: WritingMemoFeature.State?
        @PresentationState var alert: AlertState<Action.Alert>?
        //메모 리스트
        var memos: IdentifiedArrayOf<Memo> = []
    
    }
    
    enum Action {
        case addButtonTapped
        case addMemo(PresentationAction<WritingMemoFeature.Action>)
        case alert(PresentationAction<Alert>)
        case deleteButtonTapped(id: Memo.ID)
        enum Alert: Equatable {
            case confirmDeletion(id: Memo.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addMemo = WritingMemoFeature.State(memo: Memo(id: UUID(), title: ""))
                return .none
            case let .addMemo(.presented(.delegate(.saveMemo(memo)))):
                state.memos.append(memo)
                //delegate이용 전에는 nil을 할당해서 cancel버튼 클릭시 memo추가 feature를 dismiss하고 싶었음. -> delegate이용후 필요 없어짐
                //state.addMemo = nil
                return .none
            case .addMemo:
                return .none
//            case .addMemo(.presented(.delegate(.cancelMemoTapped))):
//                //delegate이용 전에는 nil을 할당해서 cancel버튼 클릭시 memo추가 feature를 dismiss하고 싶었음.
//                state.addMemo = nil
//                return .none
            case .deleteButtonTapped(id: let id):
                state.alert = AlertState{ TextState("삭제하시겠습니까?")} actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("확인")
                    }
                }
                return .none
            case let .alert(.presented(.confirmDeletion(id: id))):
                state.memos.remove(id: id)
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet((\.$addMemo), action: \.addMemo){
           WritingMemoFeature()
        }
        .ifLet(\.$alert, action: \.alert)
//        .forEach(\.memoList, action: \.memoList) {
//            Memo()
//        }
    }
}

struct MainMemoView: View {
    let store: StoreOf<MemoFeature>
    
    var body: some View {
        
        NavigationStack{
            WithViewStore(self.store, observe: \.memos) { viewStore in
                List{
                    ForEach(viewStore.state) { memo in
                        HStack {
                            Text(memo.title)
                            Spacer()
                            Button {
                                viewStore.send(.deleteButtonTapped(id: memo.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(store: self.store.scope(state: \.$addMemo, action: \.addMemo)) {
                    addMemoStore in
                    NavigationStack {
                        WritingMemoView(store: addMemoStore)
                    }
                }
                .alert(store: self.store.scope(
                    state: \.$alert, action: \.alert))
            }
        }
    }
}

struct AddMemoButton: View {
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.purple)
                .frame(width: 100, height: 50)
            
            Button(action: self.action) {
                RoundedRectangle(cornerRadius: 35)
                    .foregroundColor(.clear)
                  .padding(2)
            }
            .frame(width: 90, height: 45)
        }
    }
}

