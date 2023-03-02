//
//  main.swift
//  TestCombine
//
//  Created by IDP on 2023/03/02.
//

import Foundation
import Combine


private var inputData = ""


// 데이터 입력
if let input = readLine() {
    inputData = input
}
// 게시자
let publisher = Future<String, Never> { promise in
    promise(.success(inputData))
}
// 구독
let subscriber = publisher.sink { complete in
    print("결과 = \(complete)")
} receiveValue: { value in
    print("receive Value = \(value)")
}
