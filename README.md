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

#### Plain text
```swift
customtTextView.placeholder = "Write something..."
```
#### Attributed text
```swift
customtTextView.textView.placeholderAttributedText = NSAttributedString(string: "Write something...", 
                                                    attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1)])
```
### Character limit
```swift
var maxCharCount:Int?
```
### Show total character
```swift
var showCharCount:Bool?
```
### Show send button button on right side
```swift
var showSendButton:Bool
```
### Give padding to textview
```swift
var textViewInsets:UIEdgeInsets
```

## Delegates
```swift
func customTextViewDidResize(chatInput: CustomTextView)
func customTextView(chatInput: CustomTextView, didSendMessage message: String)
func updateCharacterCount(currentChar:Int,maxChar:Int)
```

##Contribution
Contributions are welcome.Just open an issue on GitHub to discuss a point or request a feature or send a Pull Request with your suggestion.

#License
CustomTextView is available under the [MIT license](https://github.com/sunilsharma08/CustomTextView/blob/master/LICENSE.md).
