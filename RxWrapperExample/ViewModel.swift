import Foundation
import TrueMotionCommon

protocol ViewModelDelegate: class {
    func todoListChanged()
    func error(message: String)
}

class ViewModel {

    private var repository: TodoRepositoryWrapperImpl
    private(set) var todoList: [TodoItemViewModel] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.delegate?.todoListChanged()
            }
        }
    }
    weak var delegate: ViewModelDelegate?

    init(repository: TodoRepositoryWrapperImpl) {
        self.repository = repository
        repository.add(delegate: self)
    }

    deinit {
        repository.remove(delegate: self)
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

extension ViewModel: TodoRepositoryWrapperDelegate {
    func todoListChanged(list: [TodoModel]) {
        self.todoList = list.map { TodoItemViewModel(title: $0.title) }
    }
}
