//
//  ContentView.swift
//  CCLComms
//
//  Created by Felipe on 5/26/22.
//

import SwiftUI

struct Call: Hashable {
    var id = UUID().uuidString
    var name: String
    var number: String
    var date: Date
}

struct CallView: View {
    var call: Call
    
    var body: some View {
        VStack {
            HStack {
                Text(call.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Text(getTime(date:call.date))
                    .foregroundColor(.gray)
            }
            HStack {
                Text(call.number)
                    .font(.title3)
                    .foregroundColor(.gray)
                Spacer()
                Text(getDay(date:call.date))
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
    
    func getDay(date: Date) -> String {
        let shortdate = DateFormatter()
        shortdate.locale = Locale.current
        shortdate.dateFormat = "MMMM dd, yyyy"
        var today = shortdate.string(from: date)
        today = today.capitalized
        return today
    }
    
    func getTime(date: Date) -> String {
        let shortdate = DateFormatter()
        shortdate.locale = Locale.current
        shortdate.dateFormat = "H:MM a"
        var today = shortdate.string(from: date)
        today = today.capitalized
        return today
    }
    
}

class CallsViewModel: ObservableObject {
    @Published var calls: [Call] = [Call(name: "Juan Diaz", number: "954-555-1212", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Juan Diaz", number: "954-555-1212", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Juan Diaz", number: "954-555-1212", date: Date()),
                                    Call(name: "Juan Diaz", number: "954-555-1212", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
                                    Call(name: "Liz Gomez", number: "954-478-1432", date: Date()),
    ]
}

struct CallsView: View {
    @ObservedObject var vm = CallsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.calls, id: \.self) { call in
                    CallView(call: call)
                }
            }
            .navigationTitle("Calls")
        }
    }
}

@ViewBuilder
func DialerButton(digit: String) -> some View {
    (Text(digit))
        .foregroundColor(.white)
        .font(.title3)
        .fontWeight(.semibold)
        .frame(minWidth: 80, minHeight: 80)
        .background(.blue)
        .clipShape(Circle())
}

@ViewBuilder
func BackView() -> some View {
    Label(" ", systemImage: "delete.left")
        .foregroundColor(.blue)
        .font(.largeTitle)
        .frame(minWidth: 80, minHeight: 80)
        .clipShape(Circle())
}

struct DialerView: View {
    let columns = [GridItem(.fixed(100)),
                   GridItem(.fixed(100)),
                   GridItem(.fixed(100))]
    @State var number = ""
    
    var body: some View {
        ScrollView(.vertical) {
            
            Spacer()
                .frame(minHeight: 30)

            Text(number)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .frame(minWidth: 300, minHeight: 60)
                .border(.gray)
            
            Spacer()
                .frame(minHeight: 40)

            LazyVGrid(columns: columns, spacing: 25) {
                ForEach((1...12), id: \.self) { index in
                    Button(action: {
                        if index == 10 {
                            number = String(number.dropLast())
                        } else if index == 11 {
                            number += "0"
                        } else {
                            number += String(index)
                        }
                    }, label: {
                        if index == 10 {
                            BackView()
                        } else if index == 11 {
                            DialerButton(digit: "0")
                        } else if index == 12 {
                            EmptyView()
                        }
                        else {
                            DialerButton(digit: String(index))
                        }
                    })
                }
            }
            
            Spacer()
                .frame(minHeight: 40)
            
            Button {
                
            } label: {
                Text("Dial")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(minWidth: 300, minHeight: 50)
                    .background(.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)))
            }
        }
        .padding()
    }
}

struct Chat: Hashable {
    var id = UUID().uuidString
    var name: String
    var to: String
    var from: String
    var date: Date
}

class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = [Chat(name: "Captain", to: "Ahoy", from: "", date: Date()),
                                    Chat(name: "Liz", to: "", from: "Sir", date: Date()),
                                    Chat(name: "Captain", to: "Please start embarking", from: "", date: Date()),
    ]
}

struct ChatView: View {
    var chat: Chat
    
    var body: some View {
        VStack(spacing: 8) {
            HStack() {
                if chat.to.isEmpty {
                    Spacer()
                    Text(chat.name)
                        .foregroundColor(.blue)
                    Image("agent1")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                } else {
                    Text(chat.name)
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            .frame(minHeight: 8)
            HStack {
                if chat.to.isEmpty {
                    Spacer()
                    Text(chat.from)
                } else {
                    Text(chat.to)
                    Spacer()
                }
            }
            .frame(minHeight: 8)
            
        }.padding(EdgeInsets(top: 10, leading: 8, bottom: 0, trailing: 8))
    }

    func getDay(date: Date) -> String {
        let shortdate = DateFormatter()
        shortdate.locale = Locale.current
        shortdate.dateFormat = "MMMM dd, yyyy"
        var today = shortdate.string(from: date)
        today = today.capitalized
        return today
    }
}

@ViewBuilder
func SubmitButton(_ title: String) -> some View {
    (Text(title))
        .foregroundColor(.white)
        .font(.body)
        .fontWeight(.semibold)
        .frame(minWidth: 30, minHeight: 30)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
}

struct ChatsView: View {
    @ObservedObject var vm = ChatViewModel()
    @State var text: String = ""

    fileprivate func textBox() -> some View {
        return HStack {
            TextField("Enter your text here", text: $text)
                .frame(minHeight: 30)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .border(.blue, width: 2)
            
            Button(action: {
                let chat = Chat(name: "Liz", to: "", from: text, date: Date())
                vm.chats.append(chat)
                text = ""
                
            }, label: {
                SubmitButton("Submit")
            })
            
        }.frame(minHeight: 40)
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                ScrollView
                {
                    // Chat Area
                    VStack(alignment: .trailing, spacing: 20) {
                        Spacer()
                        
                        ForEach(vm.chats, id: \.self) { chat in
                            ChatView(chat: chat)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 30, trailing: 8))
                    //.background(.yellow)
                }
                
                // Text Area
                VStack(alignment: .trailing, spacing: 12) {
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.red)
                    
                    textBox()
                        .frame(height: 30)
                    
                    Spacer()
                        .frame(height: 9)
                }
                .background(.white)
                .padding(EdgeInsets(top: 500, leading: 8, bottom: 0, trailing: 8))
            }
            .navigationTitle("Chat")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            CallsView()
                .tabItem {
                    Label("Calls", systemImage: "list.dash")
                }
            DialerView()
                .tabItem {
                    Label("Dialer", systemImage: "circle.grid.3x3")
                }
            ChatsView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left")
                }
            PrefsView()
                .tabItem {
                    Label("Prefs", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
