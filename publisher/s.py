import asyncio
from nats import NATS 

async def message_handler(msg):
    subject = msg.subject
    reply = msg.reply
    data = msg.data.decode()
    print(f'Received a message on {subject}: {data}')

async def main():
    nc = NATS()
    await nc.connect("nats://local:aPw7KVAIHlXUxue4UmCoBORih5vrMcGc@localhost:61265")
    sid = await nc.subscribe("foo", cb=message_handler)
    await nc.auto_unsubscribe(sid, max=1)
    await nc.close()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
    loop.close()