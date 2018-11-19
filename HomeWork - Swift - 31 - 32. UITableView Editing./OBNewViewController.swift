//
//  OBNewViewController.swift
//  HomeWork - Swift - 31 - 32. UITableView Editing.
//
//  Created by Oleksandr Bardashevskyi on 11/17/18.
//  Copyright © 2018 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class OBGroup: NSObject {
    var name = String()
    var studentsArray = [OBStudent]()
}

class OBNewViewController: UIViewController, UITableViewDataSource {
    
    //MARK: - Gloabal variales
    
    var tableView = UITableView()
    var groupsArray = [OBGroup]()
    var addButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    var sortMarkButton = UIButton()
    var sortNameButton = UIButton()
    
    override func loadView() {
        super.loadView()
        let tableView = UITableView.init(frame: CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height/9*8 - 2), style: UITableView.Style.grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        self.view.backgroundColor = .blue
        self.view.addSubview(tableView)
        self.tableView = tableView
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: -self.view.bounds.height/18, right: 0)
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Students"
        
        self.addButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                              target: self,
                                              action: #selector(actionAddSelection))
        self.navigationItem.leftBarButtonItem = self.addButton
        
        self.editButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                                               target: self,
                                               action: #selector(actionEdit))
        self.navigationItem.rightBarButtonItem = self.editButton
        
        //MARK: - Sorted students by average mark
        self.sortMarkButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.sortMarkButton.frame = CGRect(x: 0,
                                          y: self.view.bounds.height/9*8,
                                          width: self.view.bounds.width/2 - 1.5,
                                          height: self.view.bounds.height/9)
        
        self.sortMarkButton.setTitle("Sorted by mark", for: UIControl.State.normal)
        self.sortMarkButton.addTarget(self, action: #selector(actionSortMarkButton), for: UIControl.Event.touchUpInside)
        self.sortMarkButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sortMarkButton.backgroundColor = UIColor.darkGray
        self.sortMarkButton.layer.borderWidth = 10
        self.sortMarkButton.layer.borderColor = UIColor.white.cgColor
        self.sortMarkButton.showsTouchWhenHighlighted = true
        self.view.addSubview(self.sortMarkButton)
        
        //MARK: - Sorted students by average name
        self.sortNameButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.sortNameButton.frame = CGRect(x: self.view.bounds.width/2 + 1,
                                           y: self.view.bounds.height/9*8,
                                           width: self.view.bounds.width/2 - 1.5,
                                           height: self.view.bounds.height/9)
        
        self.sortNameButton.setTitle("Sorted by name", for: UIControl.State.normal)
        self.sortNameButton.addTarget(self, action: #selector(actionSortNameButton), for: UIControl.Event.touchUpInside)
        self.sortNameButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sortNameButton.backgroundColor = UIColor.darkGray
        self.sortNameButton.layer.borderWidth = 10
        self.sortNameButton.layer.borderColor = UIColor.white.cgColor
        self.sortNameButton.showsTouchWhenHighlighted = true
        self.view.addSubview(self.sortNameButton)
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Buttons. Selector functions.
    @objc func actionSortMarkButton(sender: UIButton) {
        if !self.tableView.isEditing {
            var group = self.groupsArray
            for i in 0..<self.groupsArray.count {
                group[i].studentsArray = self.groupsArray[i].studentsArray.sorted{$0.averageGrade > $1.averageGrade}
            }
            self.groupsArray = group
            
            self.sortMarkButton.setTitle("Done", for: UIControl.State.normal)
            self.sortMarkButton.setTitleColor(UIColor.green, for: UIControl.State.normal)
            self.sortNameButton.setTitle("Sorted by name", for: UIControl.State.normal)
            self.sortNameButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            self.tableView.reloadData()
        }
    }
    @objc func actionSortNameButton(sender: UIButton) {
        if !self.tableView.isEditing {
            var group = self.groupsArray
            for i in 0..<self.groupsArray.count {
                group[i].studentsArray = self.groupsArray[i].studentsArray.sorted{$0.firstName < $1.firstName}
            }
            
            self.groupsArray = group
            self.sortNameButton.setTitle("Done", for: UIControl.State.normal)
            self.sortNameButton.setTitleColor(UIColor.green, for: UIControl.State.normal)
            self.sortMarkButton.setTitle("Sorted by mark", for: UIControl.State.normal)
            self.sortMarkButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            self.tableView.reloadData()
        }
    }
    
    @objc func actionEdit(sender: UIBarButtonItem) {
        
        
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        var item = UIBarButtonItem.SystemItem.edit
        if self.tableView.isEditing {
            item = UIBarButtonItem.SystemItem.done
        }
        self.editButton = UIBarButtonItem.init(barButtonSystemItem: item,
                                               target: self,
                                               action: #selector(actionEdit))
        self.navigationItem.setRightBarButton(self.editButton, animated: true)
        
    }
    @objc func actionAddSelection(sender: UIBarButtonItem) {
        if !self.tableView.isEditing {
            let group = OBGroup()
            group.name = "Group # \(self.groupsArray.count + 1)"
            let newSectionIndex = 0
            
            self.groupsArray.insert(group, at: newSectionIndex)
            self.tableView.beginUpdates()
            
            let insertSection = NSIndexSet.init(index: newSectionIndex)
            self.tableView.insertSections(insertSection as IndexSet, with: UITableView.RowAnimation.left)
            
            self.tableView.endUpdates()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    //MARK: - UITableViewDataSource Moving rows.
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        self.sortMarkButton.setTitle("Sorted by mark", for: UIControl.State.normal)
        self.sortMarkButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sortNameButton.setTitle("Sorted by name", for: UIControl.State.normal)
        self.sortNameButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let sourceGroup = self.groupsArray[sourceIndexPath.section]
        let student = sourceGroup.studentsArray[sourceIndexPath.row - 1]
        
        var tempArray = sourceGroup.studentsArray
        
        if sourceIndexPath.section == destinationIndexPath.section {
            tempArray.swapAt(sourceIndexPath.row - 1, destinationIndexPath.row - 1)
            sourceGroup.studentsArray = tempArray
        } else {
            tempArray.remove(at: sourceIndexPath.row - 1)
            sourceGroup.studentsArray = tempArray
            
            
            let destinationGroup = self.groupsArray[destinationIndexPath.section]
            tempArray = destinationGroup.studentsArray
            tempArray.insert(student, at: destinationIndexPath.row - 1)
            destinationGroup.studentsArray = tempArray
        }
    }
    
    //MARK: - UITableViewDataSource Format Cells.
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupsArray[section].studentsArray.count + 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupsArray[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let addStudentidentifire = "Add Cell"
            var cell = tableView.dequeueReusableCell(withIdentifier: addStudentidentifire)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: addStudentidentifire)
                cell?.textLabel?.text = "Add New Student"
                cell?.textLabel?.textColor = .blue
            }
            return cell!
        } else {
            let studentIdentifire = "Cell"
            var cell = tableView.dequeueReusableCell(withIdentifier: studentIdentifire)
            if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: studentIdentifire)
            }
            
            let group = self.groupsArray[indexPath.section]
            let student = group.studentsArray[indexPath.row - 1]
            if student.averageGrade >= 4 {
                cell?.detailTextLabel?.textColor = UIColor.green
            } else if  student.averageGrade < 4 && student.averageGrade >= 3 {
                cell?.detailTextLabel?.textColor = UIColor.orange
            } else {
                cell?.detailTextLabel?.textColor = UIColor.red
            }
            cell?.textLabel?.text = "\(student.firstName) \(student.lastName)"
            cell?.detailTextLabel?.text = String(formatString(places: student.averageGrade))
            return cell!
        }
    }
    //MARK: - Actions with Delete Button.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            self.sortMarkButton.setTitle("Sorted by mark", for: UIControl.State.normal)
            self.sortMarkButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.sortNameButton.setTitle("Sorted by name", for: UIControl.State.normal)
            self.sortNameButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            let sourceGroup = self.groupsArray[indexPath.section]
            var tempArray = sourceGroup.studentsArray
            
            tempArray.remove(at: indexPath.row - 1)
            sourceGroup.studentsArray = tempArray
            
            self.tableView.beginUpdates()
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            self.tableView.endUpdates()
        }
    }
    //MARK: -  Format String Function.
    func formatString(places:Float) -> String{
        let aStr = String(format: "%05.2f", places)
        return aStr
    }
}


//MARK: - UITableViewDelegate.
extension OBNewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row == 0 ? UITableViewCell.EditingStyle.none : UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    //MARK: - Actions with selected row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            
            self.sortMarkButton.setTitle("Sorted by mark", for: UIControl.State.normal)
            self.sortMarkButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.sortNameButton.setTitle("Sorted by name", for: UIControl.State.normal)
            self.sortNameButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            
            let group = self.groupsArray[indexPath.section]
            var tempArray = [OBStudent]()
            
            tempArray = group.studentsArray
            let randomStudent = OBStudent()
            let newStudentIndex = 0
            tempArray.insert(randomStudent.randomStudent(), at: newStudentIndex)
            group.studentsArray = tempArray
            
            self.tableView.beginUpdates()
            
            let newIndexPath = NSIndexPath.init(item: newStudentIndex + 1, section: indexPath.section)
            self.tableView.insertRows(at: [newIndexPath as IndexPath], with: UITableView.RowAnimation.middle)
            
            self.tableView.endUpdates()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
}
