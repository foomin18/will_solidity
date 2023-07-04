pragma solidity >= 0.7.0 < 0.9.0;

contract Will {
    address owner;
    uint fortune;
    bool deceased;

    constructor() payable public { //publicでpayable
        owner = msg.sender; // msg sender represents address being called
        fortune = msg.value; //msg value tells us how much ether is being sent 
        deceased = false; 
    }

    // create modifier so the only person who can call the contract is the owner
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // only allocate funds if friend's gramps is deceased

    modifier mustBeDeceased {
        require(deceased == true);
        _;
    }    

    // list of family wallets
    address payable[] familyWallets;

    // map through inheritance
    mapping(address => uint) walletsToInheritance;

    // set inheritance for each address 
    function setInheritance(address payable wallet, uint amount) public onlyOwner {
        familyWallets.push(wallet);
        walletsToInheritance[wallet] = amount;
    }

    function payout() private mustBeDeceased {
        for(uint i = 0; i < familyWallets.length; i++) { //payableなmapping を更新 == ほかのaddressに送金
            familyWallets[i].transfer(walletsToInheritance[familyWallets[i]]);
            // transferring funds from contract address to reciever address
        }
    }

    // oracle switch
    function hasDeceasedAndPay() public onlyOwner {
        deceased = true;
        payout();
    }
}