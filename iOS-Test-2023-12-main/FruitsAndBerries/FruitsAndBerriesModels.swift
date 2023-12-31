//
//  FruitsAndBerriesModels.swift
//  iOS-Test
//
import UIKit

enum FruitsAndBerriesModels {
    // Models for "load (list)" use case
    struct Load {
        // Request is passed to Interactor
        struct Request {}
        // Response is passed from Interactor to Presenter
        struct Response {
            let items: [Load.ViewModel.Item]
        }
        // View model is generated by Presenter and passed to View
        struct ViewModel {
            struct Item {
                let id: String
                let name: String
                let image: UIImage?
                let color: String
            }
            let items: [Item]
        }
    }
    
    // Models for "load details" use case
    struct LoadDetails {
        // Request is passed to Interactor
        struct Request {
            let itemId: String
        }
        // Response is passed from Interactor to Presenter
        struct Response {
            let text: String
        }
        // View model is generated by Presenter and passed to View
        struct ViewModel {
            let text: String
        }
    }
}