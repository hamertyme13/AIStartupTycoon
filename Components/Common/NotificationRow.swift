import SwiftUI

struct NotificationRow: View {

    let notification: CompanyNotification

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(notification.title)
                .font(.headline)

            Text(notification.message)

            Text(
                "Year \(notification.year) • Month \(notification.month)"
            )
            .font(.caption)
            .foregroundStyle(.secondary)

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))

    }

}
//  NotificationRow.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//

