// Code generated by protoc-gen-connect-swift. DO NOT EDIT.
//
// Source: chat/v1/chat.proto
//

import Connect
import Foundation
import SwiftProtobuf

public protocol Chat_V1_ChatServiceClientInterface {

    @discardableResult
    func `createUser`(request: Chat_V1_CreateUserRequest, headers: Connect.Headers, completion: @escaping (ResponseMessage<Chat_V1_CreateUserResponse>) -> Void) -> Connect.Cancelable

    @available(iOS 13, *)
    func `createUser`(request: Chat_V1_CreateUserRequest, headers: Connect.Headers) async -> ResponseMessage<Chat_V1_CreateUserResponse>

    @discardableResult
    func `getUser`(request: Chat_V1_GetUserRequest, headers: Connect.Headers, completion: @escaping (ResponseMessage<Chat_V1_GetUserResponse>) -> Void) -> Connect.Cancelable

    @available(iOS 13, *)
    func `getUser`(request: Chat_V1_GetUserRequest, headers: Connect.Headers) async -> ResponseMessage<Chat_V1_GetUserResponse>

    @discardableResult
    func `sendMessage`(request: Chat_V1_SendMessageRequest, headers: Connect.Headers, completion: @escaping (ResponseMessage<Chat_V1_SendMessageResponse>) -> Void) -> Connect.Cancelable

    @available(iOS 13, *)
    func `sendMessage`(request: Chat_V1_SendMessageRequest, headers: Connect.Headers) async -> ResponseMessage<Chat_V1_SendMessageResponse>
}

/// Concrete implementation of `Chat_V1_ChatServiceClientInterface`.
public final class Chat_V1_ChatServiceClient: Chat_V1_ChatServiceClientInterface {
    private let client: Connect.ProtocolClientInterface

    public init(client: Connect.ProtocolClientInterface) {
        self.client = client
    }

    @discardableResult
    public func `createUser`(request: Chat_V1_CreateUserRequest, headers: Connect.Headers = [:], completion: @escaping (ResponseMessage<Chat_V1_CreateUserResponse>) -> Void) -> Connect.Cancelable {
        return self.client.unary(path: "chat.v1.ChatService/CreateUser", request: request, headers: headers, completion: completion)
    }

    @available(iOS 13, *)
    public func `createUser`(request: Chat_V1_CreateUserRequest, headers: Connect.Headers = [:]) async -> ResponseMessage<Chat_V1_CreateUserResponse> {
        return await self.client.unary(path: "chat.v1.ChatService/CreateUser", request: request, headers: headers)
    }

    @discardableResult
    public func `getUser`(request: Chat_V1_GetUserRequest, headers: Connect.Headers = [:], completion: @escaping (ResponseMessage<Chat_V1_GetUserResponse>) -> Void) -> Connect.Cancelable {
        return self.client.unary(path: "chat.v1.ChatService/GetUser", request: request, headers: headers, completion: completion)
    }

    @available(iOS 13, *)
    public func `getUser`(request: Chat_V1_GetUserRequest, headers: Connect.Headers = [:]) async -> ResponseMessage<Chat_V1_GetUserResponse> {
        return await self.client.unary(path: "chat.v1.ChatService/GetUser", request: request, headers: headers)
    }

    @discardableResult
    public func `sendMessage`(request: Chat_V1_SendMessageRequest, headers: Connect.Headers = [:], completion: @escaping (ResponseMessage<Chat_V1_SendMessageResponse>) -> Void) -> Connect.Cancelable {
        return self.client.unary(path: "chat.v1.ChatService/SendMessage", request: request, headers: headers, completion: completion)
    }

    @available(iOS 13, *)
    public func `sendMessage`(request: Chat_V1_SendMessageRequest, headers: Connect.Headers = [:]) async -> ResponseMessage<Chat_V1_SendMessageResponse> {
        return await self.client.unary(path: "chat.v1.ChatService/SendMessage", request: request, headers: headers)
    }

    public enum Metadata {
        public enum Methods {
            public static let createUser = Connect.MethodSpec(name: "CreateUser", service: "chat.v1.ChatService", type: .unary)
            public static let getUser = Connect.MethodSpec(name: "GetUser", service: "chat.v1.ChatService", type: .unary)
            public static let sendMessage = Connect.MethodSpec(name: "SendMessage", service: "chat.v1.ChatService", type: .unary)
        }
    }
}
