//
//  ViewCodeProtocol.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//

protocol ViewCodeProtocol {
    func setup()
    func addSubviews()
    func setupConstraints()
}

extension ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }
}
