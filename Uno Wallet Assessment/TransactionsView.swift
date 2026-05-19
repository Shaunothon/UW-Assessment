/*
import SwiftUI

struct TransactionsView: View {
    let transactions: [Transaction]

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedByDay.keys.sorted(by: >), id: \.self) { day in
                    Section(daySectionTitle(for: day)) {
                        ForEach(groupedByDay[day] ?? []) { tx in
                            NavigationLink(value: tx) {
                                TransactionRow(transaction: tx)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationDestination(for: Transaction.self) { tx in
                let snapshot = MockData.snapshot(for: tx)
                TransactionDetailView(transaction: tx, snapshot: snapshot)
            }
        }
    }

    private var groupedByDay: [Date: [Transaction]] {
        Dictionary(grouping: transactions) { tx in
            Calendar.current.startOfDay(for: tx.date)
        }
    }

    private func daySectionTitle(for day: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: day)
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.secondary.opacity(0.2))
                .frame(width: 44, height: 28)
                .overlay(
                    Text(shortBrand)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(transaction.merchantName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Spacer()
                    Text(timeString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 6) {
                    Text(transaction.networkDisplay)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(transaction.earnedDisplay)
                        .font(.caption)
                        .foregroundStyle(.pink)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private var timeString: String {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        return df.string(from: transaction.date)
    }

    private var shortBrand: String {
        String(transaction.networkDisplay.split(separator: " ").first ?? "Card")
    }
}

#Preview {
    TransactionsView(transactions: MockData.transactions)
}
*/
import SwiftUI

struct TransactionsView: View {
    let transactions: [Transaction]

    var body: some View {
            NavigationStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        
                        Text("Transactions")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.top, 16)
                        
                        ForEach(groupedByDay.keys.sorted(by: >), id: \.self) { day in
                            VStack(alignment: .leading, spacing: 12) {
                              
                                Text(daySectionTitle(for: day))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)

                                VStack(spacing: 0) {
                                    let sortedTransactions = groupedByDay[day] ?? []
                                    ForEach(Array(sortedTransactions.enumerated()), id: \.element.id) { index, tx in
                                        NavigationLink(value: tx) {
                                            TransactionRow(transaction: tx)
                                        }
                                        .buttonStyle(.plain)

                                        if index < sortedTransactions.count - 1 {
                                            Divider()
                                                .padding(.leading, 72)
                                                .padding(.trailing, 16)
                                                .background(Color(white: 0.2))
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                .background(Color(white: 0.11))
                                .cornerRadius(14)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                .background(Color.black.ignoresSafeArea())
                
                .toolbar {
                    ToolbarItem(placement: .principal) { EmptyView() }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationDestination(for: Transaction.self) { tx in
                    let snapshot = MockData.snapshot(for: tx)
                    TransactionDetailView(transaction: tx, snapshot: snapshot)
                }
            }
            .environment(\.colorScheme, .dark) 
    }
    private var groupedByDay: [Date: [Transaction]] {
        Dictionary(grouping: transactions) { tx in
            Calendar.current.startOfDay(for: tx.date)
        }
    }

    private func daySectionTitle(for day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) {
            return "Today"
        } else if calendar.isDateInYesterday(day) {
            return "Yesterday"
        } else {
            let df = DateFormatter()
            df.dateFormat = "MMMM d, yyyy"
            return df.string(from: day)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            MiniCardGraphicView(networkDisplay: transaction.networkDisplay)
                .frame(width: 54, height: 34)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(transaction.merchantName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(timeString)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Text(transaction.networkDisplay)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text("·")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text(transaction.earnedDisplay)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(rewardColor)
                }
            }
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    private var timeString: String {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        return df.string(from: transaction.date)
    }

    private var rewardColor: Color {
        let displayLower = transaction.networkDisplay.lowercased()
        if displayLower.contains("discover") {
            return Color(red: 0.96, green: 0.22, blue: 0.53) // Pop Orchid Pink
        } else if displayLower.contains("bilt") {
            return Color(red: 0.72, green: 0.35, blue: 0.95) // Soft Violet Purple
        }
        return .secondary
    }
}

struct MiniCardGraphicView: View {
    let networkDisplay: String
    
    var body: some View {
        let displayLower = networkDisplay.lowercased()
        
        ZStack(alignment: .bottomLeading) {
            if displayLower.contains("discover") {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.58, green: 0.13, blue: 0.25), Color(red: 0.38, green: 0.06, blue: 0.14)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                HStack(spacing: 1) {
                    Text("DISCOVER")
                        .font(.system(size: 5, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 3, height: 3)
                }
                .padding([.leading, .bottom], 5)
                
            } else if displayLower.contains("bilt") {
                LinearGradient(
                    gradient: Gradient(colors: [Color(white: 0.22), Color(white: 0.13)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Text("BILT")
                    .font(.system(size: 5, weight: .black, design: .monospaced))
                    .foregroundColor(Color(red: 0.85, green: 0.72, blue: 0.44)) // Subtle gold text accent
                    .padding([.leading, .bottom], 5)
                
            } else {
                Color(.systemGray5)
            }
            
            // Scaled Card Core Micro-Chip Asset
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.white.opacity(0.25))
                .frame(width: 7, height: 5)
                .position(x: 9, y: 11)
        }
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    TransactionsView(transactions: MockData.transactions)
}
