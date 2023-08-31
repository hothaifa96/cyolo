import asyncio
from nats import NATS

async def main():
    nc = NATS()
    await nc.connect("nats://local:aPw7KVAIHlXUxue4UmCoBORih5vrMcGc@localhost:61265")
    await nc.publish("test.me", b'Hello World11')
    
    await nc.close()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
    loop.close()

