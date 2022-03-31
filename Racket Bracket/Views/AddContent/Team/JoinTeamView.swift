//
//  JoinTeamView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct JoinTeamView: View {
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var joinCode = ""
    @State var loading = false
    @State var showErrorView = false
    
    let type: UserType
    var expectedStringLength: Int {
        if type == .player {
            return (UserModelDefaults.codeLength * 2) + 1
        } else {
            return UserModelDefaults.codeLength
        }
    }
    
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else {
                RoundedTextField(placeholder: "Your join code", textFieldValue: $joinCode)
            }
          
            Spacer()
            
            RoundedButton(title: "Join") {
                joinCode = joinCode.uppercased()
                loading = true
                
                userModel.tryJoining(as: type, id: joinCode) { success in
                    if success {
                        teamModel.retrieveDataFromCloud { _ in
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        showErrorView = true
                        loading = false
                    }
                }
            }
            .disabled(joinCode.isEmpty || joinCode.count != expectedStringLength)
            .alert(isPresented: $showErrorView) {
                Alert(
                    title: Text("Invalid Join Code"),
                    message: Text("The code entered is incorrect or there may a problem with your internet.")
                )
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle("Join Team")
    }
}

struct JoinTeamView_Previews: PreviewProvider {
    static var previews: some View {
        JoinTeamView(type: .player)
    }
}
