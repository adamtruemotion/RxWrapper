import Foundation

public struct TMCommon {

    public static let repository: TodoRepository = TodoRepositoryImpl()
    public static let repositoryWrapper = TodoRepositoryWrapperImpl(repository: repository)
    public static func getRepositoryAdapter(name: String) -> TodoRepositoryAdapter {
        return TodoRepositoryAdapterImpl(repository: repository, name: name)
    }

}
