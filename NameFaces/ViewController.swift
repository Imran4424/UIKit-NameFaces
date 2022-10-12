//
//  ViewController.swift
//  NameFaces
//
//  Created by Shah Md Imran Hossain on 17/9/22.
//

import UIKit

class ViewController: UICollectionViewController {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        guard let savedPeople = defaults.object(forKey: "people") as? Data else {
            print("saved data fetching failed")
            return
        }
        
        print("savedPeople data fetching successful")
        
        // below guard let not working, need to fix it
        guard let decodedPeople = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Person.self], from: savedPeople) as? [Person] else {
            print("decode failed")
            return
        }
        
        people = decodedPeople
    }
    
    @objc func addNewPerson() {
        // image picker will pick image from either camera or gallery
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func save() {
        guard let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) else {
            print("data saving failed")
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "people")
        print("data save successful")
    }
}

// MARK: - Collection View datasource
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as? PersonCell else {
            print("Unable to dequeue Person Cell")
            fatalError("Unable to dequeue Person Cell")
        }
        
        let person = people[indexPath.item]
        cell.personName.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.personImage.image = UIImage(contentsOfFile: path.path)
        
        cell.personImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.personImage.layer.borderWidth = 2
        cell.personImage.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7

        return cell
    }
}

// MARK: - CollectionViewDelegate
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {
                print("Input text is nil, renaming failed")
                return
            }
            
            person.name = newName
            //self?.people[indexPath.item] = person
            self?.save()
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

// MARK: - Image Picker Delegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("Editied image failed as UIImage")
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            print("jpegData creation failed")
            return
        }
        
        try? jpegData.write(to: imagePath)
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}
