using System;
using System.Net.Sockets;
using UnityNetworking;

namespace Commands {
    public abstract class ServerCommand : Command
    {
        public TCPClientUnity client;

        public void Run<T>(TCPClientUnity client, params object[] args) where T : ServerCommand
        {
            var t = Activator.CreateInstance<T>();
            t.client = client;
            t.message = t.GetMessage();
            Send(t);
        }

        protected static void Send(ServerCommand command)
        {
            var client = command.client;
            var type = command.GetType().Name;
            var message = command.message;
            client.Send($"{type},{message}");
        }
        
        public abstract void Receive(Socket client, params object[] args);
    }
}