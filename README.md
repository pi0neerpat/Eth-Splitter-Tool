This contract is designed to equally divide and distribute funds to any number of addresses.  

![alt text](https://github.com/blockchainbuddha/Eth-Splitter-Tool/blob/master/Images/description.png)

WRITE-permissions are limited to the contract owner (address who initially deployed the contract).  Anyone can see the list of addresses once they are set. Ownership is transferrable. In case of error, reset() can be called to return all funds to the owner

![alt text](https://github.com/blockchainbuddha/Eth-Splitter-Tool/blob/master/Images/example.png)

Only two calls are needed to perform the action: 

### 1. Set the Recipients

	function setRecipients( address[] a ) onlyOwner returns (bool)

### 2. Send funds to distribute

Remember to include some ETH when calling this function!

	function distributeFunds() payable onlyOwner returns (bool) 

### Reset the data, return funds

	function reset()  onlyOwner returns (bool)
 
### Change the Owner

The `owner` can reassign the contract to another address by calling:

    function changeOwner(address _newOwner) onlyOwner


