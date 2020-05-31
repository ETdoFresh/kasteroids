using System;
using System.Net.Sockets;
using UnityNetworking;

namespace Commands
{
    public abstract class ClientCommand : Command
    {
        public TCPServerUnity server;
        public Socket client;

        public static void Run<T>(TCPServerUnity server, Socket client, params object[] args) where T : ClientCommand
        {
            var t = Activator.CreateInstance<T>();
            t.server = server;
            t.client = client;
            t.message = t.GetMessage();
            Send(t);
        }

        protected static void Send(ClientCommand command)
        {
            var server = command.server;
            var client = command.client;
            var type = command.GetType().Name;
            var message = command.message;
            server.Send(client, $"{type},{message}");
        }
        
        public abstract void Receive(TCPClientUnity client, params object[] args);
    }
}