using System;
using System.Net.Sockets;
using UnityNetworking;
using Object = UnityEngine.Object;

namespace Commands
{
    public class GetName : ClientCommand
    {
        private static PlayerSpawner _playerSpawner;

        public override string GetMessage(params object[] args)
        {
            if (!_playerSpawner)
                _playerSpawner = Object.FindObjectOfType<PlayerSpawner>();

            if (!_playerSpawner)
                throw new Exception($"{GetType().Name}: Player Spawner did not exist");

            var i = _playerSpawner.sockets.IndexOf(client);
            return _playerSpawner.clients[i].ship.playerInput.playerName;
        }

        public override void Receive(TCPClientUnity client, params object[] args)
        {
            var playerInput = client.FindObjectOfTypeInScene<PlayerInput>();
            playerInput.playerName = (string) args[0];
        }
    }
}