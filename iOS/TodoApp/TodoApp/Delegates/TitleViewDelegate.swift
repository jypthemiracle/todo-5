//
//  TitleViewDelegate.swift
//  TodoApp
//
//  Created by delma on 2020/04/08.
//  Copyright © 2020 delma. All rights reserved.
//

import Foundation

protocol TitleViewDelegate {
    func presentNewCardView(contents: Contents?, isEdit: Bool, taskId: Int?)
}
