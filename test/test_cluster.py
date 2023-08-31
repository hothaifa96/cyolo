import asyncio
import pytest
import os
from nats.aio.client import Client as NATS
from dotenv import load_dotenv



async def async_publish(subject, message):
    nc = NATS()
    host= os.getenv("PUBLISHER-HOST")
    await nc.connect(f"nats://{host}")
    await nc.publish(subject, message.encode())
    await nc.close()

@pytest.fixture
async def nats_connection():
    nc = NATS()
    host= os.getenv('SUBSCRIBER-HOST')
    await nc.connect(f"nats://{host}")
    yield nc
    await nc.close()

@pytest.mark.asyncio
async def test_publish_and_receive(nats_connection):
    load_dotenv("values.env")
    subject = os.getenv('SUBJECT')
    message = os.getenv('MESSAGE')

    await async_publish(subject, message)

    async def message_handler(msg):
        assert msg.subject == subject
        assert msg.data.decode() == message
        await nats_connection.close()

    await nats_connection.subscribe(subject, cb=message_handler)

