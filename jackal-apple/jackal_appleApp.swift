//
//  jackal_appleApp.swift
//  jackal-apple
//
//  Created by Yuhei Yamauchi on 2023/03/22.
//
import Connect
import SwiftUI

@main
struct jackal_appleApp: App {
    @State private var chatClient = ProtocolClient(
        httpClient: URLSessionHTTPClient(),
        config: ProtocolClientConfig(
            host: "http://192.168.0.16:8081",
            networkProtocol: .connect,
            codec: ProtoCodec()
        )
    )
    
    @State private var notifyClient = ProtocolClient(
        httpClient: URLSessionHTTPClient(),
        config: ProtocolClientConfig(
            host: "http://192.168.0.16:8082",
            networkProtocol: .connect,
            codec: ProtoCodec()
        )
    )
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MessagingViewModel(
                chatClient: Chat_V1_ChatServiceClient(client: self.chatClient),
                notifyClient: Notify_V1_NotifyServiceClient(client: self.notifyClient)
            ))
        }
    }
}
