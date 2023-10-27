// Connect to your Ethereum provider using Web3.js
const web3 = new Web3(Web3.givenProvider);

// Replace this with the address of your deployed contract
const contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";

// Load the contract
const realEstateContract = new web3.eth.Contract(ABI, contractAddress);

// Define your Ethereum account (Metamask or any other provider)
let userAccount;

web3.eth.getAccounts()
    .then(accounts => {
        userAccount = accounts[0];
    });

// Function to list a property
function listProperty() {
    const description = document.getElementById("description").value;
    const location = document.getElementById("location").value;
    const price = document.getElementById("price").value;

    realEstateContract.methods.listProperty(description, location, price)
        .send({ from: userAccount })
        .then(() => {
            alert("Property listed successfully!");
        });
}

// Function to update a property
function updateProperty() {
    const propertyId = document.getElementById("updatePropertyId").value;
    const newDescription = document.getElementById("newDescription").value;
    const newLocation = document.getElementById("newLocation").value;
    const newPrice = document.getElementById("newPrice").value;

    realEstateContract.methods.updateProperty(propertyId, newDescription, newLocation, newPrice)
        .send({ from: userAccount })
        .then(() => {
            alert("Property updated successfully!");
        });
}

// Function to delete a property
function deleteProperty() {
    const propertyId = document.getElementById("deletePropertyId").value;

    realEstateContract.methods.deletingProperty(propertyId)
        .send({ from: userAccount })
        .then(() => {
            alert("Property deleted successfully!");
        });
}

// Function to buy a property
function buyProperty() {
    const propertyId = document.getElementById("buyPropertyId").value;

    realEstateContract.methods.buyProperty(propertyId)
        .send({ from: userAccount, value: web3.utils.toWei("0.1", "ether") })
        .then(() => {
            alert("Property bought successfully!");
        });
}
