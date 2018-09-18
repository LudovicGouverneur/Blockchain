pragma solidity ^0.4.24;

contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}

contract BasicToken is owned {
    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    // This keeps track of the total amount of token minted
    uint256 totalSupply =0; 

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(
        ) public {
        }

    event WithdrawalDone(address recipient, uint amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {

        if (msg.sender==owner) {
            // Send some Ether to the recipient so he can make transactions 
            if (_to.send(0.01 ether)) {
                // Update the total and recipient token balance
                totalSupply += _value;
                balanceOf[_to] += _value;
                emit Transfer(msg.sender, _to, _value);
            }
            else {
            }
        }
        else 
        {
            require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
            require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
            balanceOf[msg.sender] -= _value;                    // Subtract from the sender
            balanceOf[_to] += _value;                           // Add the same to the recipient
            emit Transfer(msg.sender, _to, _value);
        }
        
        return true;
    }
    
    // This function allows the contract to receive Ether
    function () payable public {
    }

    // This function sends the remaining balance in DigityserCoin to the sender
    function withdrawal() public {
        uint amount = balanceOf[msg.sender];
        totalSupply -= amount;
        balanceOf[msg.sender]=0;

        if (amount>0) {
            if (msg.sender.send(amount)) {
                emit WithdrawalDone(msg.sender, amount);
            }
            else 
            {
                balanceOf[msg.sender] = amount;
            }
        }
    }


}

contract DigiCoin is BasicToken {

    /* Public variables of the coin */

    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    
    string public name;                   //Token name
    uint8 public decimals;                //How many decimals to show
    string public symbol;                 //An identifier
    
    constructor (
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
        ) public {
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }
}

