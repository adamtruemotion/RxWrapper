import UIKit
import TrueMotionCommon

class ListViewController2: UIViewController {

    private var viewModel: ViewModel2!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel2(repository: TMCommon.getRepositoryAdapter())
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.refresh()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.delegate = nil
    }
}

extension ListViewController2: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = viewModel.todoList[indexPath.row].title
        return cell
    }
}

extension ListViewController2: ViewModelDelegate {
    func todoListChanged() {
        tableView.reloadData()
    }

    func error(message: String) {
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
