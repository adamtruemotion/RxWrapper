import Foundation

public struct TMCommon {

    public static let repository: TodoRepository = TodoRepositoryImpl()
    public static let repositoryWrapper = TodoRepositoryWrapperImpl(repository: repository) // TODO: use the protocol type instead
}
