namespace FSharp

module State =
    open Domain

    let printState state =
        printfn "%O" state

    let move (p: Position) (lv: LinearVelocity) (delta: float) =
        { x = p.x + lv.x * delta; y = p.y + lv.y * delta }

    let rotate (r: Rotation) (av: AngularVelocity) (delta: float) =
        r + av * delta

    let applyLinearVelocity delta object = 
        match object with
        | Ship s -> Ship { s with position = move s.position s.linearVelocity delta }
        | Asteroid a -> Asteroid { a with position = move a.position a.linearVelocity delta }
        | Bullet b -> Bullet { b with position = move b.position b.linearVelocity delta }
        | None -> None

    let applyAngularVelocity delta object = 
        match object with
        | Ship s -> Ship { s with rotation = rotate s.rotation s.angularVelocity delta }
        | Asteroid a -> Asteroid { a with rotation = rotate a.rotation a.angularVelocity delta }
        | Bullet b -> Bullet { b with rotation = rotate b.rotation b.angularVelocity delta }
        | None -> None

    let stepTick tick = tick + 1

    let stepObjects objects delta =
        objects
        //|> List.map applyInputs
        //|> List.map createBullets
        //|> List.map setCooldowns
        |> List.map (applyLinearVelocity delta)
        |> List.map (applyAngularVelocity delta)
        //|> List.map updateBodyNode
        //|> List.map clearCollisions
        //|> List.map updateBoundingBoxes
        //|> List.something objectsToPairs
        //|> List.map collisionBroadPhase
        //|> List.map collisionNarrowPhase
        //|> List.something pairsToObjects
        //|> List.map fixPenetration
        //|> List.map bounceNoAngularVelocity
        //|> List.map wrapAroundScreen
        //|> List.map playCollisionSounds
        //|> List.map queueDeleteBulletsOnCollision
        //|> List.map queueDeleteBulletsAfterDuration
        //|> List.map spawnBulletParticles
        //|> List.map deleteQueuedNodes
        //|> List.map deleteQueuedObjects
        //|> List.map updateNodeTransforms     

    let step state delta =
        { state with
            tick = stepTick state.tick
            objects = stepObjects state.objects delta }