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
    address public owner = msg.sender;
    address[] public recipientAddress;
    uint public numberRecipients;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function changeOwner(address _newOwner) onlyOwner {
        owner = _newOwner;
    }

    // Set the recipients array to any length
    function setRecipients(address[] a) onlyOwner returns (bool){
        recipientAddress = a;
        numberRecipients = recipientAddress.length;
        return true;
    }

    // Check that some ETH is sent. Use the number of recipients to
    // calculate the evenly split amount, and distribute funds.
    function distributeFunds() payable onlyOwner returns (bool) {
        assert(msg.value > 0); 
        uint splitAmount = msg.value / numberRecipients;
        for (uint8 y = 0; y < numberRecipients; y++) {
            recipientAddress[y].transfer(splitAmount);
        }
        // Return any funds sent to fallback function
        msg.sender.transfer(this.balance);
        return true;
    }
    
    // Fallback function allows payment to the contract
    // without distributing funds. Unsure if necessary...
    function() private payable onlyOwner { }
    
    // View-only function to check recipientAddresses    
    function viewRecipients() view returns (address[]) {
        return (recipientAddress);  
    }

    // Resets balance to the desired value, and performs validation check
    function reset() onlyOwner {
        owner.transfer(this.balance);
        delete recipientAddress;
    }
    
    function kill() onlyOwner {
        selfdestruct(owner);  // kills this contract and sends remaining funds back to creator
    }

}