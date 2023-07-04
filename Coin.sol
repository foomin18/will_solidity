pragma solidity >= 0.7.0 < 0.9.0;

contract Coin { //coinを作れるのは開発者だけCoinはaccountどうし好きに送りあえる
    // public にすることで他のコントラクトからアクセスできるようにする
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);
    constructor() {
        minter = msg.sender; //minterをCoin(etherじゃないToken(今回はCoin)) contract をデプロイしたaccount address(開発者)にする
    }


    function mint(address reciever,uint amount) public { //Coinを作って特定のaccountに送る
        require(msg.sender == minter); //開発者のみ
        balances[reciever] += amount;
    }

    error insufficientBalance(uint requested, uint available);

    function send(address reciever, uint amount) public {
        if (balances[msg.sender] < amount) {
            revert insufficientBalance({ //以下の関数実行をキャンセルし、エラー出力
                requested: amount,
                available: balances[msg.sender]
            });
        }
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Sent(msg.sender, reciever, amount);
    }

    function seeToken(address account) public returns(uint) { //balancesをpublicにしてるので別にいらない
        return (balances[account]);
    }

}