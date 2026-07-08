//
//  SaveManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

import Foundation

struct SaveManager {

    struct SaveData: Codable {

        var company: CompanySnapshot
        var secondsElapsed: Int
        var gameSpeed: GameSpeed
        var gameOutcome: GameOutcome?
        var hasStartedGame: Bool

    }

    struct CompanySnapshot: Codable {

        var name: String
        var ceoBriefing: [CEOMessage]
        var cash: Double
        var monthlyRevenue: Double
        var companyValue: Double
        var marketShare: Double
        var lifetimeRevenue: Double
        var customerSatisfaction: Int
        var churnRisk: Double
        var selectedScenario: Company.Scenario
        var activeWorldEvent: Company.WorldEvent?
        var activeWorldEventMonthsRemaining: Int
        var completedTutorialSteps: Set<String>
        var marketingBudget: Double
        var marketingLevel: Int
        var reputation: Int
        var customerGrowthMultiplier: Double
        var latestNews: String
        var notifications: [CompanyNotification]
        var employees: [Employee]
        var talentMarket: [Candidate]
        var activeResearch: UUID?
        var products: [Product]
        var investors: [Investor]
        var activeInvestors: [Investor]
        var founderOwnership: Double
        var currentMonth: Int
        var currentYear: Int
        var researchPoints: Double
        var technologies: [Technology]
        var aiModels: [AIModel]
        var officeLevel: Int
        var offices: [Office]
        var serverCost: Double
        var researchExpense: Double
        var competitors: [Competitor]

        init(company: Company) {

            name = company.name
            ceoBriefing = company.ceoBriefing
            cash = company.cash
            monthlyRevenue = company.monthlyRevenue
            companyValue = company.companyValue
            marketShare = company.marketShare
            lifetimeRevenue = company.lifetimeRevenue
            customerSatisfaction = company.customerSatisfaction
            churnRisk = company.churnRisk
            selectedScenario = company.selectedScenario
            activeWorldEvent = company.activeWorldEvent
            activeWorldEventMonthsRemaining =
                company.activeWorldEventMonthsRemaining
            completedTutorialSteps = company.completedTutorialSteps
            marketingBudget = company.marketingBudget
            marketingLevel = company.marketingLevel
            reputation = company.reputation
            customerGrowthMultiplier = company.customerGrowthMultiplier
            latestNews = company.latestNews
            notifications = company.notifications
            employees = company.employees
            talentMarket = company.talentMarket
            activeResearch = company.activeResearch
            products = company.products
            investors = company.investors
            activeInvestors = company.activeInvestors
            founderOwnership = company.founderOwnership
            currentMonth = company.currentMonth
            currentYear = company.currentYear
            researchPoints = company.researchPoints
            technologies = company.technologies
            aiModels = company.aiModels
            officeLevel = company.officeLevel
            offices = company.offices
            serverCost = company.serverCost
            researchExpense = company.researchExpense
            competitors = company.competitors

        }

        func restoreCompany() -> Company {

            let company = Company()

            company.name = name
            company.ceoBriefing = ceoBriefing
            company.cash = cash
            company.monthlyRevenue = monthlyRevenue
            company.companyValue = companyValue
            company.marketShare = marketShare
            company.lifetimeRevenue = lifetimeRevenue
            company.customerSatisfaction = customerSatisfaction
            company.churnRisk = churnRisk
            company.selectedScenario = selectedScenario
            company.activeWorldEvent = activeWorldEvent
            company.activeWorldEventMonthsRemaining =
                activeWorldEventMonthsRemaining
            company.completedTutorialSteps = completedTutorialSteps
            company.marketingBudget = marketingBudget
            company.marketingLevel = marketingLevel
            company.reputation = reputation
            company.customerGrowthMultiplier = customerGrowthMultiplier
            company.latestNews = latestNews
            company.notifications = notifications
            company.employees = employees
            company.talentMarket = talentMarket
            company.activeResearch = activeResearch
            company.products = products
            company.investors = investors
            company.activeInvestors = activeInvestors
            company.founderOwnership = founderOwnership
            company.currentMonth = currentMonth
            company.currentYear = currentYear
            company.researchPoints = researchPoints
            company.technologies = technologies
            company.aiModels = aiModels
            company.officeLevel = officeLevel
            company.offices = offices
            company.serverCost = serverCost
            company.researchExpense = researchExpense
            company.competitors = competitors

            return company

        }

    }

    private static var saveURL: URL {

        let directory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent(
            "AIStartupTycoon",
            isDirectory: true
        )

        try? FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        return directory.appendingPathComponent("savegame.json")

    }

    static func save(_ data: SaveData) {

        do {

            let encoded = try JSONEncoder().encode(data)

            try encoded.write(
                to: saveURL,
                options: [.atomic]
            )

        } catch {

            print("Save failed: \(error)")

        }

    }

    static func load() -> SaveData? {

        do {

            let data = try Data(contentsOf: saveURL)

            return try JSONDecoder().decode(
                SaveData.self,
                from: data
            )

        } catch {

            return nil

        }

    }

    static func deleteSave() {

        try? FileManager.default.removeItem(at: saveURL)

    }

}
