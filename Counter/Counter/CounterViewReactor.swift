//
//  CounterViewReactor.swift
//  Counter
//
//  Created by 윤병일 on 2023/06/01.
//

import ReactorKit
import RxSwift

final class CounterViewReactor : Reactor { //Reactor를 채택하면 Action, Mutation, State에 대해서 정의해주어야하고 initialState가 필요하다.
    
    enum Action {
        case increase
        case decrease
    }
    
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    struct State {
        var value : Int
        var isLoading: Bool
    }
    
    let initialState: State
    
    // MARK: - Init
    init() {
        self.initialState = State(value: 0, isLoading: false)
    }
    
    // MARK: - Functions
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase :
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .decrease :
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .increaseValue :
            state.value += 1
        case .decreaseValue :
            state.value -= 1
        case .setLoading(let isLoading) :
            state.isLoading = isLoading
        }
        
        return state
    }
}
