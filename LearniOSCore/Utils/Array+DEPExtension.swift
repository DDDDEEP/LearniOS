//
// Array+DEPExtension.swift
// Pods
//
// Created by DEEP on 2024/1/22
// Copyright © 2024 DEEP. All rights reserved.
//
        

import Foundation

extension Array {
    public subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
