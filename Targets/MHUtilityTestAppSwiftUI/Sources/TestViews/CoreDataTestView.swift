//
//  CoreDataTestView.swift
//  MHUtilityTestAppSwiftUI
//
//  Created by LittleFoxiOSDeveloper on 1/9/24.
//

import SwiftUI

struct CoreDataTestView: View {
    var body: some View {
        HStack(content: {
            Button(action: {
                
            }, label: {
                Text("save the user data")
            })
            
            Button(action: {
                
            }, label: {
                Text("get the user data")
            })
        })
    }
}

#Preview {
    CoreDataTestView()
}
