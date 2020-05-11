import Foundation
import TrueMotionCommon

class ViewModel2 {
    private var repository: TodoRepositoryAdapter
    private var repository2: TodoRepositoryAdapter

    private(set) var todoList: [TodoItemViewModel] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.delegate?.todoListChanged()
            }
        }
    }
    weak var delegate: ViewModelDelegate?

    init(repository: TodoRepositoryAdapter, repository2: TodoRepositoryAdapter) {
        print("VM2 init")
        self.repository = repository
        self.repository2 = repository2
        repository.todoListChanged = {[weak self] list in
            print("VM2 Repo1 list changed")
            DispatchQueue.main.async {
                self?.todoList = list.map { TodoItemViewModel(title: $0.title )}
                self?.delegate?.todoListChanged()
            }
        }
        repository2.todoListChanged = { list in
            print("VM2 Repo2 list changed")
        }
    }

    deinit {
        print("VM2 deinit")
    }

    func refresh() {
        repository.refresh(userId: 1) {[weak self] result in
            if case let Result.failure(error) = result {
                DispatchQueue.main.async {[weak self] in
                    print("VM2 Repo1 refresh error")
                    self?.delegate?.error(message: error.localizedDescription)
                }
            }
        }
    }
}
