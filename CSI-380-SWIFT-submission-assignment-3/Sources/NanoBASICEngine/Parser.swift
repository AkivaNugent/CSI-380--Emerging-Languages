//
//  Parser.swift
//  NanoBASIC Parser — Creates Nodes from Tokens
//
//  Copyright (c) 2019 David Kopec
//  MIT License (see LICENSE)
//
//  The parser takes the tokens from the tokenizer and tries to convert them
//  into structures that are meaningful for interpreting the program. The
//  particular parsing technique being used in Parser.swift is recursive descent.
//  In recursive descent, generally each non-terminal defined in the grammar becomes
//  a function. That function is responsible for checking that the tokens it is
//  analyzing follow a production rule specified in the grammar. In other words,
//  generally one recursive descent function = one production rule from the grammar.
//  The parser checks the tokens by looking at them sequentially. If the token that
//  is being analyzed is expected to be a part of another production rule, the
//  recursive descent parser just calls the function representing that other production rule.
//  The recursive descent functions return respective nodes (for example an
//  ifStatement function will return an IfStatement node) when they are successful.

import Foundation

public enum ParserError: Error, LocalizedError {
    case ParseError(explanation: String, token: Token?)
    
    public var errorDescription: String? {
        switch self {
        case .ParseError(let explanation, let token):
            return "\(explanation) at token:\(String(describing: token))"
        }
    }
}

// Recursive Descent Parser of Grammar in grammar.txt
// Note that the functions pretty much in order from most specific to least
public class Parser {
    let tokens: [Token]  // initialized with all of the tokens in an array
    var index: Int = 0  // the index of the current token we are looking at
    
    // The current token under examination by the parser
    var current: Token {
        if index < tokens.count { return tokens[index] }
        return .EOF
    }
    
    // The next token after the current token
    var lookahead: Token {
        if (index + 1) < tokens.count { return tokens[(index + 1)] }
        return .EOF
    }
    
    
    public init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    // MARK: Parsing Arithmetic Expressions
    
    // This function corresponds to the "factor" production rule in grammar.txt
    func parseFactor() throws -> Expression? {
        switch current {
        case let .variable(range, varname):
            index += 1 // consume variable
            return VarName(string: varname, range: range)
        case let .number(range, value):
            index += 1 // consume number
            return NumberLiteral(number: value, range: range)
        case .openParen:
            index += 1 // consume openParen
            let expr = try parseExpression()
            if case .closeParen = current {
                index += 1 // consume closeParen
                return expr
            }
            print("expected close paren, got \(current)")
            throw ParserError.ParseError(explanation: "Closing parenthesis ) missing", token: current)
        case .minus:
            let oldMinus = current
            index += 1 // consume minus sign
            if let expr = try parseFactor() {
                return UnaryOperation(operation: oldMinus, value: expr, range: oldMinus.range.lowerBound..<expr.range.upperBound)
            }
            throw ParserError.ParseError(explanation: "Invalid token following minus sign", token: current)
        default:
            throw ParserError.ParseError(explanation: "Invalid factor for parsing", token: current) // unary or single value
        }
    }
    
    // This function corresponds to the "term" production rule in grammar.txt
    func parseTerm() throws -> Expression? {
        if let down = try parseFactor() {
            var left = down
            // keep looking for *s and /s while there are more
            outer: while true {
                if index >= tokens.count { return left } // in case expression is end of file
                switch current {
                case .multiply:
                    let oldTimes = current
                    index += 1
                    if let right = try parseFactor() {
                        left = BinaryOperation(operation: oldTimes, left: left, right: right, 
                                               range: left.range.lowerBound..<right.range.upperBound)
                    } else {
                        throw ParserError.ParseError(explanation: "Couldn't parse factor on right side of * sign",
                                                     token: current)
                    }
                case .divide:
                    let oldDivide = current
                    index += 1
                    if let right = try parseFactor() {
                        left = BinaryOperation(operation: oldDivide, left: left, right: right, 
                                               range: left.range.lowerBound..<right.range.upperBound)
                    } else {
                        throw ParserError.ParseError(explanation: "Couldn't parse factor on right side of / sign",
                                                     token: current)
                    }
                default:
                    break outer
                }
            }
            return left
        }
        print("couldn't parse factor from term")
        return nil
    }
    
    // This function corresponds to the "expression" production rule in grammar.txt
    func parseExpression() throws -> Expression? {
        if let down = try parseTerm() {
            var left = down
            // keep parsing +s and -s until there are no more
            outer: while true {
                if index >= tokens.count { return left } // incase expression is end of file
                switch current {
                case .plus:
                    let oldP = current
                    index += 1
                    if let right = try parseTerm() {
                        left = BinaryOperation(operation: oldP, left: left, right: right,
                                               range: left.range.lowerBound..<right.range.upperBound)
                    } else {
                        throw ParserError.ParseError(explanation: "Couldn't parse term on right side of + sign",
                                                     token: current)
                    }
                case .minus:
                    let oldM = current
                    index += 1
                    if let right = try parseTerm() {
                        left = BinaryOperation(operation: oldM, left: left, right: right, 
                                               range: left.range.lowerBound..<right.range.upperBound)
                    } else {
                        throw ParserError.ParseError(explanation: "Couldn't parse term on right side of - sign",
                                                     token: current)
                    }
                default:
                    break outer
                }
            }
            return left
        }
        print("Couldn't parse term from expression.")
        return nil
    }
    
    // MARK: Parsing Boolean Expressions
    
    // This function corresponds to the "relop" production rule in grammar.txt
    func parseBooleanExpression() throws -> BooleanExpression? {
        //parse the left
        //get the opperator
        //parse the right
        //eat the token after doing them
        if let left = try parseExpression() {
            switch current {
            case .equal, .notEqual, .lessThan, .lessThanEqual, .greaterThan, .greaterThanEqual:
                let operation = current
                index += 1
                if let right = try parseExpression() {
                    return BooleanExpression(operation: operation, left: left, right: right,
                                             range: current.range)
                }
            default:
                break
            }
        }
        throw ParserError.ParseError(explanation: "boolean wont parse", token: current)
    }
    
    // MARK: Parsing Statements
    
    // Parse a GOSUB statement from the "statement" production rule in grammar.txt
    func parseGoSub(lineNumber: Int16) throws -> GoSubCall? {
        //get the gosub
        //get the lineNuber
        if case .gosub = current {
            index += 1
            if case let .number(range, gotoLine) = current {
                index += 1
                return GoSubCall(gotoLine: gotoLine, line: lineNumber, range: range)
            }
        }
        return nil
    }
    
    // Parse a LET statement from the "statement" production rule in grammar.txt
    func parseLet(lineNumber: Int16) throws -> VarSet? {
        //get the let
        //get the variable
        //get the =
        //get everything else
        if case .letT = current {
            index += 1
            if case let .variable(_, varName) = current {
                index += 1
                if case .equal = current {
                    index += 1
                    if let value = try parseExpression() {
                        return VarSet(name: varName, value: value, line: lineNumber, range: current.range)
                    }
                }
            }
        }
        return nil
    }
    
    // Parse a GOTO statement from the "statement" production rule in grammar.txt
    func parseGoTo(lineNumber: Int16) throws -> GoToCall? {
        //get the goto
        //get the number
        if case .goto = current {
            index += 1
            if case let .number(_, gotoLine) = current {
                index += 1
                return GoToCall(gotoLine: gotoLine, line: lineNumber, range: current.range)
            }
        }
        return nil
    }
    
    // Parse an IF statement from the "statement" production rule in grammar.txt
    func parseIf(lineNumber: Int16) throws -> IfStatement? {
        if case .ifT = current {
            index += 1
            if let boolExpr = try parseBooleanExpression() {
                if case .then = current {
                    index += 1
                    if let thenStatement = try parseStatement(line: lineNumber) {
                        return IfStatement(booleanExpression: boolExpr, thenStatement: thenStatement,
                                           line: lineNumber, range: current.range)
                    }
                }
            }
        }
        return nil
    }
    
    // Parse a PRINT statement from the "statement" production rule in grammar.txt
    func parsePrint(lineNumber: Int16) throws -> PrintStatement? {
        if case let .print(startRange) = current {
            var printables = [Printable]()
            var lastRange = startRange // range of last token
            while true { // keep finding things to print while they're there
                index += 1  // consume last token
                if case let .string(endRange, str) = current {
                    index += 1 // consume string token
                    printables.append(str)
                    lastRange = endRange
                } else if let expr = try parseExpression() {
                    printables.append(expr)
                    lastRange = expr.range
                }
                if case .comma = current {
                    continue
                } else {
                    break // expect comma at the end of each thing in print
                }
            }
            if printables.count < 1 {
                throw ParserError.ParseError(explanation: 
                    "Expect at least one expression or string to follow a print statement.",
                                             token: current)
            }
            return PrintStatement(printables: printables, line: lineNumber, 
                                  range: startRange.lowerBound..<lastRange.upperBound)
            
        }
        return nil
    }
    
    // Parse a statement from the "statement" production rule in grammar.txt
    func parseStatement(line: Int16) throws -> Statement? {
        switch current {
        case .print:
            return try parsePrint(lineNumber: line)
        case .ifT:
            return try parseIf(lineNumber: line)
        case .goto:
            return try parseGoTo(lineNumber: line)
        case .letT:
            return try parseLet(lineNumber: line)
        case .gosub:
            return try parseGoSub(lineNumber: line)
        case .returnT(let range):
            index += 1 // consume return token
            return ReturnStatement(line: line, range: range)
        case .number:
            return nil // another number means the next statement
        default:
            throw ParserError.ParseError(explanation: "Unrecognized token at beginning of statement",
                                         token: current)
        }
        
    }
    
    // Parse a line from the "line" production rule in grammar.txt
    // Note that REM comments are covered by the tokenizer which turns them into nothing
    func parseLine() throws -> Statement? {
        // expect every line that contains a statement
        // to start with a line number
        if case let .number(_, lineNumber) = current {
            index += 1 // consume line number
            return try parseStatement(line: lineNumber)
        }
        throw ParserError.ParseError(explanation: "Expect every statement to be preceded by a line number",
                                     token: current)
    }
    
    // Try to parse an array of statements out of the tokens at hand
    // assuming the lines are in the correct order
    func parseStatementList() throws -> StatementList {
        var statements: StatementList = [Statement]()
        while index < tokens.count {
            if let statement = try parseLine() {
                statements.append(statement)
            }
        }
        return statements
    }
    
    public func parse() throws -> StatementList {
        return try parseStatementList()
    }
    
}
