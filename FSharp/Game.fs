namespace FSharp

module Game =
    open Domain
    open State
    open Godot

    let mutable state = { 
        tick = 0
        objects = [] }

    let toObject node =
        let o = {
            name = "Ship"
            position = {x = 0.0; y = 0.0}
            rotation = 0.0
            scale = {x = 1.0; y = 1.0}
            linearVelocity = {x = 0.0; y = 0.0}
            angularVelocity = 0.0
            speed = 800.0
            spin = 10.0
            cooldown = 0.2
            cooldownTimer = 0.0
            gun = {position = {x = 0.0; y = 0.0}; rotation = 0.0}
            input = {horizontal = 0.0; vertical = 0.0; fire = false} }
        (None : ObjectRecord)
            
    let _ready (world: Node2D) state =
        let objects = 
            Seq.cast<Node> (world.GetChildren())
            |> Seq.map toObject
            |> Seq.toList
        { state with objects = objects }

    let _process state =
        step state (1.0 / 60.0)
