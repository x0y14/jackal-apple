//
//  ContentView.swift
//  jackal-apple
//
//  Created by Yuhei Yamauchi on 2023/03/22.
//

import SwiftUI
import CoreData
import Combine
import Connect
import SwiftProtobuf
import os.log

struct Message: Identifiable {
    let id: Int64
    let from: String
    let to: String
    let text: String
    let metadata: String
    let kind: Types_V1_MessageKind
    let createdAt: Date
}

let yourId: String = "john"
var globalLastMessageId: Int64 = 0

final class MessagingViewModel: ObservableObject {
    private let chatClient: Chat_V1_ChatServiceClientInterface
    private let notifyClient: Notify_V1_NotifyServiceClientInterface
    
    @MainActor @Published private(set) var messages = [Message]()
    
    init(chatClient: Chat_V1_ChatServiceClientInterface, notifyClient: Notify_V1_NotifyServiceClientInterface) {
        self.chatClient = chatClient
        self.notifyClient = notifyClient
        
        Task {
            try! await self.fetchMsgs(lastMessageId:globalLastMessageId)
        }
    }
    
    func sendMsg(to: String, text: String) async {
        let request = Chat_V1_SendMessageRequest.with{
            $0.message = Types_V1_Message.with{
                $0.messageID = Int64(Date().timeIntervalSince1970)
                $0.from = yourId
                $0.to = to
                $0.text = text
                $0.metadata = ""
                $0.kind = Types_V1_MessageKind.plainUnspecified
                $0.createdAt = SwiftProtobuf.Google_Protobuf_Timestamp.init(date: Date())
            }
        }
//        
//        await self.addMessage(Message(
//            id: request.message.messageID,
//            from: request.message.from,
//            to: request.message.to,
//            text: request.message.text,
//            metadata: request.message.metadata,
//            kind: request.message.kind,
//            createdAt: request.message.createdAt.date
//            )
//        )
        
        var headers: Dictionary<String, Array<String>> = ["X-User-ID": [yourId]]
        let resp = await self.chatClient.sendMessage(request: request, headers: headers)
    }
    
    func fetchMsgs(lastMessageId: Int64) async throws {
        while true {
            do {
                try await self.fetch(lastMessageId: lastMessageId)
            } catch let error {
                if let err = error as NSError? {
                    if err.domain == NSURLErrorDomain,
                       err.code == NSURLErrorTimedOut {
                        os_log("fetchMsgs: stream: timeouted")
                        continue
                    }
                }
                throw error
            }
        }
    }
    
    func fetch(lastMessageId: Int64) async {
        let request = Notify_V1_FetchMessageRequest.with {
            $0.lastMessageID = lastMessageId
        }
        
        var headers: Dictionary<String, Array<String>> = ["X-User-ID": [yourId]]
        let stream = self.notifyClient.fetchMessage(headers: headers)
        do {
            try stream.send(request)
        } catch let err {
            os_log(
                .error, "Failed to write message to stream: %@", err.localizedDescription)
        }
        
        for await result in stream.results() {
            switch result {
            case .headers(let headers): break
            case .message(let resp):
                await self.addMessage(Message(
                    id: resp.message.messageID,
                    from: resp.message.from,
                    to: resp.message.to,
                    text: resp.message.text,
                    metadata: resp.message.metadata,
                    kind: resp.message.kind,
                    createdAt: resp.message.createdAt.date
                    )
                )
                globalLastMessageId = resp.message.messageID
            case .complete(let code, let error, let trailers): break
            }
        }
    }
    
    @MainActor
    private func addMessage(_ message: Message) {
        self.messages.append(message)
    }
}


struct ContentView: View {
    @State private var currentMessage = ""
    @ObservedObject private var viewModel: MessagingViewModel
    
    init(viewModel: MessagingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack{
            ScrollViewReader {
                listView in
                ScrollView {
                    ForEach(self.viewModel.messages) { message in
                        VStack {
                            switch message.from {
                            case yourId:
                                HStack{
                                    Spacer()
                                    Text("You")
                                        .foregroundColor(.gray)
                                        .fontWeight(.semibold)
                                }
                                HStack{
                                    Spacer()
                                    Text(message.text)
                                        .multilineTextAlignment(.trailing)
                                }
                            default:
                                HStack{
                                    Text(message.from)
                                        .foregroundColor(.blue)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                HStack{
                                    Text(message.text)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                        }
                        .id(message.id)
                    }
                }.onChange(of: self.viewModel.messages.count) { messageCount in
                    listView.scrollTo(self.viewModel.messages[messageCount-1].id)
                }
            }
            
            HStack {
                TextField("write your msg...", text: self.$currentMessage)
                    .onSubmit {
                        self.sendMessage()
                    }
                
                Button("Send", action: {self.sendMessage()})
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    private func sendMessage() {
        let messageToSend = self.currentMessage
        if messageToSend.isEmpty {
            return
        }
        
        Task {
            await self.viewModel.sendMsg(to: "test-receiver", text:messageToSend)
            self.currentMessage = ""
        }
    }
}
