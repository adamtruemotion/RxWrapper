import Foundation
import TrueMotionCommon

class ViewModel2 {
    private var repository: TodoRepositoryAdapter
    private(set) var todoList: [TodoItemViewModel] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.delegate?.todoListChanged()
            }
        }
    }
    weak var delegate: ViewModelDelegate?

    init(repository: TodoRepositoryAdapter) {
        self.repository = repository
        repository.todoListChanged = {[weak self] (list) in
            DispatchQueue.main.async {
                self?.todoList = list.map { TodoItemViewModel(title: $0.title )}
                self?.delegate?.todoListChanged()
            }
        }
    }


    func refresh() {
        repository.refresh(userId: 1) {[weak self] (result) in
            if case let Result.failure(error) = result {
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.error(message: error.localizedDescription)
                }
            }
        }
    }
}
