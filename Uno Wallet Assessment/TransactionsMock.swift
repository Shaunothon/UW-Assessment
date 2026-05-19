/*
import Foundation
import SwiftUI

struct Transaction: Identifiable, Hashable, Sendable {
    let id: UUID
    let merchantName: String
    let categoryDisplayName: String
    let networkDisplay: String // e.g., Discover it
    let earnedDisplay: String  // e.g., 5% Cash Back
    let date: Date
}

enum MockData {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    static let transactions: [Transaction] = [
        Transaction(id: UUID(), merchantName: "Poke Market x Sushi Now", categoryDisplayName: "Restaurants", networkDisplay: "Discover it", earnedDisplay: "5% Cash Back", date: Date()),
        Transaction(id: UUID(), merchantName: "Bilt Obsidian Card", categoryDisplayName: "Restaurants", networkDisplay: "Bilt Obsidian", earnedDisplay: "1x points", date: Date().addingTimeInterval(-3600*12)),
        Transaction(id: UUID(), merchantName: "Ranch House Grille", categoryDisplayName: "Restaurants", networkDisplay: "Discover it", earnedDisplay: "5% Cash Back", date: Date().addingTimeInterval(-3600*24))
    ]

    static func snapshot(for transaction: Transaction) -> RewardsSnapshot {
        let evals: [CardEvaluation] = [
            CardEvaluation(cardIdentifier: "discover-it", cardDisplayName: "Discover it Cash Back", merchantCategory: transaction.categoryDisplayName, rewardsRate: 0.05, rewardsType: .cashback, isSelected: true),
            CardEvaluation(cardIdentifier: "wf-autograph", cardDisplayName: "Wells Fargo Autograph", merchantCategory: transaction.categoryDisplayName, rewardsRate: 3.0, rewardsType: .points, isSelected: false),
            CardEvaluation(cardIdentifier: "bilt-obsidian", cardDisplayName: "Bilt Obsidian", merchantCategory: transaction.categoryDisplayName, rewardsRate: 1.0, rewardsType: .points, isSelected: false)
        ]
        return RewardsSnapshot(transactionID: transaction.id, merchantCategory: transaction.categoryDisplayName, evaluations: evals, timestamp: Date())
    }
}
*/

import Foundation
import SwiftUI

struct Transaction: Identifiable, Hashable, Sendable {
    let id: UUID
    let merchantName: String
    let categoryDisplayName: String
    let networkDisplay: String // e.g., Discover it Cash Back
    let earnedDisplay: String  // e.g., 5% cash back
    let date: Date
}


enum RewardType: Codable, Sendable {
    case cashback
    case points
}

enum MockData {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    static let transactions: [Transaction] = {
        let calendar = Calendar.current
        
        // Target explicit date components to completely mimic your actual wallet screenshots
        func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute
            return calendar.date(from: components) ?? Date()
        }
        
        return [
            // ====== MAY 17, 2026 ======
            Transaction(
                id: UUID(),
                merchantName: "Poke Market x Sushi Now",
                categoryDisplayName: "Restaurants",
                networkDisplay: "Discover it Cash Back",
                earnedDisplay: "5% cash back",
                date: createDate(year: 2026, month: 5, day: 17, hour: 21, minute: 53)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Bilt Obsidian Card",
                categoryDisplayName: "Overall Best",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 17, hour: 17, minute: 35)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Bilt Obsidian Card",
                categoryDisplayName: "Overall Best",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 17, hour: 17, minute: 34)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Ranch House Grille",
                categoryDisplayName: "Restaurants",
                networkDisplay: "Discover it Cash Back",
                earnedDisplay: "5% cash back",
                date: createDate(year: 2026, month: 5, day: 17, hour: 17, minute: 7)
            ),
            
            // ====== MAY 16, 2026 ======
            Transaction(
                id: UUID(),
                merchantName: "Bilt Obsidian Card",
                categoryDisplayName: "Overall Best",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 16, hour: 14, minute: 28)
            ),
            
            // ====== MAY 14, 2026 ======
            Transaction(
                id: UUID(),
                merchantName: "SKECHERS Warehouse Outlet",
                categoryDisplayName: "Department Stores",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 14, hour: 21, minute: 48)
            ),
            Transaction(
                id: UUID(),
                merchantName: "WOW Carwash - E. Warm Springs",
                categoryDisplayName: "Gas & EV",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 14, hour: 19, minute: 59)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Jamba",
                categoryDisplayName: "Restaurants",
                networkDisplay: "Discover it Cash Back",
                earnedDisplay: "5% cash back",
                date: createDate(year: 2026, month: 5, day: 14, hour: 11, minute: 30)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Walgreens",
                categoryDisplayName: "Medicine",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "2x points",
                date: createDate(year: 2026, month: 5, day: 14, hour: 11, minute: 27)
            ),
            
            // ====== MAY 13, 2026 ======
            Transaction(
                id: UUID(),
                merchantName: "Teriyaki Madness",
                categoryDisplayName: "Restaurants",
                networkDisplay: "Discover it Cash Back",
                earnedDisplay: "5% cash back",
                date: createDate(year: 2026, month: 5, day: 13, hour: 16, minute: 8)
            ),
            Transaction(
                id: UUID(),
                merchantName: "Bilt Obsidian Card",
                categoryDisplayName: "Overall Best",
                networkDisplay: "Bilt Obsidian Card",
                earnedDisplay: "1x points",
                date: createDate(year: 2026, month: 5, day: 13, hour: 15, minute: 25)
            )
        ]
    }()

    static func snapshot(for transaction: Transaction) -> RewardsSnapshot {
        // Evaluate flags cleanly to determine which card was structurally chosen in the view
        let isDiscover = transaction.networkDisplay.lowercased().contains("discover")
        let isBilt = transaction.networkDisplay.lowercased().contains("bilt")
        
        let evals: [CardEvaluation] = [
            CardEvaluation(
                cardIdentifier: "discover-it",
                cardDisplayName: "Discover it Cash Back",
                merchantCategory: transaction.categoryDisplayName,
                rewardsRate: 0.05,
                rewardsType: .cashback,
                isSelected: isDiscover
            ),
            CardEvaluation(
                cardIdentifier: "wf-autograph",
                cardDisplayName: "Wells Fargo Autograph",
                merchantCategory: transaction.categoryDisplayName,
                rewardsRate: 3.0,
                rewardsType: .points,
                isSelected: false
            ),
            CardEvaluation(
                cardIdentifier: "bilt-obsidian",
                cardDisplayName: "Bilt Obsidian Card",
                merchantCategory: transaction.categoryDisplayName,
                rewardsRate: 1.0,
                rewardsType: .points,
                isSelected: isBilt
            )
        ]
        return RewardsSnapshot(
            transactionID: transaction.id,
            merchantCategory: transaction.categoryDisplayName,
            evaluations: evals,
            timestamp: transaction.date
        )
    }
}
