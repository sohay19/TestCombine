//
//  main.swift
//  TestCombine
//
//  Created by IDP on 2023/03/02.
//

import Foundation
import Combine


private var publisher:[Future<String, Never>] = []

// publisher 생성
func inputFuture(msg: String) -> Future<String, Never> {
    return Future<String, Never> { promise in
        promise(.success(msg))
    }
}

// 입력 받기
for _ in 0...2 {
    if let input = readLine() {
        publisher.append(inputFuture(msg: input))
    }
}

// 구독 및 발송
for i in 0...2 {
    _ = publisher[i].sink { complete in
        print("결과 = \(complete)")
    } receiveValue: { value in
        print("receive Value = \(value)")
    }
}
