import json
import os
from queue import Queue
import time

from web3 import Web3
from web3.middleware import geth_poa_middleware
from web3.contract import Contract
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Initialize Web3
rpc_url = os.getenv("RPC_URL")
web3 = Web3(Web3.HTTPProvider(rpc_url))
web3.middleware_onion.inject(geth_poa_middleware, layer=0)

# Load contract ABI from file
contract_abi_path = os.getenv("CONTRACT_ABI_PATH")
with open(contract_abi_path, "r", encoding="utf-8") as abi_file:
    contract_abi = json.load(abi_file)

# Contract details
contract_address = os.getenv("CONTRACT_ADDRESS")

# Initialize contract
contract: Contract = web3.eth.contract(address=contract_address, abi=contract_abi)

# Queue to store Swap events
swap_event_queue = Queue()

# Event filter
event_filter = contract.events.Swap.createFilter(fromBlock="latest")


def handle_event(event):
    swap_event_queue.put(event)
    print(f"New Swap event: {event}")


def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        time.sleep(poll_interval)


def process_queue():
    while True:
        if not swap_event_queue.empty():
            batch = []
            while not swap_event_queue.empty():
                batch.append(swap_event_queue.get())
            send_batch_to_starknet(batch)
        time.sleep(10)  # Process queue every 10 seconds


def send_batch_to_starknet(batch):
    # Implement the logic to send the batch to Starknet
    print(f"Sending batch to Starknet: {batch}")
    # Example: send batch to Starknet using a hypothetical API
    # response = requests.post("STARKNET_API_URL", json=batch)
    # print(response.status_code, response.text)


if __name__ == "__main__":
    from threading import Thread

    # Start event listener thread
    event_listener_thread = Thread(target=log_loop, args=(event_filter, 5))
    event_listener_thread.start()

    # Start queue processing thread
    queue_processor_thread = Thread(target=process_queue)
    queue_processor_thread.start()
