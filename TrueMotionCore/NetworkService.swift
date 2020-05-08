import Foundation
import RxSwift

public protocol NetworkService: class {
    func request<Model: Decodable>(type: Model.Type,
                                   endpoint: URL,
                                   method: String) -> Single<Model>
}

public enum NetworkError: Error {
    case decodingError
    case unknownError

    var localizedDescription: String {
        return "Network error"
    }
}

class NetworkServiceImpl: NetworkService {
    let decoder = JSONDecoder()
    let session: URLSession

    public init() {
        session = URLSession(configuration: .default)
    }

    public func request<Model: Decodable>(type: Model.Type,
                                          endpoint: URL,
                                          method: String) -> Single<Model> {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return Single.create {[weak self] (subscribtion) -> Disposable in
            guard let strongSelf = self else { return Disposables.create { }}
            let dataTask = strongSelf.session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    subscribtion(.error(error))
                } else if let data = data {
                    do {
                        let model = try strongSelf.decoder.decode(Model.self, from: data)
                        // random error
                        if Int.random(in: 0...10) < 3 {
                            subscribtion(.error(NetworkError.unknownError))
                        } else {
                            subscribtion(.success(model))
                        }
                    } catch  {
                        subscribtion(.error(NetworkError.decodingError))
                    }
                } else {
                    subscribtion(.error(NetworkError.unknownError))
                }
            })
            dataTask.resume()

            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
