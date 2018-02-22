pragma solidity ^0.4.6;

/// @title ETH-Splitter-Tool
/// @author Patrick Gallagher
///  This contract is used to send funds from the contract owner to many recipients 
///  First, a list of 4 addresses are sent to the contract. Next ETH is sent, which
///  is then divided evenly and sent to the recipients. At any time, the process
///  can be stopped, where the list of recipients is reset, and funds are returned
///  to the owner.

contract safeMath {
    
    /// @param 'b' must be an even number to prevent divisor overflow
     function safeDiv(uint a, uint b) internal returns (uint) {
          uint c = a / b;
          assert(a == 0 || c * b == a);
          return c;
     }

     function assert(bool assertion) internal {
          if (!assertion) revert();
     }
}

// Establishes the 'owner' during the constructor, and allows transfer of 
// ownership.
contract owned {
    address public owner = msg.sender;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function changeOwner(address _newOwner) onlyOwner {
        owner = _newOwner;
    }
}

// Main contract, which inherits owned and safeMath
contract Splitter is owned, safeMath {
    address recipientAddresses[];
    
    /// @param  Must provide 4 addresses which cannot be null.
    function setRecipients(
        address a1, 
        address a2,
        address a3,
        address a4
    ) 
        onlyOwner returns (bool)
    {
        assert(a1 != 0);
        assert(a2 != 0);
        assert(a3 != 0);
        assert(a4 != 0);
        recipientAddress[0] = a1;
        recipientAddress[1] = a2;
        recipientAddress[2] = a3;
        recipientAddress[3] = a4;
    return true;
    }

    // Check that *some ETH is sent, determines the evenly split amount,
    // and distributes funds accordingly. Remaining funds are returned
    /// @param msg.value cannot be 0
     function distributeFunds() payable onlyOwner returns (bool) {
        assert(msg.value > 0); 
        uint splitAmount = safeDiv(msg.value, 4) 
        for(uint8 y = 0; y < 4; y++) {
            recipientAddress[y].transfer(splitAmount);
        }
        msg.sender.transfer(this.balance);
        return true;
    }
    
    // Fallback function which allows payment to the contract
    function() public payable onlyOwner {  }
    
    // View-only function to check recipientAddresses    
    function viewRecipients() onlyOwner view returns (string) {
        return recipientAddresses;  
    }

    // Resets balance to the desired value, and performs validation check
    function reset()  onlyOwner returns (bool){
        owner.transfer(this.balance);
        delete recipientAddresses;
    }

}