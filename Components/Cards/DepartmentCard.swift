import SwiftUI

struct DepartmentCard<Destination: View>: View {

    let title: String
    let subtitle: String
    let icon: String

    let stat1Title: String
    let stat1Value: String

    let stat2Title: String
    let stat2Value: String

    @ViewBuilder let destination: () -> Destination

    var body: some View {

        NavigationLink {

            destination()

        } label: {

            VStack(alignment: .leading, spacing: 16) {

                HStack {

                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)

                    VStack(alignment: .leading) {

                        Text(title)
                            .font(.headline)

                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)

                }

                Divider()

                HStack {

                    VStack(alignment: .leading) {

                        Text(stat1Title)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(stat1Value)
                            .font(.headline)

                    }

                    Spacer()

                    VStack(alignment: .trailing) {

                        Text(stat2Title)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(stat2Value)
                            .font(.headline)

                    }

                }

            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        }
        .buttonStyle(.plain)

    }

}
