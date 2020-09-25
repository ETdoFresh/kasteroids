namespace FSharp

open Domain
open Godot

type Ship() =
    inherit Node2D()

    [<Export>]
    let mutable speed = 800.0f

    [<Export>]
    let mutable spin = 10.0f
    
    [<Export>]
    let mutable cooldown = 0.2f

    let mutable linearVelocity = Vector2.Zero
    let mutable angularVelocity = 0.0
    let mutable cooldownTimer = 0.0
    let mutable gun : Node2D = null
    let mutable input : InputNode = new InputNode ()

    member this.toRecord = { 
        name = this.Name
        position = {x = float this.GlobalPosition.x; y = float this.GlobalPosition.y}
        rotation = float this.GlobalRotation
        scale = {x = float this.GlobalScale.x; y = float this.GlobalScale.y}
        linearVelocity = {x = float linearVelocity.x; y = float linearVelocity.y}
        angularVelocity = angularVelocity
        speed = float speed
        spin = float spin
        cooldown = float cooldown
        cooldownTimer = cooldownTimer
        gun = {
            position = {x = float gun.GlobalPosition.x; y = float gun.GlobalPosition.y}
            rotation = float gun.GlobalRotation}
        input = input.toRecord
    }

    override this._Ready () =
        gun <- this.GetNode<Node2D> (new NodePath "Gun")
        input <- this.GetNode<InputNode> (new NodePath "Input")
        ()