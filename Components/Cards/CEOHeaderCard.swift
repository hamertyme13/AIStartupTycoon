import SwiftUI

struct CEOHeaderCard: View {

    @Environment(GameManager.self) private var game

    private var greeting: String {

        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good Morning, Joshua"
        case 12..<17:
            return "Good Afternoon, Joshua"
        default:
            return "Good Evening, Joshua"
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
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {

                Label(
                    "Year \(game.company.currentYear)",
                    systemImage: "calendar"
                )

                Spacer()

                Text("Month \(game.company.currentMonth)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Divider()

            HStack {

                Label(
                    game.company.companyStatus,
                    systemImage: "building.2.fill"
                )
                .font(.headline)

                Spacer()

                Text(priorityText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)

            }

        }
        .padding(24)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))

    }

}

#Preview {

    CEOHeaderCard()
        .environment(GameManager())

}
