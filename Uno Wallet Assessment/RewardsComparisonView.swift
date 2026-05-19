import SwiftUI

struct RewardsComparisonView: View {
    let snapshot: RewardsSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rewards Comparison")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)

            VStack(spacing: 6) {
                ForEach(sortedEvaluations) { evaluation in
                    RewardsRowView(evaluation: evaluation)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(evaluation.isSelected ? Color.accentColor.opacity(0.08) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder(evaluation.isSelected ? Color.accentColor.opacity(0.25) : Color.white.opacity(0.06), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var sortedEvaluations: [CardEvaluation] {
        snapshot.evaluations.sorted { lhs, rhs in
            // Compare by effective reward value. For points/miles we treat larger numeric as better for demo.
            lhs.rewardsRateValue > rhs.rewardsRateValue
        }
    }
}

private extension CardEvaluation {
    var rewardsRateValue: Double {
        switch rewardsType {
        case .cashback:
            return rewardsRate // already a fraction like 0.05
        case .points, .miles:
            return rewardsRate // treat as multiplier (e.g., 3x)
        }
    }
}

struct RewardsRowView: View {
    let evaluation: CardEvaluation

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(evaluation.cardDisplayName)
                        .font(.subheadline)
                        .fontWeight(evaluation.isSelected ? .semibold : .regular)
                    if evaluation.isSelected {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.tint)
                            .font(.caption)
                            .accessibilityLabel("Optimal")
                    }
                }
                Text(evaluation.merchantCategory)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(formattedRate)
                .font(.subheadline)
                .foregroundColor(evaluation.isSelected ? .accentColor : .primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }

    private var formattedRate: String {
        switch evaluation.rewardsType {
        case .cashback:
            return "\(Int(evaluation.rewardsRate * 100))% cash back"
        case .points:
            return "\(formatNumber(evaluation.rewardsRate))x points"
        case .miles:
            return "\(formatNumber(evaluation.rewardsRate))x miles"
        }
    }

    private var accessibilitySummary: String {
        var parts: [String] = [evaluation.cardDisplayName, formattedRate]
        if evaluation.isSelected { parts.append("Optimal") }
        return parts.joined(separator: ", ")
    }

    private func formatNumber(_ value: Double) -> String {
        if value == floor(value) { return String(Int(value)) }
        return String(format: "%.1f", value)
    }
}

#Preview("Rewards Comparison") {
    let snapshot = SnapshotStore.sampleSnapshot()
    NavigationStack {
        List {
            RewardsComparisonView(snapshot: snapshot)
        }
        .navigationTitle("Transaction")
    }
}
