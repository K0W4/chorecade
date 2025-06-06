//
//  ViewCodeProtocol.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 06/06/25.
//

protocol ViewCodeProtocol {
    func addSubviews()
    func setupConstraints()
    
    func setup()
}

extension ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }
}
