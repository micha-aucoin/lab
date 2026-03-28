#!/usr/bin/env python

import asyncio


class TcpChatClient:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.reader: asyncio.StreamReader | None = None
        self.writer: asyncio.StreamWriter | None = None
        self._receive_task: asyncio.Task | None = None
        self._messages: asyncio.Queue[str] = asyncio.Queue()

    async def connect(self):
        self.reader, self.writer = await asyncio.open_connection(
            host=self.host,
            port=self.port,
        )

    async def send(self, message):
        if not self.writer:
            raise RuntimeError("Client not connected")

        self.writer.write(f"{message}\n".encode())
        await self.writer.drain()

    async def receive(self):
        if not self.reader:
            raise RuntimeError("Client not connected")

        data = await self.reader.readline()
        if not data:
            return None

        return data.decode().rstrip("\n")

    async def _receive_loop(self):
        try:
            while True:
                message = await self.receive()
                if message is None:
                    break
                await self._messages.put(message)
        except asyncio.CancelledError:
            raise

    async def start_receiving(self):
        if self._receive_task is not None:
            return

        self._receive_task = asyncio.create_task(self._receive_loop())

    async def get_message(self):
        return await self._messages.get()

    async def stop_receiving(self):
        if self._receive_task is None:
            return

        self._receive_task.cancel()
        await asyncio.gather(self._receive_task, return_exceptions=True)
        self._receive_task = None

    async def close(self):
        if self.writer:
            self.writer.close()
            await self.writer.wait_closed()
            self.writer = None
            self.reader = None


async def _receive_messages(client, output_func):
    await client.start_receiving()

    try:
        while True:
            message = await client.get_message()
            output_func(message)
    except asyncio.CancelledError:
        raise


async def _send_messages(client, input_func):
    while True:
        message = await input_func()

        if message is None:
            continue

        message = message.strip()

        if not message:
            continue

        if message.lower() in {"exit", "quit"}:
            break

        await client.send(message)


async def run_chat_cli(client, input_func, output_func):
    receive_task = asyncio.create_task(_receive_messages(client, output_func))

    try:
        await _send_messages(client, input_func)
    finally:
        receive_task.cancel()
        await asyncio.gather(receive_task, return_exceptions=True)
        await client.stop_receiving()


async def terminal_input():
    return await asyncio.to_thread(input, "> ")


def terminal_output(message):
    print(f"\r{message}")
    print("> ", end="", flush=True)


async def main():
    client = TcpChatClient("127.0.0.1", 8080)
    await client.connect()

    try:
        await run_chat_cli(
            client=client,
            input_func=terminal_input,
            output_func=terminal_output,
        )
    finally:
        await client.close()


if __name__ == "__main__":
    asyncio.run(main())
