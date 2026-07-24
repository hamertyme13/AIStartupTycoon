import SwiftUI

struct TimeCard: View {

    let year: Int
    let month: Int

    var body: some View {

        HStack {

            Image(systemName: "calendar")

            VStack(alignment: .leading) {

                Text("Year \(year)")
                    .bold()

                Text("Month \(month)")
                    .foregroundStyle(.secondary)

            }

            Spacer()

        }
        .padding()
        .background(.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

#Preview {

    TimeCard(year: 1, month: 3)

}
//  TimeCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/2/26.
//

