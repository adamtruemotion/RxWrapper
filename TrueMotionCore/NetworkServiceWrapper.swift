import Foundation
import RxSwift

public protocol NetworkServiceWrapper: class {

}

class NetworkServiceWrapperImpl: NetworkServiceWrapper {

    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }
}
