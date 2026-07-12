//
//  SaveManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

import Foundation

struct SaveManager {

    static let currentSchemaVersion = 4

    struct SaveData: Codable {

        var schemaVersion: Int
        var company: CompanySnapshot
        var secondsElapsed: Int
        var gameSpeed: GameSpeed
        var gameOutcome: GameOutcome?
        var hasStartedGame: Bool

        init(
            schemaVersion: Int = SaveManager.currentSchemaVersion,
            company: CompanySnapshot,
            secondsElapsed: Int,
            gameSpeed: GameSpeed,
            gameOutcome: GameOutcome?,
            hasStartedGame: Bool
        ) {

            self.schemaVersion = schemaVersion
            self.company = company
            self.secondsElapsed = secondsElapsed
            self.gameSpeed = gameSpeed
            self.gameOutcome = gameOutcome
            self.hasStartedGame = hasStartedGame

        }

        private enum CodingKeys: String, CodingKey {

            case schemaVersion
            case company
            case secondsElapsed
            case gameSpeed
            case gameOutcome
            case hasStartedGame

        }

        init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            schemaVersion = try container.decodeIfPresent(
                Int.self,
                forKey: .schemaVersion
            ) ?? 1

            company = try container.decode(
                CompanySnapshot.self,
                forKey: .company
            )

            secondsElapsed = try container.decodeIfPresent(
                Int.self,
                forKey: .secondsElapsed
            ) ?? 0

            gameSpeed = try container.decodeIfPresent(
                GameSpeed.self,
                forKey: .gameSpeed
            ) ?? .paused

            gameOutcome = try container.decodeIfPresent(
                GameOutcome.self,
                forKey: .gameOutcome
            )

            hasStartedGame = try container.decodeIfPresent(
                Bool.self,
                forKey: .hasStartedGame
            ) ?? true

        }

    }

    struct CompanySnapshot: Codable {

        var name: String
        var playerName: String?
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
        var companyPerkPoints: Int?
        var unlockedCompanyPerks: Set<Company.CompanyPerk>?
        var completedContracts: Int?
        var availableContracts: [Company.ContractOpportunity]?
        var unlockedAchievements: Set<Company.GameAchievement>?
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
        var marketSegments: [Company.MarketSegment]?
        var frontierProjects: [Company.FrontierProject]?

        init(company: Company) {

            name = company.name
            playerName = company.playerName
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
            companyPerkPoints = company.companyPerkPoints
            unlockedCompanyPerks = company.unlockedCompanyPerks
            completedContracts = company.completedContracts
            availableContracts = company.availableContracts
            unlockedAchievements = company.unlockedAchievements
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
            marketSegments = company.marketSegments
            frontierProjects = company.frontierProjects

        }

        func restoreCompany() -> Company {

            let company = Company()

            company.name = name
            company.playerName = playerName ?? "Founder"
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
            company.companyPerkPoints = companyPerkPoints ?? 0
            company.unlockedCompanyPerks = unlockedCompanyPerks ?? []
            company.completedContracts = completedContracts ?? 0
            company.availableContracts = availableContracts ?? []
            company.unlockedAchievements = unlockedAchievements ?? []
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
            company.marketSegments = marketSegments ?? company.marketSegments
            company.frontierProjects = frontierProjects ?? company.frontierProjects

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

            var migratedData = data
            migratedData.schemaVersion = currentSchemaVersion

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            let encoded = try encoder.encode(migratedData)

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

            var saveData = try JSONDecoder().decode(
                SaveData.self,
                from: data
            )

            if saveData.schemaVersion < currentSchemaVersion {

                saveData.schemaVersion = currentSchemaVersion
                save(saveData)

            }

            return saveData

        } catch {

            print("Save load failed: \(error)")
            return nil

        }

    }

    static func deleteSave() {

        try? FileManager.default.removeItem(at: saveURL)

    }

}
