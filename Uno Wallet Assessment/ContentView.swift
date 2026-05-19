//
//  ContentView.swift
//  Uno Wallet Assessment
//
//  Created by Shaun Sheffey on 5/19/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TransactionsView(transactions: MockData.transactions)
    }
}

#Preview {
    ContentView()
}
