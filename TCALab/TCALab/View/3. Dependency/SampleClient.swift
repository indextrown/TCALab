//
//  SampleClient.swift
//  TCALab
//
//  Created by 김동현 on 6/26/26.
//

/*
 https://maramincho.tistory.com/127
 Dependencies 사용법
 1. @DependencyClient 가 있는 Model만들기
 2. Extension을 통해서 변수 선언하기
 3. Model에 DependencyKey Protocol 선언하기
 4. TCA Dependencies System에 쓰일 Static변수 설정하기
 5. 필요한 부분에서 활용하기 (현재는 비동기 이면서, 통신 이후에 특정 결과값을 다음 Action을 통해 Send하고 있습니다.)
 */
import Foundation
import ComposableArchitecture

/// Dependency인터페이스: FactClient는 fetch()를 제공한다
/// TCA는 프로토콜 대신 함수 변수(Function Dependency) 를 많이 사용한다.
@DependencyClient
struct FactClient {
    /// 왜 함수를 변수로 만들까?: fetch라는 변수 안에 함수가 들어있다.
    /*
     let client = FactClient(
         fetch: { number in
             "\(number)"
         }
     )
     try await client.fetch(10)
     */
    var fetch: @Sendable (Int) async throws -> String
}

/// TCA의 DIContainer이다
/// @Dependency(\.factClient)로 등록된 값을 찾아온다
extension DependencyValues {
    var factClient: FactClient {
        /// FactClient타입으로 저장된 값을 꺼내라
        get { self[FactClient.self] }
        
        /// 테스트에서 아래처럼 교체할 수 있게 해준다
        /*
         store.dependencies.factClient.fetch = { _ in
             "Mock"
         }
         */
        set { self[FactClient.self] = newValue }
    }
}

/// FactClient를 TCA Dependency System에 등록하는 것이다.
extension FactClient: DependencyKey {
    static let liveValue = FactClient(
        fetch: { number in
            try await Task.sleep(for: .seconds(1))
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://number-trivia.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
    static let testValue = Self()
}


/*
 ① FactClient 생성
        │
        ▼
 @DependencyClient
 struct FactClient {
     var fetch
 }

        │
        ▼
 ② DependencyValues 등록

 extension DependencyValues {
     var factClient
 }

        │
        ▼
 ③ DependencyKey 채택

 extension FactClient: DependencyKey

        │
        ▼
 ④ liveValue 구현

 fetch {
     URLSession...
 }

        │
        ▼
 ⑤ Reducer

 @Dependency(\.factClient)

        │
        ▼
 ⑥ 사용

 try await factClient.fetch(10)
 */
