# godot-ipc
Godot Inter-Project Communication

For when you want to be able to send messages from one project to another, implemented with HTTP. Each project that you want to be able to receive messages becomes a server that handles HTTP requests and each project that needs to send messages to those servers becomes a client and sends HTTP requests.

"But IPC means Inter-Process Communication!" I know, sorry, it is a bit of a cheeky name.

## How I Use It
I keep this repo somewhere convenient, it can be in its own Godot project if you want, but it is not very useful on its own so the location is a bit arbitrary. I am working in Windows so what I do with it is create an addons folder in every project that I want to have this functionality in and then add a junction [^1] to the `addons/inter_project_communication` folder from this repo.

Once it's junctioned into all the projects I want, I create an [addons/inter_project_communication/user.gd](Example/user.gd) file to contain all the ports and commands I want to support across the projects and by putting it inside the junctioned folder it is available to all projects. You could also just put this content inside the `shared.gd` file if you want to manage less files, but I like to keep implementation code separate from the framework code so I put it in a separate file.

For convenience I create `[name]_client.gd` files for each server that I want to be able to talk to. You can look at the [example_client.gd](Example/example_client.gd) I've provided to see how I usually create these. I also put these inside the junctioned `addons/inter_project_communication` folder, so that any project that wants to make calls to the server can do so easily. The benefit of having this file is reducing the amount of params you need to pass from each call and codifying the params each one expects. You could also do any processing you want on the returned response data before passing it back to the callsite.

### Server
The [server node.gd](Example/ServerProject/node.gd) file has an example of how you'd create and attach the server part to any existing node. Yes, the indentation is ridiculous, but I wanted to keep all the functions inline and indentation is enforced by the compiler so... this is the result, feel free to not do this. I also avoided using inline strings because I hate it when typos happen and you silently break stuff. In that vein, I also added assertion validation on the argc and run keys being defined and having the correct type values. I wanted to also assert that the params you defined on the callables match the argc but unfortunately that was not possible.

### Client
The [client node.gd](Example/ClientProject/node.gd) file has an example of how easy it can be for a client to make a call to a server. All you really need is a node in most cases, sometimes a param if your call requires one. Obviously you don't need the intermediary [example_client.gd](Example/example_client.gd) code but as you can see it really does make the calls really easy to do!

[^1]: via `mklink /j`, like a hardlink but for folders
