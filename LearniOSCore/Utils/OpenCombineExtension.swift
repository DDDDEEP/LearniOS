//
// OpenCombineExtension.swift
// Pods
//
// Created by DEEP on 2024/1/28
// Copyright © 2024 DEEP. All rights reserved.
//
        
import Foundation
import OpenCombine

extension Publisher {
    @discardableResult
    public func sinkUntilFinished(
        receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping ((Output) -> Void)
    ) -> Cancellable {
        let subscriber = Subscribers.Sink<Output, Failure>(
            receiveCompletion: receiveCompletion,
            receiveValue: receiveValue
        )
        subscribe(subscriber)
        return subscriber
    }
}

extension Publisher where Failure == Never {
    @discardableResult
    public func sinkUntilFinished(
        receiveValue: @escaping ((Output) -> Void)
    ) -> Cancellable {
        let subscriber = Subscribers.Sink<Output, Failure>(
            receiveCompletion: { _ in },
            receiveValue: receiveValue
        )
        subscribe(subscriber)
        return subscriber
    }
}
