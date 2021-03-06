//
//  ChatsScreen.swift
//  WhatsAppClone
//
//  Created by Anmol Verma on 05/12/20.
//

import Foundation
import SwiftUI


struct ChatsScreen : View{
  

    @ObservedObject var searchBar: SearchBar
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contactService : ContactService
    
    var body: some View{
            ScrollView{
                VStack{
                    Header()
                    Divider().padding(EdgeInsets.init(top: 5, leading: 0, bottom: 0, trailing: 0))
                    if(contactService.isLoading){
                        ProgressView().padding()
                    }else{
                        ForEach(self.contactService.contacts.filter {
                            searchBar.text.isEmpty ||
                                $0.fullName().localizedCaseInsensitiveContains(searchBar.text)
                        }, id: \.self) { car in
                            NavigationLink(destination: ChatWithUserView(chatterContact:car)){
                                VStack{
                                    ChatUserView(name:car)
                                    Divider().padding(EdgeInsets.init(top: 5, leading: 15, bottom: 0, trailing: 0))
                                }
                            }
                        }
                    }
                  
                }.background(colorScheme == .dark ? Constants.darkColor : Color.white)
            }.resignKeyboardOnDragGesture()
            .background(Constants.lightDarkColor(colorScheme: colorScheme))


    }
}

struct Header:View{
    var body: some View{
        HStack{
            Button("Broadcast Lists", action: {
                
            }).foregroundColor(.blue)
            Spacer()
            Button("New Group", action: {
                
            }).foregroundColor(.blue)
        }.padding(EdgeInsets.init(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

struct ResignKeyboardOnTapGesture: ViewModifier {
    var gesture = TapGesture().onEnded{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    
    func resignKeyboardOnTapGesture() -> some View {
        return modifier(ResignKeyboardOnTapGesture())
    }
    
}



