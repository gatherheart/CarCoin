pragma solidity >=0.4.22 <0.6.0;
import "./CarCoinBase.sol";
import "./ERC721XFT.sol";
import "./Ownerable.sol";


// Before use this smart contract, ISC should be registerd into Database of CarCoin 
// And ISC should allow this smart contract as an approved operator

contract CarCoin is Ownerable{
    
    using SafeMath for uint256;
    using ArrayUtils for uint256 [];
    
    
    uint256 zeroCoin = 0;
    ERC721XTokenFT Token;
    CarCoinBase Database;
    uint256 rate = 10;
    
    constructor(address _Token, address _Database) public{
        Token = ERC721XTokenFT(_Token);
        Database = CarCoinBase(_Database);
    }
    
    function setRate(uint256 newRate) public onlyOwner{
        rate = newRate;
    }
    
    // @param carNum - the characteristic and distinct number of car registerd to government
    // @param value - the payed money for the car 
    // @param time - the time when car is bought
    function carRegistration(string memory carNum, uint256 value, uint256 time) public {
        Database.registerCar(carNum, value, time);
        uint256 tokenId = Database.tokenIdGen(carNum, value, time);
        uint256 supply = value;
        //uint256 tokenId, address to, uint256 supply
        Token._mint(tokenId, msg.sender, supply);
    }
    
    // dev delete registerd car onto smart contract
    // @param carNum 
    function carUnregister(string memory carNum) public{
        uint256 tokenId;
        (,,tokenId) = Database.checkCar(carNum);
        Database.deleteCar(carNum);
        Token.burn(msg.sender, tokenId);
        Token.burn(owner, tokenId);
    }

    // @param time // the time when Accident occured
    // @param carNum // the car that is involved in this accident
    // @param loss // the lost out of a car 
    // @param data // the data about accident such as the final fault-determination
    function reportAccident(uint256 time, string memory carNum, uint256 loss, string memory data) public{
        // try to report accident to Database
        Database.saveAccident(time, carNum, loss, data);
        
        uint256 credibility = 0;
        uint256 tokenId;
        
        (,,,credibility) = Database.insuranceCompany(msg.sender);
        (,,tokenId) = Database.checkCar(carNum);
        uint256 reward = credibility * rate;
        
        // the value of car get lost 
        Token.transferFrom(msg.sender, owner, tokenId, loss);
        // isc get rewards from smart contract
        Token.transferFrom(owner, msg.sender, zeroCoin, reward);
        
    }
    
    // @param time // the time when Accident occured
    // @param carNum // the car that is involved in this accident
    // @param repaired // the value of repairment 
    // @param data // the data about accident such as the final fault-determination
    function reportRepairment(uint256 time, string memory carNum, uint256 repaired, string memory data) public{
        // try to report event to Database
        Database.saveRepairment(time, carNum, repaired, data);
        
        uint256 credibility = 0;
        uint256 tokenId;
        
        (,,,credibility) = Database.insuranceCompany(msg.sender);
        (,,tokenId) = Database.checkCar(carNum);
        uint256 reward = credibility * rate;
        
        // the value of car get repaired 
        Token.transferFrom(msg.sender, owner, tokenId, repaired);
        // isc get rewards from smart contract
        Token.transferFrom(owner, msg.sender, zeroCoin, reward);
        
    }
    
    // @dev get data about repaired car
    function getRepairmentData(string memory carNum) public view returns(uint256 [] memory, uint256 [] memory, string memory){
        uint256 [] memory time;
        uint256 [] memory restoredValue;
        string memory data;
        
        (time, restoredValue, data) = Database.getRepairment(carNum);
        return (time, restoredValue, data);
    }
    
    // @dev get data about accident car get through 
    function getAccidentData(string memory carNum) public view returns(uint256 [] memory, uint256 [] memory, string memory){
        uint256 [] memory time;
        uint256 [] memory lostValue;
        string memory data;
        
        (time, lostValue, data) = Database.getAccident(carNum);
        return (time, lostValue, data);
    }
    
    
    
}