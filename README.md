![NICE Consulting Banner](Documentation/NiceConsultingBanner.png =438x200)

# ImageClassifierTester

This is an iOS App to test the accuracy of multiple image classifiers. This demo already includes the following classifiers.

* MobileNetV2
* Resnet50FP16
* Squeezenet
* MNIST Classifier (Digit Classifier)

The above models and more can be found under Apple's [Core ML Models](https://developer.apple.com/machine-learning/models/).


## How it works
The App works by taking photo within the app using the camera on your iOS device. It then makes predictions via each classifier requested. It puts all the top result from each classification to display in a Table View.

![Demo Screenshot](Documentation/Demo.png)



## Adding a new model for testing.

To test a custom or new image classifier, you must implement this in Apple's mlmodel format.

Once you have your model then all you have to do is add the following statement using the new model in ImageClassifierViewController.imagePickerController(..). See the Comment for exact location.

>if let model = try? *<Your Model Class Name>*(configuration: MLModelConfiguration()).model {
>    detect(image: convertedImage, mlModel: model, classifier: "MNISTClassifier")
>}

Once you've done that then you will see your classifier's results added to the Table View.
