# CustomTextView

CustomTextView makes easy to customise textview like textview size will change as text size increases.

#Documentation in progress...

## Sreenshots

## Feature
* Resizeable textview
* Character limit
* Show/hide send button
* TextView min - max height
* Support placeholder text

## How to use
Drag the folder "CustomTextView" with the source files into your project.

Create instance of CustomTextView
```swift
let customtTextView: CustomTextView = CustomTextView(frame: CGRectMake(0,80,320,40))
```
and start using it.
### Placeholder
#### Plain placeholder
```swift
customtTextView.placeholder = "Write something..."
```
#### Attributed placeholder
```swift
customtTextView.textView.placeholderAttributedText = NSAttributedString(string: "Write something...", 
                                                    attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1)])
```
### Character limit
```swift
var maxCharCount:Int?
```
### Show/hide total character
```swift
var showCharCount:Bool?
```
### Show/hide send button button on right side
```swift
var showSendButton:Bool
```
### Give padding to textview
```swift
var textViewInsets:UIEdgeInsets
```

## Delegates
This is optional delegate method and this is called whenever textview size is changed.
Parameters:
customTextView - TextView
```swift
func customTextViewDidResize(customTextView: CustomTextView)
```
This is optional delegate method. This method is called when user click on send button.
Parameters:
customTextView - TextView
message - String in textview
```swift
func customTextView(customTextView: CustomTextView, didSendMessage message: String)
```
This is optional delegate method. This method is called whenever character in textview change.This method can be ued to update character count.
Parameters:
currentChar - Total number of character currently present in textview.
maxChar - Max character allowed.
```swift
func updateCharacterCount(currentChar:Int,maxChar:Int)
```

##Contribution
Contributions are welcome.Just open an issue on GitHub to discuss a point or request a feature or send a Pull Request with your suggestion.

#License
CustomTextView is available under the [MIT license](https://github.com/sunilsharma08/CustomTextView/blob/master/LICENSE.md).
