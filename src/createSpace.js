const ethers = require('ethers'); // Import ethers.js library

// Replace with your actual contract address and ABI
const contractAddress = '0x09F1174a774B0a1A255fB1D76f5b82dC8A8C2b1B';
const contractABI = [...]; // ABI definition

// Create a provider (connecting to Ethereum node)
const provider = new ethers.providers.JsonRpcProvider('YOUR_ETHEREUM_NODE_URL');

// Replace with your actual private key
const privateKey = 'YOUR_PRIVATE_KEY';

// Connect to the wallet using private key
const wallet = new ethers.Wallet(privateKey, provider);

// Create a contract instance
const contract = new ethers.Contract(contractAddress, contractABI, wallet);

// Sample data for creating spaces
const spacesData = [
    {
        name: 'Cozy Cabin',
        description: 'A cozy cabin in the woods.',
        images: 'cabin.jpg',
        rooms: 2,
        price: 100,
    },
    {
        name: 'Beach House',
        description: 'A beautiful beach house with ocean view.',
        images: 'beach-house.jpg',
        rooms: 4,
        price: 250,
    },
    // Add more space data here
];

// Function to create spaces on the contract
async function createSpaces() {
    for (const space of spacesData) {
        await contract.createSpace(
            space.name,
            space.description,
            space.images,
            space.rooms,
            space.price
        );
        console.log(`Space "${space.name}" created.`);
    }
}

createSpaces();
