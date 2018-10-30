pragma solidity ^0.4.21;

contract DataMarket {
    
struct Observer{
    bool deposited;
    bool validated;
    uint balance;
    uint256[] blocknumbers;
    string[]geolocations;
}

uint deposit;           //amount that has to be deposited by each observer
uint reward;            //reward that is to be acquired by observers
uint price;             //price for each data submitted
address public owner;
mapping(address => Observer) public observers;

//constructor for datamarket
constructor(uint rate) public{
    owner = msg.sender;
    deposit = 50 ether;
    reward = 0;
    price = rate;
}

//allows owner to add reward
function addreward() public payable{
    require(msg.sender == owner);
    reward += msg.value;
}

//observers have to stake some ethers before submitting data
function stake() public payable{
    
    require(!observers[msg.sender].deposited);
    require(msg.value >= deposit);
    
    observers[msg.sender].deposited = true;
    observers[msg.sender].balance+= msg.value;
}

function submitdata(string data) public{
    require(observers[msg.sender].deposited);
    uint256 blockno = block.number;
    
    observers[msg.sender].geolocations.push(data);
    observers[msg.sender].blocknumbers.push(blockno);
    
    observers[msg.sender].balance += price ;
}


function validate(address obs) public{
    
    require(msg.sender == owner);
        
    observers[obs].validated = true;
    observers[obs].deposited = false;
 
}

function getpayment() public{

        require(observers[msg.sender].validated);

        uint amount = observers[msg.sender].balance;
        observers[msg.sender].balance = 0;
        msg.sender.transfer(amount);
}

function observerbalance() constant public returns	(uint retval)		{	
		return(observers[msg.sender].balance);						
}	

}