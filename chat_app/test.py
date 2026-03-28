#!/usr/bin/env python

import asyncio
import unittest

from client import TcpChatClient, run_chat_cli
from server import handle_chat


class TestAsyncChatServer(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.server = await asyncio.start_server(
            handle_chat,
            "127.0.0.1",
            8080,
        )
        sock = self.server.sockets[0]
        self.host, self.port = sock.getsockname()
        self.clients = []

    async def asyncTearDown(self):
        for reader, writer in self.clients:
            writer.close()
            await writer.wait_closed()

        self.server.close()
        await self.server.wait_closed()

    async def connect_client(self):
        reader, writer = await asyncio.open_connection(
            host=self.host,
            port=self.port,
        )
        self.clients.append((reader, writer))
        return reader, writer

    async def read_line(self, reader):
        data = await asyncio.wait_for(reader.readline(), timeout=1)
        return data.decode().rstrip("\n")

    async def test_single_client_message_is_echoed_back(self):
        reader, writer = await self.connect_client()

        writer.write(b"hello, world!\n")
        await writer.drain()

        resp = await self.read_line(reader)
        self.assertEqual(resp, "hello, world!")

    async def test_message_from_one_client_is_broadcast_to_another_client(self):
        reader_one, writer_one = await self.connect_client()
        reader_two, writer_two = await self.connect_client()

        writer_one.write(b"hello from client one\n")
        await writer_one.drain()

        resp_one = await self.read_line(reader_one)
        resp_two = await self.read_line(reader_two)

        self.assertEqual(resp_one, "hello from client one")
        self.assertEqual(resp_two, "hello from client one")

    async def test_multiple_messages_are_broadcast_in_order(self):
        reader_one, writer_one = await self.connect_client()
        reader_two, writer_two = await self.connect_client()

        writer_one.write(b"first\n")
        await writer_one.drain()

        writer_one.write(b"second\n")
        await writer_one.drain()

        resp_one_a = await self.read_line(reader_one)
        resp_two_a = await self.read_line(reader_two)
        resp_one_b = await self.read_line(reader_one)
        resp_two_b = await self.read_line(reader_two)

        self.assertEqual(resp_one_a, "first")
        self.assertEqual(resp_two_a, "first")
        self.assertEqual(resp_one_b, "second")
        self.assertEqual(resp_two_b, "second")


class TestPersistentTcpChatClient(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.server = await asyncio.start_server(
            handle_chat,
            "127.0.0.1",
            8080,
        )
        sock = self.server.sockets[0]
        self.host, self.port = sock.getsockname()
        self.clients = []

    async def asyncTearDown(self):
        for client in self.clients:
            await client.close()

        self.server.close()
        await self.server.wait_closed()

    async def connect_client(self):
        client = TcpChatClient(
            host=self.host,
            port=self.port,
        )
        await client.connect()
        self.clients.append(client)
        return client

    async def test_client_can_send_and_receive_one_message(self):
        client = await self.connect_client()

        await client.send("hello")
        resp = await client.receive()

        self.assertEqual(resp, "hello")

    async def test_client_can_send_and_receive_multiple_messages(self):
        client = await self.connect_client()

        await client.send("first")
        resp_one = await client.receive()

        await client.send("second")
        resp_two = await client.receive()

        self.assertEqual(resp_one, "first")
        self.assertEqual(resp_two, "second")

    async def test_two_clients_receive_same_broadcast(self):
        client_one = await self.connect_client()
        client_two = await self.connect_client()

        await client_one.send("hello everybody")

        resp_one = await client_one.receive()
        resp_two = await client_two.receive()

        self.assertEqual(resp_one, "hello everybody")
        self.assertEqual(resp_two, "hello everybody")


class TestStreamingTcpChatClient(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.server = await asyncio.start_server(
            handle_chat,
            "127.0.0.1",
            8080,
        )
        sock = self.server.sockets[0]
        self.host, self.port = sock.getsockname()
        self.clients = []

    async def asyncTearDown(self):
        for client in self.clients:
            await client.close()

        self.server.close()
        await self.server.wait_closed()

    async def connect_client(self):
        client = TcpChatClient(
            host=self.host,
            port=self.port,
        )
        await client.connect()
        self.clients.append(client)
        return client

    async def test_client_receives_stream_of_messages_in_order(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await sender.send("first")
        await sender.send("second")
        await sender.send("third")

        resp_first = await receiver.receive()
        resp_second = await receiver.receive()
        resp_third = await receiver.receive()

        self.assertEqual(resp_first, "first")
        self.assertEqual(resp_second, "second")
        self.assertEqual(resp_third, "third")

    async def test_sender_also_receives_its_own_stream_in_order(self):
        client = await self.connect_client()

        await client.send("alpha")
        await client.send("beta")

        resp_one = await client.receive()
        resp_two = await client.receive()

        self.assertEqual(resp_one, "alpha")
        self.assertEqual(resp_two, "beta")

    async def test_two_receivers_both_receive_same_stream(self):
        sender = await self.connect_client()
        receiver_one = await self.connect_client()
        receiver_two = await self.connect_client()

        await sender.send("one")
        await sender.send("two")

        r1_msg1 = await receiver_one.receive()
        r1_msg2 = await receiver_one.receive()

        r2_msg1 = await receiver_two.receive()
        r2_msg2 = await receiver_two.receive()

        self.assertEqual(r1_msg1, "one")
        self.assertEqual(r1_msg2, "two")
        self.assertEqual(r2_msg1, "one")
        self.assertEqual(r2_msg2, "two")


class TestBackgroundReceivingTcpChatClient(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.server = await asyncio.start_server(
            handle_chat,
            "127.0.0.1",
            8080,
        )
        sock = self.server.sockets[0]
        self.host, self.port = sock.getsockname()
        self.clients = []

    async def asyncTearDown(self):
        for client in self.clients:
            await client.close()

        self.server.close()
        await self.server.wait_closed()

    async def connect_client(self):
        client = TcpChatClient(
            host=self.host,
            port=self.port,
        )
        await client.connect()
        self.clients.append(client)
        return client

    async def test_client_can_receive_in_background(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await receiver.start_receiving()

        await sender.send("hello")

        resp = await asyncio.wait_for(receiver.get_message(), timeout=1)
        self.assertEqual(resp, "hello")

    async def test_client_receives_multiple_messages_in_background_in_order(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await receiver.start_receiving()

        await sender.send("first")
        await sender.send("second")
        await sender.send("third")

        resp_one = await asyncio.wait_for(receiver.get_message(), timeout=1)
        resp_two = await asyncio.wait_for(receiver.get_message(), timeout=1)
        resp_three = await asyncio.wait_for(receiver.get_message(), timeout=1)

        self.assertEqual(resp_one, "first")
        self.assertEqual(resp_two, "second")
        self.assertEqual(resp_three, "third")

    async def test_background_receiving_can_be_stopped(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await receiver.start_receiving()
        await receiver.stop_receiving()

        await sender.send("should not be collected")

        with self.assertRaises(asyncio.TimeoutError):
            await asyncio.wait_for(receiver.get_message(), timeout=0.2)


class InputController:
    def __init__(self):
        self.queue = asyncio.Queue()

    async def __call__(self):
        return await self.queue.get()


class TestInteractiveCliChatClient(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.server = await asyncio.start_server(
            handle_chat,
            "127.0.0.1",
            8080,
        )
        sock = self.server.sockets[0]
        self.host, self.port = sock.getsockname()
        self.clients = []

    async def asyncTearDown(self):
        for client in self.clients:
            await client.close()

        self.server.close()
        await self.server.wait_closed()

    async def connect_client(self):
        client = TcpChatClient(
            host=self.host,
            port=self.port,
        )
        await client.connect()
        self.clients.append(client)
        return client

    async def test_cli_sends_user_input_to_chat(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await receiver.start_receiving()

        outputs = []
        fake_input = InputController()

        cli_task = asyncio.create_task(
            run_chat_cli(
                client=sender,
                input_func=fake_input,
                output_func=outputs.append,
            )
        )
        await fake_input.queue.put("hello")

        resp = await asyncio.wait_for(receiver.get_message(), timeout=1)
        self.assertEqual(resp, "hello")

        await fake_input.queue.put("exit")
        await cli_task

    async def test_cli_outputs_received_messages(self):
        cli_client = await self.connect_client()
        sender = await self.connect_client()

        outputs = []
        fake_input = InputController()

        cli_task = asyncio.create_task(
            run_chat_cli(
                client=cli_client,
                input_func=fake_input,
                output_func=outputs.append,
            )
        )
        await asyncio.sleep(0.05)
        await sender.send("hello from sender")
        await asyncio.sleep(0.05)

        self.assertIn("hello from sender", outputs)

        await fake_input.queue.put("exit")
        await cli_task

    async def test_cli_ignores_empty_input(self):
        sender = await self.connect_client()
        receiver = await self.connect_client()

        await receiver.start_receiving()

        outputs = []
        fake_input = InputController()

        cli_task = asyncio.create_task(
            run_chat_cli(
                client=sender,
                input_func=fake_input,
                output_func=outputs.append,
            )
        )
        await fake_input.queue.put("")
        await fake_input.queue.put("exit")
        await cli_task

        with self.assertRaises(asyncio.TimeoutError):
            await asyncio.wait_for(receiver.get_message(), timeout=0.2)

    async def test_cli_stops_on_exit_command(self):
        client = await self.connect_client()

        outputs = []
        fake_input = InputController()

        cli_task = asyncio.create_task(
            run_chat_cli(
                client=client,
                input_func=fake_input,
                output_func=outputs.append,
            )
        )
        await fake_input.queue.put("exit")
        await cli_task

        self.assertEqual(outputs, [])

    async def test_two_cli_clients_can_talk_to_each_other(self):
        cli_client_one = await self.connect_client()
        cli_client_two = await self.connect_client()

        outputs_one = []
        outputs_two = []

        fake_input_one = InputController()
        fake_input_two = InputController()

        cli_task_one = asyncio.create_task(
            run_chat_cli(
                client=cli_client_one,
                input_func=fake_input_one,
                output_func=outputs_one.append,
            )
        )
        cli_task_two = asyncio.create_task(
            run_chat_cli(
                client=cli_client_two,
                input_func=fake_input_two,
                output_func=outputs_two.append,
            )
        )

        await asyncio.sleep(0.05)
        await fake_input_one.queue.put("hello from client one")
        await asyncio.sleep(0.05)
        await fake_input_two.queue.put("hello from client two")
        await asyncio.sleep(0.05)

        self.assertIn("hello from client one", outputs_one)
        self.assertIn("hello from client one", outputs_two)
        self.assertIn("hello from client two", outputs_one)
        self.assertIn("hello from client two", outputs_two)

        await fake_input_one.queue.put("exit")
        await fake_input_two.queue.put("exit")
        await cli_task_one
        await cli_task_two


if __name__ == "__main__":
    unittest.main()
