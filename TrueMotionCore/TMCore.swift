import Foundation

public struct TMCore {
    public static let networkService: NetworkService = NetworkServiceImpl()
    public static let networkServiceWrapper: NetworkServiceWrapper = NetworkServiceWrapperImpl(service: networkService)
}
