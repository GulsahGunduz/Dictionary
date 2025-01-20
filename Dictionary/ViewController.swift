
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var wordList: [Words] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordTableView.delegate = self
        wordTableView.dataSource = self
        searchBar.delegate = self
        
        GetAllWords()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        let destinationVC = segue.destination as! DetailWordVC
        destinationVC.words = wordList[index!]
    }
    
    func GetAllWords(){
     
        let url = URL(string: "http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil || data == nil{
                print("Error")
                return
            }
            do{
                let json = try JSONDecoder().decode(DictionaryAnswer.self, from: data!)
                if let getWordList = json.kelimeler {
                    self.wordList = getWordList
                }
                
                DispatchQueue.main.async {
                    self.wordTableView.reloadData()
                }
            }catch{
                
            }
        }.resume()
    }

    func SearchWords(searchWord: String){

        var request = URLRequest(url: URL(string: "http://kasimadalan.pe.hu/sozluk/kelime_ara.php")!)
        request.httpMethod = "POST"
        let postString = "ingilizce=\(searchWord)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil{
                print("Error")
                return
            }
            do{
                let json = try JSONDecoder().decode(DictionaryAnswer.self, from: data!)
                if let getWordList = json.kelimeler {
                    self.wordList = getWordList
                }
                DispatchQueue.main.async {
                    self.wordTableView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordTableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! WordTableViewCell
        
        cell.engLabel.text = wordList[indexPath.row].ingilizce
        cell.turkLabel.text = wordList[indexPath.row].turkce
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchWords(searchWord: searchText)
    }
}
