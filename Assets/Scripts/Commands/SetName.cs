using System;
using System.Net.Sockets;
using UnityNetworking;
using Object = UnityEngine.Object;

namespace Commands
{
    public class SetName : ServerCommand
    {
        private static PlayerSpawner _playerSpawner;

        public override string GetMessage(params object[] args)
        {
            return (string) args[0];
        }

        public override void Receive(Socket client, params object[] args)
        {
            if (!_playerSpawner)
                _playerSpawner = Object.FindObjectOfType<PlayerSpawner>();

            if (!_playerSpawner)
                throw new Exception($"{GetType().Name}: Player Spawner did not exist");

            var i = _playerSpawner.sockets.IndexOf(client);
            var clientData = _playerSpawner.clients[i];
            clientData.ship.playerInput.playerName = (string) args[0];
        }
    }
}