import os
import asyncio
from nats.aio.client import Client as NATS
from dotenv import load_dotenv


async def message_handler(msg):
    subject = msg.subject
    data = msg.data.decode()
    print(f"Received a message on '{subject}': {data}")


async def subscribe():
    nc = NATS()
    port = os.getenv("PORT")
    host = os.getenv("HOST")
    print(f'{host}:{port}')
    await nc.connect(servers=[f'nats://{host}:{port}'])

    # Subscribe to a subject with the given message handler
    subject = os.getenv("SUBJECT")
    await nc.subscribe(f"{subject}", cb=message_handler)

    print("Connected to NATS server and subscribed")


if __name__ == '__main__':
    load_dotenv("values.env")
    loop = asyncio.get_event_loop()
    loop.run_until_complete(subscribe())
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass
    loop.close()
