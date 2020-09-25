namespace FSharp

open Godot

module Domain =
    type Vector2fs = {x: float; y: float}
    type Position = Vector2fs
    type Rotation = float
    type Scale = Vector2fs
    type LinearVelocity = Vector2fs
    type AngularVelocity = float
    type InputRecord = { 
        horizontal: float
        vertical: float
        fire: bool }
    type GunRecord = {
        position: Vector2fs
        rotation: float }
    type ShipRecord = { 
        name: string
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity
        speed: float
        spin: float
        cooldown: float
        cooldownTimer: float
        gun: GunRecord
        input: InputRecord }
    type Asteroid = {
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity }
    type Bullet = {
        position: Position
        rotation: Rotation
        scale: Scale
        linearVelocity: LinearVelocity
        angularVelocity: AngularVelocity }
    type ObjectRecord =
    | ShipRecord of ShipRecord
    | Asteroid of Asteroid
    | Bullet of Bullet
    | None
    type Objects = ObjectRecord list
    type State = {
        tick: int
        objects: Objects }
    type Collision = {
        self: ObjectRecord
        other: ObjectRecord
        point: Vector2
        normal: Vector2
        remaining: Vector2
        travel: Vector2 }
    type MovingObject = { position: Position; linearVelocity: LinearVelocity }
    type Event =
        | CreateEvent of ObjectRecord
        | DeleteEvent of ObjectRecord
        | CollisionEvent of Collision
