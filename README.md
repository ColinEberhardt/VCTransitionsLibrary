# View Controller Transitions Library

With iOS 7 you can easily create custom view controller transitions that can be used in a range of contexts (push, pop, modal …). This project provides a library of custom animations which can be dropped directly into your project. It also has a number of 'interaction controllers' which can be used with any of the custom animations in order to make your transitions interactive.

The library currently contains the following animations:
 
<table>
<tr>
<th>Flip</th>
<th>Fold</th>
<th>Crossfade</th>
<th>Explode</th>
</tr>
<tr>
<td><img src="Screenshots/thumbnails/Flip/1.png"/></td>
<td><img src="Screenshots/thumbnails/Fold/2.png"/></td>
<td><img src="Screenshots/thumbnails/Crossfade/2.png"/></td>
<td><img src="Screenshots/thumbnails/Explode/2.png"/></td>
</tr>
<tr>
<th>Turn</th>
</tr>
<tr>
<td><img src="Screenshots/thumbnails/Turn/1a.png"/></td>
</tr>
</table>

### Contents

* [A brief introduction to custom transitions](#intro)
* [Adding custom transitions to your project](#adding)
  * [Grabbing the code](#grabbing)
  * [Using an animation controller](#animation)
    * [Custom present / dismiss transitions](#animationPresent)
    * [Custom navigation controller transitions](#animationNavigation)
  * [Using an interaction controller](#interaction)
    * [Interactive dismiss transitions](#interactionDismiss)
    * [Interactive pop transitions](#interactionPop)
* [Transitions Library](#library)


## <a id="intro"></a>A brief introduction to custom transitions

The following provides a very brief introduction to the concepts, for more detailed coverage I would thoroughly recommend reading Chapter 5 of iOS 7 By Tutorials - which I wrote! (I've heard the other ~20 are pretty good too ;-)

There are two key classes involved in a custom transition:

 + **Animation controller** - this class is responsible for performing the custom transitions. When you indicate that a custom transitions should be used, you provide an animation controller. This class performs the required animation, then informs the framework when it has completed.
 + **Interaction controller** - this class is responsible for managing interactive transitions - these are transitions that typically controlled by a gesture, allowing the user to swipe, pinch or perform some other action to navigate between view controllers. Importantly, interaction controllers allow transitions to be cancelled, i.e. a user can start the navigation, change their mind, and reverse it!
 
**NOTE:** Animation and interaction controllers are entirely independent, this means you can wire up any interaction controller with any animation controller - which is pretty awesome.
 
## <a id="intro"></a>Adding custom transitions to your project

This sections gives a brief overview of the steps required to add custom view controller transitions to your project. You might also want to look at the code for the demo app (in the `TransitionsDemo` folder) for reference. If you already know how the iOS 7 custom view controller transitions work, feel free to skip this section!

### <a id="grabbing"></a>Grabbing the code

There are a couple of ways you can incorporate transitions from this library into your code:

 1. **Cocoapods** - simply execute `pod install View-Controller-Transitions-Library`.
 2. **Manual file copy** - if you are not using Cocoapods, you can simply copy the required files into your project. The `AnimationControllers` and `InteractionControllers` folders contain all the code that is required.
 
### <a id="animation"></a>Using an animation controller

The `AnimationControllers` folder contains a number of animate controllers, which provide custom transitions, which can be integrated into your project as follows:

#### <a id="animationPresent"></a>Custom present / dismiss transitions

The `UIViewControllerTransitioningDelegate` protocol is used to supply animation controllers for present / dismiss transitions. When a view controller is presented or dismissed the `transitioningDelegate` property of the view controller being presented or dismissed is used to supply this delegate. Simply return one of the animation controllers in response to the `animationControllerForPresentedController: presentingController: sourceController:` message for presenting, and `animationControllerForDismissedController:` for dismissing.

#### <a id="animationNavigation"></a>Custom navigation controller transitions

The `UINavigationControllerDelegate` protocol has methods that can be used to provide animation controllers. Simply return an animation controller in response to the `navigationController: animationControllerForOperation: fromViewController: toViewController:` message.

Notice that this message has an 'operation' argument that allows you to return different animations for push and pop operations. All of the animation controllers in this library subclass `CEReversibleAnimationController` which allows you to play the animation in reverse. This is commonly used in conjunction with the navigation controller as follows:

```objc
- (id<UIViewControllerAnimatedTransitioning>)navigationController:
                                (UINavigationController *)navigationController
   animationControllerForOperation:(UINavigationControllerOperation)operation
                fromViewController:(UIViewController *)fromVC
                  toViewController:(UIViewController *)toVC {
    
    // reverse the animation for 'pop' transitions
    _animationController.reverse = operation == UINavigationControllerOperationPop;
    
    return _animationController;
}
```

### <a id="interaction"></a>Using an interaction controller

Interaction controllers work in conjunction with an animation controller in order to make a transitions interactive, i.e. allow a user to control a transitions using gestures. This interactivity allows a use to move forwards, backwards and even cancel a transitions.

The interaction controller is responsible for adding gesture recognisers to the view and triggering the navigation in response to gestures from the user.

#### <a id="interactionDismiss"></a>Interactive dismiss transitions

The `UIViewControllerTransitioningDelegate` protocol that is used to supply animation controllers is also used to supply interaction controllers. An example implementation, that uses a swipe interaction together with a flip animation, is show below:

```objc
// instance variables, typically instantiated in your init method
CEFlipAnimationController *_animationController;
CESwipeInteractionController *_interactionController;

- (id<UIViewControllerAnimatedTransitioning>)
      animationControllerForPresentedController:(UIViewController *)presented
                           presentingController:(UIViewController *)presenting
                               sourceController:(UIViewController *)source {
    
    // allow the interaction controller to wire-up its gesture recognisers
    [_interactionController wireToViewController:presented 
                                    forOperation:CEInteractionOperationDismiss];
       _animationController.reverse = NO;
    return _animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)
     animationControllerForDismissedController:(UIViewController *)dismissed {
    _animationController.reverse = YES;
    return _animationController;
}

- (id<UIViewControllerInteractiveTransitioning>)
           interactionControllerForDismissal:
                (id<UIViewControllerAnimatedTransitioning>)animator {
                
    // provide the interaction controller, if an interactive transition is in progress
    return _interactionController.interactionInProgress
                ? _interactionController : nil;
}
```

Note that in the above code the `interactionInProgress` property of the interaction controller is checked. This is because your might want to allow the user to dismiss the view controller using a button as well as via an interaction. Also, you must tell the interaction controller the operation it should perform (i.e. pop, dismiss).

#### <a id="interactionPop"></a>Interactive pop transitions

The `UINavigationControllerDelegate` protocol also has an equivalent method for returning interactions controllers. A typically implementation, which follows the same pattern as above, is shown:

```objc
// instance variables, typically instantiated in your init method
CEFlipAnimationController *_animationController;
CESwipeInteractionController *_interactionController;

- (id<UIViewControllerAnimatedTransitioning>)
                 navigationController:(UINavigationController *)navigationController
      animationControllerForOperation:(UINavigationControllerOperation)operation
                   fromViewController:(UIViewController *)fromVC
                     toViewController:(UIViewController *)toVC {
    
    // when a push occurs, wire the interaction controller to the to- view controller
    if (operation == UINavigationControllerOperationPush) {
        [_interactionController wireToViewController:presented 
                                        forOperation:CEInteractionOperationPop];
    }
    
    _animationController.reverse = operation == UINavigationControllerOperationPop;
    
    return _animationController.reverse;
}

- (id <UIViewControllerInteractiveTransitioning>)
                         navigationController:(UINavigationController *)navigationController 
  interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    
    // provide the interaction controller, if an interactive transition is in progress
    return _interactionController.interactionInProgress
                ? _interactionController : nil;
}
```

## <a id="library"></a>Transitions Library

The following is a graphical illustration of the various transitions. All animation controllers have a `duration` property that configures the animation duration.

### Fold animation - CEFoldAnimationController

Animates between the two view controllers using a paper-fold style transition. You can configure the number of folds via the `folds` property.

![](Screenshots/thumbnails/Fold/1.png)
![](Screenshots/thumbnails/Fold/2.png)
![](Screenshots/thumbnails/Fold/3.png)
![](Screenshots/thumbnails/Fold/4.png)

### Flip animation - CEFlipAnimationController

Animates between the two view controllers using a page-flip transition. 

![](Screenshots/thumbnails/Flip/1.png)
![](Screenshots/thumbnails/Flip/2.png)
![](Screenshots/thumbnails/Flip/3.png)
![](Screenshots/thumbnails/Flip/4.png)

### Turn animation - CETurnAnimationController

Animates between the two view controllers by performing a 3D flip, to reveal the destination view on the back.The turn animation has a `flipDirection` property that specifies the turn orientation.

![](Screenshots/thumbnails/Turn/1.png)
![](Screenshots/thumbnails/Turn/2.png)
![](Screenshots/thumbnails/Turn/3.png)
![](Screenshots/thumbnails/Turn/4.png)

![](Screenshots/thumbnails/Turn/1a.png)
![](Screenshots/thumbnails/Turn/2a.png)
![](Screenshots/thumbnails/Turn/3a.png)
![](Screenshots/thumbnails/Turn/4a.png)

### Crossfade animation - CECrossfadeAnimationController

Animates between the two view controllers by performing a simple cross-fade. 

![](Screenshots/thumbnails/Crossfade/1.png)
![](Screenshots/thumbnails/Crossfade/2.png)
![](Screenshots/thumbnails/Crossfade/3.png)
![](Screenshots/thumbnails/Crossfade/4.png)

### Explode animation - CEExplodeAnimationController

Animates between the two view controllers by slicing the from- view controller into lots of little pieces, then randomly spinning and shrinking them.

![](Screenshots/thumbnails/Explode/1.png)
![](Screenshots/thumbnails/Explode/2.png)
![](Screenshots/thumbnails/Explode/3.png)
![](Screenshots/thumbnails/Explode/4.png)

