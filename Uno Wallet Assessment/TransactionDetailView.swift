import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    let snapshot: RewardsSnapshot

    var body: some View {
        List {
            // Map-style header card
            Section {
                TransactionMapHeaderView(merchant: transaction.merchantName, date: transaction.date)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
            }

            // Card hero
            Section {
                CardHeroView(brand: transaction.networkDisplay)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
            }

            // Info grid
            Section(header: Text("TRANSACTION").font(.caption).foregroundStyle(.secondary)) {
                KeyValueRow(label: "Merchant", value: transaction.merchantName)
                KeyValueRow(label: "Category", value: transaction.categoryDisplayName)
                KeyValueRow(label: "Earned", value: transaction.earnedDisplay)
                KeyValueRow(label: "Date", value: formattedDate(transaction.date))
            }
            .textCase(nil)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))

            // RewardsComparisonView appended
            Section {
                RewardsComparisonView(snapshot: snapshot)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
                    .listRowSeparator(.hidden)
            }
            .textCase(nil)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.black.opacity(0.95))
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}

struct TransactionMapHeaderView: View {
    let merchant: String
    let date: Date

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(LinearGradient(colors: [.blue.opacity(0.35), .purple.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)

            HStack(spacing: 8) {
                Spacer()
                Text(formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 12)
            }
            .padding(.top, 8)

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(merchant)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundStyle(.primary)
                    Button {
                        // no-op for mock
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "map")
                            Text("Open in Maps")
                        }
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(12)
            .frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
    }

    private var formattedDate: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}

struct CardHeroView: View {
    let brand: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(LinearGradient(colors: [Color(red: 0.86, green: 0.12, blue: 0.35), Color(red: 0.65, green: 0.07, blue: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 180)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
            )
            .overlay(
                LinearGradient(colors: [.white.opacity(0.25), .clear], startPoint: .top, endPoint: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )
            .overlay(
                HStack {
                    RoundedRectangle(cornerRadius: 6).fill(.white.opacity(0.95)).frame(width: 46, height: 30)
                        .padding(.leading, 18)
                    Spacer()
                    Text(brand)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 18)
                }
            )
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
    }
}

struct KeyValueRow: View {
    let label: String
    let value: String
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .fontWeight(.semibold)
            }
            Divider().overlay(Color.white.opacity(0.06))
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        TransactionsView(transactions: MockData.transactions)
    }
}
