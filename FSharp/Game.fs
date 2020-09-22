namespace FSharp

module Game =
    open Domain
    open State
    open Godot

    let mutable state = { 
        tick = 0
        objects = [
            Ship {
                position = { x = 0.0; y = 0.0 }
                rotation = 0.0
                scale = { x = 1.0; y = 1.0 }
                linearVelocity = { x = 10.0; y = 0.0 }
                angularVelocity = 0.0
                input = {
                    horizontal = 0.0
                    vertical = 0.0
                    fire = false }}]}

    let toObject (node: Node) =
        let typeName = node.GetType().Name
        match typeName with
        | "ShipNode" -> Ship { 
            position = downcast node.Get("GlobalPosition")
            rotation = downcast node.Get("GlobalRotation")
            scale = downcast node.Get("GlobalScale")
            linearVelocity = downcast node.Get("LinearVelocity")
            angularVelocity = downcast node.Get("AngularVelocity")
            input = {horizontal = 0.0; vertical = 0.0; fire = false}}
        | "AsteroidNode" -> Asteroid { 
            position = downcast node.Get("GlobalPosition")
            rotation = downcast node.Get("GlobalRotation")
            scale = downcast node.Get("GlobalScale")
            linearVelocity = downcast node.Get("LinearVelocity")
            angularVelocity = downcast node.Get("AngularVelocity")}
        | "BulletNode" -> Bullet { 
            position = downcast node.Get("GlobalPosition")
            rotation = downcast node.Get("GlobalRotation")
            scale = downcast node.Get("GlobalScale")
            linearVelocity = downcast node.Get("LinearVelocity")
            angularVelocity = downcast node.Get("AngularVelocity")}
        | _ -> None

    let toNode (v: obj) = 
        (downcast v: Node)

    let _ready (world: Node2D) state =
        // let children = new list<Node>(world.GetChildren)
        // children
        // |> List.map toObject
        state

    let _process state =
        step state (1.0 / 60.0)
