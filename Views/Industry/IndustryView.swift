import SwiftUI

struct IndustryView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink {

                    MarketView()

                } label: {

                    Label(
                        "Market",
                        systemImage: "chart.line.uptrend.xyaxis"
                    )

                }

                NavigationLink {

                    MarketingView()

                } label: {

                    Label(
                        "Marketing",
                        systemImage: "megaphone.fill"
                    )

                }

                NavigationLink {

                    ContractsView()

                } label: {

                    Label("Contracts", systemImage: "doc.text.fill")

                }

                NavigationLink {

                    CompanyPerksView()

                } label: {

                    Label("Company Perks", systemImage: "sparkles")

                }

                NavigationLink {

                    MarketSegmentsView()

                } label: {

                    Label("Market Segments", systemImage: "map.fill")

                }

                NavigationLink {

                    FrontierProjectsView()

                } label: {

                    Label("Frontier Lab", systemImage: "atom")

                }

                NavigationLink {

                    AchievementsView()

                } label: {

                    Label("Achievements", systemImage: "trophy.fill")

                }

            }

            .navigationTitle("Industry")

        }

    }

}

struct ContractsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        List {

            Section("Available Work") {

                ForEach(game.company.availableContracts) { contract in

                    VStack(alignment: .leading, spacing: 8) {

                        HStack {
                            Text(contract.name)
                                .font(.headline)
                            Spacer()
                            Text(contract.kind.rawValue)
                                .font(.caption)
                                .foregroundStyle(RogueCircuitTheme.signalGreen)
                        }

                        Text("Pays $\(Int(contract.payout).formatted()) • \(contract.durationMonths) mo pressure")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Reputation \(signed(contract.reputationEffect)) • Satisfaction \(signed(contract.satisfactionEffect)) • Research +\(Int(contract.researchEffect))")
                            .font(.caption)

                        Button {
                            game.acceptContract(id: contract.id)
                        } label: {
                            Label("Accept Work", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                    }
                    .padding(.vertical, 6)

                }

            }

            Section("Completed") {
                Text("\(game.company.completedContracts) completed contracts and pilots")
            }

        }
        .navigationTitle("Contracts")

    }

    private func signed(_ value: Int) -> String {
        "\(value >= 0 ? "+" : "")\(value)"
    }

}

struct CompanyPerksView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        List {

            Section("Points") {
                Text("\(game.company.companyPerkPoints) company perk points available")
            }

            Section("Perks") {

                ForEach(Company.CompanyPerk.allCases) { perk in

                    VStack(alignment: .leading, spacing: 8) {

                        HStack {
                            Text(perk.rawValue)
                                .font(.headline)
                            Spacer()
                            Text("\(perk.cost) pts")
                                .font(.caption)
                        }

                        Text(perk.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button {
                            game.unlockCompanyPerk(perk)
                        } label: {
                            Label(
                                game.company.unlockedCompanyPerks.contains(perk)
                                ? "Unlocked"
                                : "Unlock",
                                systemImage: game.company.unlockedCompanyPerks.contains(perk)
                                ? "checkmark.seal.fill"
                                : "sparkles"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(
                            game.company.unlockedCompanyPerks.contains(perk) ||
                            game.company.companyPerkPoints < perk.cost
                        )

                    }
                    .padding(.vertical, 6)

                }

            }

        }
        .navigationTitle("Company Perks")

    }

}

struct MarketSegmentsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        List {

            ForEach(game.company.marketSegments) { segment in

                VStack(alignment: .leading, spacing: 8) {

                    HStack {
                        Text(segment.name)
                            .font(.headline)
                        Spacer()
                        Text(segment.unlocked ? "Active" : "Locked")
                            .font(.caption)
                            .foregroundStyle(segment.unlocked ? .green : .secondary)
                    }

                    Text(segment.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("Revenue +$\(Int(segment.monthlyRevenueBonus).formatted())/mo • Reputation \(segment.reputationRequired)")
                        .font(.caption)

                    Button {
                        game.expandMarketSegment(id: segment.id)
                    } label: {
                        Label(
                            segment.unlocked
                            ? "Expanded"
                            : "Expand ($\(Int(segment.unlockCost).formatted()))",
                            systemImage: "map.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(segment.unlocked)

                }
                .padding(.vertical, 6)

            }

        }
        .navigationTitle("Market Segments")

    }

}

struct FrontierProjectsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        List {

            ForEach(game.company.frontierProjects) { project in

                VStack(alignment: .leading, spacing: 10) {

                    HStack {
                        Text(project.name)
                            .font(.headline)
                        Spacer()
                        Text(project.completed ? "Complete" : "\(Int(project.progress))%")
                            .font(.caption)
                    }

                    Text(project.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let technology = project.requiredTechnology {
                        Text("Requires \(technology)")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }

                    ProgressView(value: project.progress, total: 100)

                    Button {
                        game.fundFrontierProject(id: project.id)
                    } label: {
                        Label("Fund Next Milestone", systemImage: "atom")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(project.completed)

                }
                .padding(.vertical, 6)

            }

        }
        .navigationTitle("Frontier Lab")

    }

}

struct AchievementsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        List {

            ForEach(Company.GameAchievement.allCases) { achievement in

                HStack(alignment: .top, spacing: 12) {

                    Image(systemName:
                        game.company.unlockedAchievements.contains(achievement)
                        ? "trophy.fill"
                        : "trophy"
                    )
                    .foregroundStyle(
                        game.company.unlockedAchievements.contains(achievement)
                        ? RogueCircuitTheme.signalGreen
                        : .secondary
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(achievement.rawValue)
                            .font(.headline)
                        Text(achievement.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(achievement.gameCenterID)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                }
                .padding(.vertical, 4)

            }

        }
        .navigationTitle("Achievements")

    }

}

#Preview {

    IndustryView()

}
//  IndustryView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
