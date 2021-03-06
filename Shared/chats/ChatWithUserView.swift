//
//  SwiftUIView.swift
//  WhatsAppClone
//
//  Created by Anmol Verma on 05/12/20.
//

import SwiftUI
import Introspect

struct ChatWithUserView: View {

    @Environment(\.presentationMode) var presentation
    @Environment(\.colorScheme) var colorScheme

    @State var tableView: UIScrollView?
    @State var yOffset: CGFloat?

    @ObservedObject var chatViewModel = ChatViewModel()
    


    let chatterContact: ChatterContact


    var body: some View {
        VStack(alignment: .leading) {
            messagesList
            Footer(tableView: $tableView, yOffset: $yOffset)
                    .environmentObject(chatViewModel)
        }.background(Constants.lightDarkColor(colorScheme: colorScheme))
                .widthHeightmatchParent()
                .navigationBarBackButtonHidden(true)
                .resignKeyboardOnTapGesture()
                .navigationBarItems(leading: navigationLeading,
                        trailing: navigationTrailing)
    }

    var messagesList: some View {
            ScrollView {
                ForEach(chatViewModel.messages, id: \.self) { message in
                    HStack(alignment: .bottom) {
                        if (message.myMessage == true) {
                            Spacer()
                            if (message.message != nil) {
                                UserTextMessage(chatMesage: message)
                                UserImage()
                            } else {
                                PictureImage(chatMesage: message)
                                UserImage()
                            }
                        } else {
                            if (message.message != nil) {
                                UserImage()
                                UserTextMessage(chatMesage: message)
                            } else {
                                UserImage()
                                PictureImage(chatMesage: message)
                            }
                            Spacer()
                        }

                    }.padding(4).widthMatchParent().id(message.hashValue)

                }

            }.introspectScrollView(customize: { tableView in
                if self.tableView == nil {
                    self.tableView = tableView
                } else {

                    guard let yOffset = self.yOffset
                            else {
                        return
                    }

                    self.tableView?.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
                    self.tableView?.scrollToBottom(animated: true, yOffset: $yOffset)
                }
            })
    }

    var navigationLeading: some View {
        HStack{
            Button(action: {
                presentation.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                              .foregroundColor(.blue)
            }).padding()
            Image("RandomUser")
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .shadow(radius: 28)
            Text(chatterContact.fullName())
        }
    }
    var navigationTrailing: some View {
        HStack {
            Spacer()
            Button(action: {

            }, label: {
                Image(systemName: "video")
                        .foregroundColor(.blue)
                        .imageScale(.large)
            })

            Button(action: {

            }, label: {
                Image(systemName: "phone")
                        .foregroundColor(.blue)
                        .imageScale(.large)
            })
        }
    }
}

struct UserImage: View {
    var body: some View {
        Image("RandomUser")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .cornerRadius(10).padding(.trailing, 10)
    }
}

struct PictureImage: View {
    let chatMesage: ChatMessage

    var body: some View {
        VStack {
            Image(uiImage: chatMesage.image!)
                    .resizable().frame(width: 150, height: 150).padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)

        }.background(Color.blue)
                .cornerRadius(25)
    }
}

struct UserTextMessage: View {

    let chatMesage: ChatMessage

    var body: some View {
        Text(chatMesage.message!).padding(10)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
    }
}


extension UIScrollView {

    func scrollToBottom(animated: Bool,
                        yOffset: Binding<CGFloat?>) {

        let y = contentSize.height - frame.size.height
        if y < 0 {
            return
        }

        yOffset.wrappedValue = y
    }
}
