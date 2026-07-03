import Foundation

struct ResearchManager {

    static func research(company: inout Company, index: Int) {

        guard company.technologies.indices.contains(index) else { return }

        guard !company.technologies[index].completed else { return }

        company.technologies[index].progress += 10

        if company.technologies[index].progress >=
            company.technologies[index].requiredResearch {

            company.technologies[index].completed = true

            company.latestNews =
            "🧠 Research completed: \(company.technologies[index].name)"

        }

    }

}
//  ResearchManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

