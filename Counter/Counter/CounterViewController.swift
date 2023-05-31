//
//  CounterViewController.swift
//  Counter
//
//  Created by 윤병일 on 2023/06/01.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class CounterViewController : UIViewController, View {
    
    // MARK: - Property
    private let increaseButon : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    private let decreaseButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        return button
    }()
    
    private let valueLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let indicatorView = UIActivityIndicatorView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - Functions
    
    private func setUI() {
        [increaseButon, decreaseButton, valueLabel, indicatorView].forEach {
            view.addSubview($0)
        }
        
        valueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        decreaseButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        increaseButon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-50)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bind(reactor: CounterViewReactor) {
        
        // Action
        increaseButon.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.value }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
