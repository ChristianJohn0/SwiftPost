//
//  TestingView.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import SwiftUI

struct MasterView: View {
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DetailView()) {
                    Text("MasterView").fontWeight(.semibold)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .background(Color.applicationColor.edgesIgnoringSafeArea(.all))
        .colorScheme(.dark)
    }
    
    func delete(offsets: IndexSet) {
    }
    
    func add() {
        showAlert = true
        print("alert button was pressed")
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}



struct DetailView: View {
    var body: some View {
        List {
            ForEach(0..<15) { _ in
                Text("Date: \(Date())")
            }.listRowBackground(Color.applicationColor)
        }
        .colorScheme(.dark)
        .navigationBarTitleDisplayMode(.automatic)
        .background(Color.applicationColor.edgesIgnoringSafeArea(.all))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
