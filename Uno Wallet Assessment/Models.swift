import Foundation
import Combine

enum RewardsType: String, Codable, CaseIterable, Sendable {
    case cashback
    case points
    case miles
}

struct CardEvaluation: Codable, Identifiable, Sendable {
    var id: String { cardIdentifier }
    let cardIdentifier: String
    let cardDisplayName: String
    let merchantCategory: String
    let rewardsRate: Double
    let rewardsType: RewardsType
    let isSelected: Bool
}

struct RewardsSnapshot: Codable, Identifiable, Sendable {
    var id: UUID { transactionID }
    let transactionID: UUID
    let merchantCategory: String
    let evaluations: [CardEvaluation]
    let timestamp: Date
}

// Simple in-memory demo store to simulate persistence for previews and prototyping
@MainActor
final class SnapshotStore: ObservableObject {
    @Published private(set) var snapshots: [UUID: RewardsSnapshot] = [:]

    func save(_ snapshot: RewardsSnapshot) {
        snapshots[snapshot.transactionID] = snapshot
    }

    func snapshot(for transactionID: UUID) -> RewardsSnapshot? {
        snapshots[transactionID]
    }

    static func sampleSnapshot() -> RewardsSnapshot {
        let tx = UUID()
        let evals: [CardEvaluation] = [
            CardEvaluation(cardIdentifier: "discover-it", cardDisplayName: "Discover it Cash Back", merchantCategory: "Dining", rewardsRate: 0.05, rewardsType: .cashback, isSelected: true),
            CardEvaluation(cardIdentifier: "wf-autograph", cardDisplayName: "Wells Fargo Autograph", merchantCategory: "Dining", rewardsRate: 3.0, rewardsType: .points, isSelected: false),
            CardEvaluation(cardIdentifier: "bilt-obsidian", cardDisplayName: "Bilt Obsidian", merchantCategory: "Dining", rewardsRate: 1.0, rewardsType: .points, isSelected: false)
        ]
        return RewardsSnapshot(transactionID: tx, merchantCategory: "Dining", evaluations: evals, timestamp: Date())
    }
}
