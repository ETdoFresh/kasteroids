namespace FSharp

open Godot

type GunRecord = {
    position: Vector2
    rotation: float32 }

type ShipRecord = { 
    name: string
    position: Vector2
    rotation: float32
    scale: Vector2
    speed: float
    spin: float
    cooldown: float
    cooldownTimer: float
    gun: GunRecord
    input: InputRecord }

type Ship() =
    inherit Node2D()

    [<Export>]
    let mutable speed = 800.0

    [<Export>]
    let mutable spin = 10.0
    
    [<Export>]
    let mutable cooldown = 0.2

    let mutable linearVelocity = Vector2.Zero
    let mutable angularVelocity = 0.0
    let mutable cooldownTimer = 0.0
    let mutable gun : Node2D = null
    let mutable input : InputNode = new InputNode ()

    member this.toRecord = { 
        name = this.Name
        position = this.GlobalPosition
        rotation = this.GlobalRotation
        scale = this.GlobalScale
        speed = speed
        spin = spin
        cooldown = cooldown
        cooldownTimer = cooldownTimer
        gun = {position = gun.GlobalPosition; rotation = gun.GlobalRotation}
        input = input.toRecord
    }

    override this._Ready () =
        gun <- this.GetNode<Node2D> (new NodePath "Gun")
        input <- this.GetNode<InputNode> (new NodePath "Input")
        ()