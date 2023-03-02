//
//  main.swift
//  TestCombine
//
//  Created by IDP on 2023/03/02.
//

import Foundation
import Combine


//MARK: - 여러개의 Future Publisher
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
        publisher.append(
            inputFuture(msg: input))
    }
}

// 구독
for i in 0...2 {
    _ = publisher[i].sink { complete in
        print("결과 = \(complete)")
    } receiveValue: { value in
        print("receive Value = \(value)")
    }
}


//MARK: - Property Wrapper 사용
private var cancellables = Set<AnyCancellable>()

class PublisherModel {
    @Published var msg = ""

    init(msg: String = "") {
        self.msg = msg
    }
}

// Published 프로퍼티를 가진 객체 생성 및 구독
var model:PublisherModel?
for _ in 0...2 {
    if let input = readLine() {
        model = PublisherModel(msg: input)
        model?.$msg.sink { value in
            print("receiveValue: \(value)")
        }
        .store(in: &cancellables)
    }
}

// 해제
for pub in cancellables {
    pub.cancel()
}


//MARK: - Subject
let passThroughSubject = PassthroughSubject<String, Never>()
let subscriber = passThroughSubject
    .sink { value in
    print("receiveValue = \(value)")
}

for _ in 0...2 {
    if let input = readLine() {
        passThroughSubject.send(input)
    }
}


//MARK: - Scheduler
//receive(on:) - downstream의 실행 컨텍스트의 영역 변경
//subscribe(on:) - upstream의 실행 컨텍스트의 영역 변경
private var isRun = true

let globalPassThroughSubject = PassthroughSubject<String, Never>()
let globalSubscriber = globalPassThroughSubject
    .sink { value in
        print("\(value) = \(Thread.isMainThread)")
    }

globalPassThroughSubject.send("isMain")
DispatchQueue.global().async {
    globalPassThroughSubject.send("isMain")
}

while isRun {
    if let input = readLine() {
        isRun = input.isEmpty ? false : true
    }
    RunLoop.current.run(until: Date().addingTimeInterval(0.1))
}
//dispatchMain()
