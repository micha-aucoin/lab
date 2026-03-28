#!/usr/bin/env python

import asyncio

clients = set()


async def broadcast(message: bytes):
    dead_writers = []

    for writer in clients:
        try:
            writer.write(message)
            await writer.drain()
        except (ConnectionResetError, BrokenPipeError):
            dead_writers.append(writer)

    for writer in dead_writers:
        clients.discard(writer)
        writer.close()
        await writer.wait_closed()


async def handle_chat(reader, writer):
    clients.add(writer)

    try:
        while True:
            data = await reader.readline()
            if not data:
                break

            await broadcast(data)

    finally:
        clients.discard(writer)
        writer.close()
        await writer.wait_closed()


async def main(host="127.0.0.1", port=8080):
    server = await asyncio.start_server(handle_chat, host, port)

    addrs = ", ".join(str(sock.getsockname()) for sock in server.sockets)
    print(f"Serving on {addrs}")

    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())
