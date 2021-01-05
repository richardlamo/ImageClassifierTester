//
//  ViewController.swift
//  ImageClassifierTester
//
//  Created by Richard Lam on 30/12/20.
//
import UIKit
import CoreML
import Vision

class ImageClassifierViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var predictionsTableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    
    var predictionList = [PredictionItem]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        predictionsTableView.dataSource = self
        predictionsTableView.delegate = self
        
        predictionsTableView.register(UINib(nibName: "PredictionTableViewCell", bundle: nil), forCellReuseIdentifier: "PredictionTableViewCellIdentifier")
        
        predictionsTableView.reloadData()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let convertedImage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert CIImage  ")
            }
            
            predictionList.removeAll()
            
            // detect(image: convertedImage)
            
            // Try Flower Classifier
            if let model = try? FlowerClassifier(configuration: MLModelConfiguration()).model {
                detect(image: convertedImage, mlModel: model, classifier: "Flower Classifier")
            }

            // Try MobileNetV2 Classifier
//            if let model = try? MobileNetV2(configuration: MLModelConfiguration()).model {
//                detect(image: convertedImage, mlModel: model)
//            }

            // Try Squeeze Net
            if let model = try? SqueezeNet(configuration: MLModelConfiguration()).model {
                detect(image: convertedImage, mlModel: model, classifier: "SqueezeNet")
            }

            print(predictionList.count)
            for item in predictionList {
                print(item)
            }
            // setup image view
            imageView.image = userPickedImage
            predictionsTableView.reloadData()
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage, mlModel: MLModel, classifier: String) {
        guard let model = try? VNCoreMLModel(for:  mlModel) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model : model) {
            (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            
            let identifier = classification?.identifier ?? ""
            let confidencePercentage = (classification?.confidence ?? 0.0 ) * 100.0
            
            let predictionItem = PredictionItem(classifier: classifier, identifier: identifier, confidence: confidencePercentage)
            self.predictionList.append(predictionItem)
            self.predictionsTableView.reloadData()
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @available(*, deprecated, message: "Use detect(image: CIImage, mlModel: MLModel ) instead.")
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for:  FlowerClassifier(configuration: MLModelConfiguration()).model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model : model) {
            (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            
            let identifier = classification?.identifier ?? ""
            let confidence = classification?.confidence ?? 0.0
            self.navigationItem.title = " \(identifier)  (\(confidence))"
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}


extension ImageClassifierViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(predictionList.count)
        return predictionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prediction = predictionList[indexPath.row]
        
        let cell = predictionsTableView.dequeueReusableCell(withIdentifier: "PredictionTableViewCellIdentifier", for: indexPath) as! PredictionTableViewCell
        cell.classifierLabel.text = prediction.classifier
        cell.identifiderLabel.text = prediction.identifier    
        cell.confidenceLabel.text = String(format: "%.2f %", prediction.confidence)
      
        return cell
    }
    
    
}

extension ImageClassifierViewController : UITableViewDelegate {
    
}
