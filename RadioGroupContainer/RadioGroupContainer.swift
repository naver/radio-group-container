//
//  RadioGroupContainer.swift
//  RadioGroupContainer
//
//  Created by Naver - Minho on 2020/11/16.
//  Copyright (c) 2020-present NAVER Corp.
//  Apache License v2.0
//

import UIKit

public protocol RadioGroupContainerDelegate: AnyObject {
    func onTouchUpInsideRadioControl<T: Equatable>(_ sender: (control: UIControl, key: T))
}

public class RadioGroupContainer<S: Equatable>: NSObject {
    public weak var delegate: RadioGroupContainerDelegate?
    
    private var itemList = [(control: UIControl, key: S)]()
    /// 라디오 컨트롤이 선택됐을 때, 선택되지 않은 컨트롤들에 수행될 클로저. main 스레드에서 비동기로 수행되기 때문에 UI 작업이 가능하며, 각 컨트롤들에 의존성은 없어야 한다.
    public var deselectedOperation: ((UIControl, S) -> ())?
    /// 이미 선택된 컨트롤을 또 선택했을 때 selection/deselection delegate를 수행할지 여부. default는 true
    public var isAllowedDuplicateSelection: Bool = true
    
    /**
     현재 추가된 Item List. UIControl과 Key값의 튜플의 배열
     
     - Note:
     Array 객체 자신은 복사본 이지만, Array의 값은 원본이므로 변형시 반영됨
     
     - Returns: 현재 추가된 아이템 배열
     */
    public func items() -> [(control: UIControl, key: S)] {
        return Array(itemList)
    }
    
    /**
     현재 추가된 컨트롤 배열
     
     - Note:
     Array 객체 자신은 복사본 이지만, Array의 값은 원본이므로 변형시 반영됨
     
     - Returns: 현재 추가된 컨트롤 배열
     */
    public func controls() -> [UIControl] {
        return itemList.map { $0.control }
    }
    
    /**
     아이템 추가.
     
     
     라디오 컨트롤을 식별할 수 있는 키를 미리 설정해야 한다.
     
     키가 중복되면 추가되지 않음.
     
     - Parameter item: 추가하려는 컨트롤
     - Returns: 아이템 추가 성공 여부
     */
    @discardableResult public func add(_ item: (control: UIControl, key: S)) -> Bool {
        for orgItem in itemList {
            if item.key == orgItem.key {
                return false
            }
        }
        
        item.control.addTarget(self, action: #selector(onTouchUpInsideRadioControl(_:)), for: .touchUpInside)
        
        itemList.append(item)
        
        return true
    }
    
    /**
     key와 일치하는 아이템 삭제
     
     - Parameter key: item에 유일하게 식별할 수 있는 키 값
     */
    public func removeItem(_ key: S) {
        itemList = itemList.filter { (item) -> Bool in
            return item.key != key
        }
    }
    
    /**
     현재 선택된 라디오 컨트롤
     
     - Returns: 없으면 nil 반환
     */
    public func selectedRadioControl() -> UIControl? {
        return itemList.first { (item) -> Bool in
            return item.control.isSelected
        }?.control
    }
    
    /**
     키 값으로 라디오 컨트롤 선택
     
     - Parameter key: 선택할 라디오 컨트롤의 키 값. nil이면 아무것도 선택 안함 상태로 변경
     */
    public func selectRadioControl(_ key: S?) {
        for orgItem in itemList {
            orgItem.control.isSelected = false
        }
        
        if let key = key {
            radioControlWithKey(key)?.isSelected = true
        }
    }
    
    /**
     key값과 일치하는 라디오 컨트롤 반환
     
     - parameters: key 컨트롤을 찾기 위한 키 값
     - Returns: 없으면 nil 반환
     */
    public func radioControlWithKey(_ key: S) -> UIControl? {
        return itemList.first(where: { (item) -> Bool in
            return item.key == key
        })?.control
    }
    
    /**
     control과 인스턴스가 일치하는 라디오 컨트롤의 key 값 반환
     
     - parameters: control 키 값을 찾기위한 컨트롤 객체
     - Returns: 없으면 nil 반환
     */
    public func keyWithRadioControl(_ control: UIControl) -> S? {
        return itemList.first { (item) -> Bool in
            return item.control == control
        }?.key
    }
    
    /**
     모든 control의 selection을 false 시킴
     deselectedOepration이 있으면 비동기로 메인 스레드에서 실행됨
     */
    public func resetSelection() {
        for item in itemList {
            item.control.isSelected = false
            
            if let defaultOperation = deselectedOperation {
                DispatchQueue.main.async {
                    defaultOperation(item.control, item.key)
                }
            }
        }
    }
    
    @objc private func onTouchUpInsideRadioControl(_ sender: UIControl) {
        guard isAllowedDuplicateSelection || sender.isSelected == false else {
            return
        }
        
        var selectedItem: (UIControl, S)?
        
        for orgItem in itemList {
            orgItem.control.isSelected = false
            
            if orgItem.control == sender {
                selectedItem = orgItem
                orgItem.control.isSelected = true
            }
        }
        
        guard let item = selectedItem else {
            return
        }
        
        if let defaultOperation = deselectedOperation {
            for item in itemList.filter({ $0.control != item.0 }) {
                DispatchQueue.main.async {
                    defaultOperation(item.control, item.key)
                }
            }
        }
        
        delegate?.onTouchUpInsideRadioControl(item)
    }
}
