//
//  GameHelpViewController.swift
//  LogicPuzzlesSwift
//
//  Created by 趙偉 on 2017/05/14.
//  Copyright © 2017年 趙偉. All rights reserved.
//

import UIKit

class GameHelpViewController: UITableViewController {

    private var gameDocument: GameDocumentBase { getGameDocument() }
    func getGameDocument() -> GameDocumentBase! { nil }
    var gameOptions: GameProgress { gameDocument.gameProgress }
    var markerOption: Int { gameOptions.option1?.toInt() ?? 0 }
    var allowedObjectsOnly: Bool { gameOptions.option2?.toBool() ?? false }

    // http://stackoverflow.com/questions/14111572/how-to-use-single-storyboard-uiviewcontroller-for-multiple-subclass
    override func awakeFromNib() {
        object_setClass(self, NSClassFromString("LogicPuzzlesSwift.\(currentGameName)HelpViewController").self!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        
        title = "\(currentGameTitle) Help"
    }
    
    @IBAction func backToGame(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameDocument.help.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! SelfSizingTableViewCell
        cell.label.text = gameDocument.help[indexPath.row]
        return cell
    }

    deinit {
        print("deinit called: \(NSStringFromClass(type(of: self)))")
    }
}
