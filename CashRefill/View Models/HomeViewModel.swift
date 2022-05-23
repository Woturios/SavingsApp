//
//  HomeViewModel.swift
//  CashRefill
//
//  Created by Jan Antonowicz on 19/05/2022.
//

import Foundation
import SwiftUI
import CoreData

class HomeViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [PostEntity] = []
    
    @Published var changeTheme: Bool = false
    
    @Published var textFieldName: String = ""
    @Published var textFieldPrice: String = ""
    @Published var portfolioSummary: Double = 0
    @AppStorage("goal") var goal: String = ""
    @Published var goalPercentage: Double = 0
    @Published var selectedTab: Int = 0
    
    init() {
        container = NSPersistentContainer(name: "ItemsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchPortfolio()
        updatePortfolio()
        updateGoalPercentage()
//        loadColors()
    }

    func fetchPortfolio() {
        let request = NSFetchRequest<PostEntity>(entityName: "PostEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func updatePortfolio() {
        portfolioSummary = savedEntities.sum(\.price)
    }
    
    func addPost(text: String, price: String) {
        let newPost = PostEntity(context: container.viewContext)
        newPost.name = text
        newPost.price = Double(price) ?? 0
        saveData()
        updateGoalPercentage()
    }
    
    func deletePost(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
        updateGoalPercentage()
    }
    
//    func loadColors() {
//        if selectedTab == 0 {
//            accentColor = Color.blue
//        } else if selectedTab == 1 {
//            accentColor = Color.orange
//        } else {
//            accentColor = Color.green
//        }
//    }
    
    /*
//    func updatePost(entity: PostEntity) {
//        let currentName = entity.name ?? ""
//        let currentPrice = entity.price
//        let newName = currentName + "!"
//        let newPrice = currentPrice + 10
//        entity.name = newName
//        entity.price = newPrice
//        saveData()
//    }
     */
    
    func updateGoalPercentage() {
        goalPercentage = Double((portfolioSummary / (Double(goal) ?? 0) * 100))
    }
    
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchPortfolio()
            portfolioSummary = savedEntities.sum(\.price)
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
}
