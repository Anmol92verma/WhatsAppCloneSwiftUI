//
//  SettingsThirdBlock.swift
//  WhatsAppClone
//
//  Created by Anmol Verma on 05/12/20.
//

import Foundation
import SwiftUI

struct SettingsThirdBlock : View{
    var body: some View{
        VStack(alignment:.leading){
            SettingsCommonListItem(imageId: "Help", text: "Help")
            SettingsCommonListItem(imageId: "TellFriend", text: "Tell a Friend")
        }.background(Color.white)
    }
}
