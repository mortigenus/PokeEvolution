//
//  APIClient.swift
//  PokeEvolution
//
//  Created by Ivan Chalov on 16/07/2019.
//  Copyright © 2019 Ivan Chalov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)

    @inlinable public func flatMap<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .success(let data):
            return .success(transform(data))
        case .failure(let e):
            return .failure(e)
        }
    }
}

class APIClient {

    let urlBuilder = PokemonURLBuilder(baseURL: URL(staticString: "https://pokeapi.co/api/v2/"))
    let cache: URLCache
    let urlSession: URLSession
    let decoder: JSONDecoder
    let pokemonInfoQueue: OperationQueue

    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        pokemonInfoQueue = OperationQueue()
        pokemonInfoQueue.maxConcurrentOperationCount = 4

        let config = URLSessionConfiguration.default
        let cacheCapacity = 10 * 1024 * 1024
        cache = URLCache(memoryCapacity: cacheCapacity, diskCapacity: cacheCapacity, diskPath: "urlCache")
        config.urlCache = cache
        config.requestCachePolicy = .returnCacheDataElseLoad
        urlSession = URLSession(configuration: config)
    }

    func fetchPokemonList(force: Bool = false, completion: @escaping (Result<PokemonListResponse>) -> Void) {
        if force {
            // force fetching pokemon list clears the cache completely
            cache.removeAllCachedResponses()
        }

        let url = urlBuilder.pokemonListURL()
        fetch(url, force: force, completion: completion)
    }

    @discardableResult
    func fetchPokemonInfo(_ pokemon: NamedAPIResource, force: Bool = false, completion: @escaping (Result<PokemonInfoResponse>) -> Void) -> Operation {
        let operation = BlockOperation { [weak self] in
            guard let `self` = self else { return }
            self.fetch(pokemon.url, force: force, completion: completion)
        }
        pokemonInfoQueue.addOperation(operation)
        return operation
    }

    func fetchEvolutionChain(_ chain: APIResource, force: Bool = false, completion: @escaping (Result<EvolutionChainResponse>) -> Void) {
        fetch(chain.url, force: force, completion: completion)
    }

    private func fetch<T: Decodable>(_ url: URL, force: Bool, completion: @escaping (Result<T>) -> Void) {
        let urlRequest = URLRequest(url: url)
        if !force, let cachedData = cache.cachedResponse(for: urlRequest) {
            DispatchQueue.main.async {
                completion(self.handle(data: cachedData.data, error: nil))
            }
        } else {
            urlSession.dataTask(with: url) { [weak self] data, response, err in
                guard let `self` = self else { return }
                if let response = response, let data = data {
                    self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: urlRequest)
                }

                let result: Result<T> = self.handle(data: data, error: err)

                DispatchQueue.main.async {
                    completion(result)
                }
            }.resume()
        }
    }

    private func handle<T: Decodable>(data: Data?, error: Error?) -> Result<T> {
        guard error == nil else {
            return .failure(error!)
        }

        guard let data = data else {
            return .failure(NSError()) //TODO use custom error here
        }

        do {
            let decoded = try self.decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

}
