//
//  FruitsAndBerriesInteractor.swift
//  iOS-Test
//

import UIKit

// Implemented by Interactor
protocol FruitsAndBerriesBusinessLogic {
    // Loads the list of items and passes Load.Response to Presenter
    func load(request: FruitsAndBerriesModels.Load.Request)
    // Loads details for a specific item and passes LoadDetails.Response to Presenter
    func loadDetails(request: FruitsAndBerriesModels.LoadDetails.Request, completion: @escaping (FruitsAndBerriesModels.LoadDetails.Response) -> Void)
}
final class FruitsAndBerriesInteractor {
    public var presenter: FruitsAndBerriesPresentationLogic?
}
extension FruitsAndBerriesInteractor: FruitsAndBerriesBusinessLogic {
    func load(request: FruitsAndBerriesModels.Load.Request) {
        // Fetch data from the API endpoint
        fetchData { [weak self] items in
            let response = FruitsAndBerriesModels.Load.Response(items: items)
            self?.presenter?.present(response: response)
        }
    }
    func loadDetails(request: FruitsAndBerriesModels.LoadDetails.Request, completion: @escaping (FruitsAndBerriesModels.LoadDetails.Response) -> Void) {
        // Fetch additional details from the API endpoint
        fetchDetails(itemId: request.itemId) { text in
            let response = FruitsAndBerriesModels.LoadDetails.Response(text: text)
            completion(response)
        }
    }
    
    private func fetchData(completion: @escaping ([FruitsAndBerriesModels.Load.ViewModel.Item]) -> Void) {
        guard let baseURL = URL(string: "https://test-task-server.mediolanum.f17y.com") else {
            // Handle invalid base URL
            completion([])
            return
        }
        guard let url = URL(string: "/items/random", relativeTo: baseURL) else {
            // Handle invalid URL
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                // Handle network error
                completion([])
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(FruitsAndBerriesResponse.self, from: data)
                let items = responseData.items.map { item in
                    // Combine baseURL and image URL to get the complete image URL
                    guard let imageURL = URL(string: item.image, relativeTo: baseURL),
                          let imageData = try? Data(contentsOf: imageURL),
                          let image = UIImage(data: imageData) else {
                        // Handle image download or conversion error
                        return FruitsAndBerriesModels.Load.ViewModel.Item(
                            id: item.id,
                            name: item.name,
                            image: nil,
                            color: item.color
                        )
                    }
                    return FruitsAndBerriesModels.Load.ViewModel.Item(
                        id: item.id,
                        name: item.name,
                        image: image,
                        color: item.color
                    )
                }
                completion(items)
            } catch {
                // Handle JSON decoding error
                completion([])
            }
        }.resume()
    }
    private func fetchDetails(itemId: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://test-task-server.mediolanum.f17y.com/texts/\(itemId)") else {
            // Handle invalid URL
            completion("")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                // Handle network error
                completion("")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(FruitsAndBerriesDetailsResponse.self, from: data)
                let text = responseData.text
                completion(text)
            } catch {
                // Handle JSON decoding error
                completion("")
            }
        }.resume()
    }
    // Define Codable structs for response parsing
    struct FruitsAndBerriesResponse: Codable {
        let items: [Item]
        
        struct Item: Codable {
            let id: String
            let name: String
            let image: String
            let color: String
        }
    }
    struct FruitsAndBerriesDetailsResponse: Codable {
        let text: String
    }
}
