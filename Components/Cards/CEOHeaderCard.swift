import SwiftUI

struct CEOHeaderCard: View {

    @Environment(GameManager.self) private var game

    private var greeting: String {

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good Morning, \(game.company.playerName)"
        case 12..<17:
            return "Good Afternoon, \(game.company.playerName)"
        default:
            return "Good Evening, \(game.company.playerName)"
        }
    }

    private var priorityText: String {

        let count = game.company.ceoBriefing.count

        switch count {

        case 0:
            return "Everything is running smoothly."

        case 1:
            return "1 executive decision requires attention."

        default:
            return "\(count) executive decisions require attention."

        }

    }

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text(greeting)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(game.company.name)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(RogueCircuitTheme.text)
                .shadow(
                    color: RogueCircuitTheme.signalGreen.opacity(0.28),
                    radius: 8,
                    y: 2
                )
                .lineLimit(2)
                .minimumScaleFactor(0.68)
                .padding(.vertical, 2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            RogueCircuitTheme.signalGreen.opacity(0.95),
                            RogueCircuitTheme.electricCyan.opacity(0.45),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 132, height: 3)
                .clipShape(Capsule())

            ViewThatFits(in: .horizontal) {

                HStack {

                    Label(
                        "Year \(game.company.currentYear)",
                        systemImage: "calendar"
                    )

                    Spacer()

                    Text("Month \(game.company.currentMonth)")

                }

                VStack(alignment: .leading, spacing: 6) {

                    Label(
                        "Year \(game.company.currentYear)",
                        systemImage: "calendar"
                    )

                    Text("Month \(game.company.currentMonth)")

                }

            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Divider()

            ViewThatFits(in: .horizontal) {

                HStack(alignment: .top, spacing: 12) {

                    Label(
                        game.company.companyStatus,
                        systemImage: "building.2.fill"
                    )
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)

                    Spacer()

                    Text(priorityText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(3)
                        .minimumScaleFactor(0.75)

                }

                VStack(alignment: .leading, spacing: 8) {

                    Label(
                        game.company.companyStatus,
                        systemImage: "building.2.fill"
                    )
                    .font(.headline)

                    Text(priorityText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                }
            }

        }
        .padding(20)
        .rogueCircuitCard(cornerRadius: 24)

    }

}

#Preview {

    CEOHeaderCard()
        .environment(GameManager())

}
