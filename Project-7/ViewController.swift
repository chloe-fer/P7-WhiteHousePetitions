//
//  ViewController.swift
//  Project-7
//
//  Created by Chloe Fermanis on 19/8/21.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Whitehouse Petitions"
        // "https://api.whitehouse.gov/v1/peititions.json?limit=100"

        // Challenge 1: Credits button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        
        // Challenge 2: filter the petitions
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterTapped))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        
        navigationItem.leftBarButtonItems = [search, refresh]
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
                // OK to parse
            }
        }
        showError()
        
    }
    
    //MARK: - Search / Filter Alert Controller

    // Challenge 2: filter the petitions
    @objc func filterTapped() {
                
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            
            guard let answer = ac?.textFields?[0].text else { return }
            
            self?.submit(filter: answer)

        }
             
        ac.addAction(searchAction)
        present(ac, animated: true)

    }
    
    // Submit results to filter
    
    func submit(filter: String) {
        if filter.isEmpty {
            filteredPetitions = petitions
        } else {
            
            // filteredPetitions = petitions.filter { $0.title.contains(filter) }
            
            filteredPetitions.removeAll()
            for petition in petitions {
                if petition.title.contains(filter) {
                    filteredPetitions.append(petition)
                }
            }
        }
            
        tableView.reloadData()
        
    }

    //MARK: - Refresh List
    
    @objc func refreshList() {
        filteredPetitions = petitions
        tableView.reloadData()
    }

        

    
    //MARK: - Credit Alert Controller

    // Challenge 1: Credits button
    @objc func creditsTapped() {
        
        let ac = UIAlertController(title: "Credits", message: "Data comes from the We Are The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - Error Alert Controller

    func showError() {
        
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //MARK: - JSON Parse

    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    //MARK: - TableView setup

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

