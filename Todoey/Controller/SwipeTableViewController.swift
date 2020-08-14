//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Priyank Shah on 8/13/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
    }

    
    //MARK: - tableView data source methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    
    
    
  //MARK: - Swipe cell delegate methods

      func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
          guard orientation == .right else {
              return nil
          }
          let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
            
          }
          deleteAction.image = UIImage(named: "delete-icon")
          return [deleteAction]
      }
      
      
      func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
          var options = SwipeOptions()
          options.expansionStyle = .destructive
          return options
      }
    
    
    func updateModel(at indexPath: IndexPath) {
        //update data model
    }
  }

