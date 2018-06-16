//
//  ButtonViewElementHandler.swift
//  phyphox
//
//  Created by Jonas Gessner on 12.04.18.
//  Copyright © 2018 RWTH Aachen. All rights reserved.
//

import Foundation

enum ButtonInputDescriptor {
    case buffer(String)
    case value(Double)
    case clear
}

struct ButtonViewElementDescriptor: ViewElementDescriptor {
    let label: String

    let dataFlow: [(input: ButtonInputDescriptor, outputBufferName: String)]
}

private final class ButtonInputElementHandler: ResultElementHandler, ChildlessElementHandler {
    var results = [ButtonInputDescriptor]()

    typealias Result = ButtonInputDescriptor

    func beginElement(attributes: XMLElementAttributes) throws {
    }

    func endElement(with text: String, attributes: XMLElementAttributes) throws {
        let type = try attributes.attribute(for: "type") ?? "buffer"

        if type == "buffer" {
            guard !text.isEmpty else {
                throw XMLElementParserError.missingText
            }

            results.append(.buffer(text))
        }
        else if type == "value" {
            guard !text.isEmpty else {
                throw XMLElementParserError.missingText
            }

            guard let value = Double(text) else {
                throw XMLElementParserError.unexpectedAttributeValue("value")
            }

            results.append(.value(value))
        }
        else if type == "empty" {
            results.append(.clear)
        }
        else {
            throw XMLElementParserError.unexpectedAttributeValue("type")
        }
    }
}

final class ButtonViewElementHandler: ResultElementHandler, LookupElementHandler, ViewComponentElementHandler {
    typealias Result = ButtonViewElementDescriptor

    var results = [Result]()

    var handlers: [String : ElementHandler]

    private let outputHandler = TextElementHandler()
    private let inputHandler = ButtonInputElementHandler()

    init() {
        handlers = ["output": outputHandler, "input": inputHandler]
    }

    func beginElement(attributes: XMLElementAttributes) throws {
    }

    func endElement(with text: String, attributes: XMLElementAttributes) throws {
        guard let label = attributes["label"], !label.isEmpty else {
            throw XMLElementParserError.missingAttribute("label")
        }

        guard inputHandler.results.count == outputHandler.results.count else {
            throw XMLElementParserError.missingChildElement(inputHandler.results.count > outputHandler.results.count ? "output" : "input")
        }

        let dataFlow = Array(zip(inputHandler.results, outputHandler.results))

        results.append(ButtonViewElementDescriptor(label: label, dataFlow: dataFlow))
    }

    func getResult() throws -> ViewElementDescriptor {
        return try expectSingleResult()
    }
}