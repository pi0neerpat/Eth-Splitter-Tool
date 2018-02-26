pragma solidity ^0.4.6;

/// @title ETH-Splitter-Tool
/// @author Patrick Gallagher
///  This contract is used to send funds from the contract owner to many recipients 
///  First, a list of 4 addresses are sent to the contract. Next ETH is sent, which
///  is then divided evenly and sent to the recipients. At any time, the process
///  can be stopped, where the list of recipients is reset, and funds are returned
///  to the owner.

contract Splitter {
    //address public recipientAddress;
    address public owner = 0xBa50B75DBb02Bd9A2F07905de4DBb076480A7d1e;
    address[] public recipientAddress;
    address public recipientAddress2;
    address public recipientAddress3;
    address public recipientAddress4;
    uint public numberRecipients;
    
    function changeOwner(address _newOwner)  {
        owner = _newOwner;
    }
    
     function safeDiv(uint a, uint b) pure internal returns (uint) {
        uint c = a / b;
        require(a == 0 || c * b == a);
        return c;
     }
    
    function setNumberRecipients(uint num) returns (bool) {
        numberRecipients = num;
        return (true);
    }
    
    /// param a1 through a4 must cannot be null.
    function setRecipients(
        address[] a
    ) 
        returns (bool)
    {
        recipientAddress = a;
        numberRecipients = recipientAddress.length;
        return true;
    }

    // Check that *some ETH is sent, determines the evenly split amount,
    // and distributes funds accordingly.
     function distributeFunds() payable returns (bool) {
        assert(msg.value > 0); 
        uint splitAmount = safeDiv(msg.value, 4);
        for (uint8 y = 0; y < numberRecipients; y++) {
            recipientAddress[y].transfer(splitAmount);
        }
        // Return remaining funds to sender
        msg.sender.transfer(this.balance);
        return true;
    }
    
    // Fallback function which allows payment to the contract
    function() public payable  {  }
    
    // View-only function to check recipientAddresses    
    function viewRecipients() view returns (address[]) {
        return (recipientAddress);  
    }

    // Resets balance to the desired value, and performs validation check
    function reset()  {
        owner.transfer(this.balance);
        delete recipientAddress;
    }
    
    function kill()  {
        selfdestruct(owner);  // kills this contract and sends remaining funds back to creator
    }

}