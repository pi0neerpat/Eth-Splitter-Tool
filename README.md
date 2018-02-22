![Eth-Splitter](readme-header.png)

This contract is designed to distribute funds to a list of 4 addresses.  Only two calls are needed to perform the action: setRecipients() and distributeFunds(). distributeFunds() can be used repeatedly, since the recipients do not change until setRecipients() is called again.

!Warning: this project is untested!

### Setting the Recipients

	function setRecipients(
			address a1, 
			address a2,
			address a3,
			address a4
		) 
			onlyOwner returns (bool)
		{

### Distribute the funds

	function distributeFunds() payable onlyOwner returns (bool) 

### Reset the data, return funds

	function reset()  onlyOwner returns (bool)
 
### Change the Owner

The `owner` can reassign it’s role to another address by calling:

    function changeOwner(address _newOwner) onlyOwner


