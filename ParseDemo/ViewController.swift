//
//  ViewController.swift
//  ParseDemo
//
//  Created by Jeremy Petter on 2016-03-30.
//  Copyright © 2016 JeremyPetter. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {

// ****** Demo Code ******

// PFObjects

        // PFObjects are special kinds of objects that can sync with Parse

                let taco = PFObject(className: "Food")    // After we save this object, it will be added to Parse as a member of this class.
                                                            // If the class name didn't exist, Parse will create it.

                taco["name"] = "taco"                     // The properties of Parse classes are called "fields".
                                                            // If the "name" field didn't exist for this class, Parse would add it.
                                                            // Also, we're giging it a name because PFObjects do not know about
                                                            // the variable names we give them in Swift.

                taco["ingredients"] = ["corn", "lettuce", "salsa", "beef"]  // Parse handles various types of data, 
                                                                              // including Strings, numbers, arrays and others

                taco.saveInBackground()   // We always save in the background because reading or writng from online servers can take a long time.
                                            // If we didn't, our program would freeze until we were done.

                let table = PFObject(className: "Furniture")

                table.saveInBackgroundWithBlock { (success, error) in // It's a good idea to use `saveInBackgroundWithBlock()` to tell us whether the
                    if success == true {                              // save was successful, whenever it completes. This method will fire whenever the
                        print("saved")                                // save operation completes and will execute whatever is in the `(Bool, NSError?) -> ()`
                    } else {                                          // closure. If the save worked, the Bool (which we've called `success`) will equal `true`
                        print(error?.description)                     // and the NSError? (which we've called `error`) will contain `nil`. If it didn't, the
                    }                                                 // Bool will be false, and the NSError will contain an error object. Becasue
                }                                                     // `saveInBackgroundWithBlock()` calls this closure, it provides values for these.


// Closures

        // We have already seen functions like this one ...

//         func introduce(name: String) {
//         print("My name is " + name)
//         }


        // Functions are a special type of "closure" that has a name
        // We can rewrite `introduce()` with closure syntax like this:

        let introduce = { (name:String) -> () in // `(String) -> ()` tells us what type of closure this is.
            print("My name is " + name)          // it represents a closure that takes a String and returns
        }                                        // nothing

        introduce("Slim Shady")

        // We can have functions or closures that take _other_ closures as arguments.

        func superIntroduce(name:String, catchphrase:String, intro:(String) ->()){ // This function takes a String named "name"
            intro(name)                                                            // and a `(String) -> ()`, named "intro"
            print(catchphrase)
        }

        // Becasue our `introduce` closure is a `(String) -> ()`, we can pass it to `superIntroduce`

        superIntroduce("Jonas", catchphrase: "I'm carrying the wheel", intro: introduce)

        //But we can also choose to just write out the closure inline, instead of giving it a name

        superIntroduce("Inigo Montoya", catchphrase: "You killed my father, prepare to die", intro: { (name:String) -> () in
            print("My name is " + name)
        })

        // When a closure is the last argument of a function, it's common to put the closure after the function's `()`, and omit its label

        superIntroduce("John Cena", catchphrase: "Your time is up, my time is now"){ (name:String) -> () in
            print("And his name is " + name)
        }


// PFUser

        // PFUser is a special kind of PFObject, with certain built-in capabilities. 
        // For our purposes, we can create a PFUser the same way we create other objects.

        let user = PFUser()
        user["username"] = "Jeremy"       // PFUser has `username` and `password` fields by default
        user["password"] = "password"     // We can also set them using dot noation, ie `user.password = "Jeremy"`
        user.signUpInBackgroundWithBlock { (success, error) in
            if success{
                print("signed up user")
            }
        }

// PFFile

        // We can upload entire files to Parse as well, though we first need to convert the image to banary data (an NSData object).
        // This takes a few steps.

        let tacoWithPicture = PFObject(className: "Food")
        tacoWithPicture["name"] = "taco"

        if let tacoImage = UIImage(named: "taco"),                // First we look for an image in the `Assets` folder named "food". If that exists...
            tacoData = UIImageJPEGRepresentation(tacoImage, 0.9), // We try to convert that image into JPEG data (our NSData object). If that works ...
            tacoFile = PFFile(data: tacoData)                     // We try to convert that NSData into a PFFile. If that works ...
        {
            tacoWithPicture["picture"] = tacoFile                 // We add the file to a field in our PFOBject and save it :).
            tacoWithPicture.saveInBackgroundWithBlock({ (success, error) in
                print("save successful")
            })
        } else {                                                  // If one of the above steps fails, we print an error message.
            print("error converting image file to PFFile")        // All three of those methods return optionals because they could fail.
        }                                                         // We use a chained `if let` statements to make sure none of them return `nil`.


// PFQuery

        // To download PFObjects, we use querys, which are also a kind of object. This has three steps:
        // First we create the query to say what we want to find ...
        // Then we modify the query to make it more specific ...
        // And finally we fire the query to actually find stuff.

        let query = PFQuery(className: "Food") // Here we create our query. By default, it will return all `Food` objects.

        query.whereKey("name", equalTo: "taco")   // Here, we modify it to make it more specific. Now it will only return Foods where `name` == "taco"
        query.orderByAscending("name")            // Here, we modify our query again to make it alphabetical. We can modify as many times as we want

        query.findObjectsInBackgroundWithBlock { (results, error) in // Like saves, queries should run in the background, so we provide a closure
                                                                     // to tell them what to do when they complete. This method takes an `(Array?, NSError?) -> ()`.
            if let results = results {
                for food in results {
                    if let name:String = food["name"] as? String {   // Swift knows there is data in food["name"] but cannot infer the type of data (String, Number, etc),
                                                                       // even though _we_ know `name` is actually a String.
                                                                       // `as?` tries to convert the type before `as?` into the type after it and returns an optional.
                                                                       // If the convrsion worked, the optional contains the converted object. If not, `nil`.
                        print(name)
                    } else {
                        print("could not understand downloaded object's name")
                    }
                }
            } else {
                print("no results")
            }
        }

        //  ******* Everything past this point is my setup code. ******

        setUpView()
    }

    // Everything past this point is setup code
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let image = UIImage(named: "taco") {
            imageView.image = image
        } else {
            print("missing taco image")
            imageView.backgroundColor = UIColor.redColor()
        }
        return imageView
    }()
}

extension ViewController {
    func setUpView() {
        //called in viewDidLoad
        self.view.addSubview(imageView)

        imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.5).active = true
        imageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.5).active = true

    }




}

