import UIKit
import RxSwift
import TrueMotionCommon

class ReactiveListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: ReactiveViewModel!
    private var disposeBag: DisposeBag!
    private var list: [TodoItemViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ReactiveViewModel(repository: TMCommon.repository)
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        viewModel.todoList.subscribe(onNext: {[weak self] (list) in
            self?.list = list
            self?.tableView.reloadData()
        },
         onError: {[weak self] (error) in
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(cancel)
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)
        viewModel.refresh()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = nil
    }
}

extension ReactiveListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = list[indexPath.row].title
        return cell
    }
}
