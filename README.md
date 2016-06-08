# CustomTextView

CustomTextView makes easy to customise textview like textview size will change as text size increases.

## Feature
* Resizeable textview
* Character limit
* Show/hide send button
* TextView min - max height

## How to use
Drag the folder "CustomTextView" with the source files into your project.

## Delegates
```swift
func customTextViewDidResize(chatInput: CustomTextView)
func customTextView(chatInput: CustomTextView, didSendMessage message: String)
func updateCharacterCount(currentChar:Int,maxChar:Int)
```

#License
CustomTextView is available under the [MIT license](https://github.com/sunilsharma08/CustomTextView/blob/master/LICENSE.md).
