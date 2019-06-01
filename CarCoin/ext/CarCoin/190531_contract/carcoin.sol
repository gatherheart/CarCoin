pragma solidity >=0.4.22 <0.6.0;
import "./CarCoinBase.sol";
import "./ERC721XFT.sol";
import "./Ownerable.sol";

// Before use this smart contract, ISC should be registerd into Database of CarCoin
// And ISC should allow this smart contract as an approved operator

contract CarCoinNe is Ownerable{

    using SafeMath for uint256;
    using ArrayUtils for uint256 [];

    uint256 zeroCoin = 0;
    ERC721XTokenFT Token;
    CarCoinBase Database;
    uint256 rate = 10;


    event ReportAccident(address indexed reporter, uint256, string);
    event ReportRepairment(address indexed reporter, uint256, string);
    event ISC_Registration(address isc);
    event ISC_Unregistration(address isc);

    constructor(address _Token, address _Database) public{
        Token = ERC721XTokenFT(_Token);
        Database = CarCoinBase(_Database);
    }

    function setTokenContract(address _Token) public onlyOwner {
        Token = ERC721XTokenFT(_Token);
    }

    function setDatabase(address _Database) public onlyOwner {
        Database = CarCoinBase(_Database);
    }

    function setRate(uint256 newRate) public onlyOwner{
        rate = newRate;
    }

    function iscRegistraction(address target) public {
        Database.verifyISC(target);

        // registration succeed now set allowance to carcoin
        Token.setApprovalForTokenMaker(true);
        emit ISC_Registration(target);
    }

    function iscUnregistraction(address target) public {
        Database.unverifyISC(target);

        // registration succeed now set allowance to carcoin
        Token.setApprovalForTokenMaker(false);
        emit ISC_Unregistration(target);
    }

    // @param carNum - the characteristic and distinct number of car registerd to government
    // @param value - the payed money for the car
    // @param time - the time when car is bought
    function carRegistration(string memory carNum, uint256 value, uint256 time) public {

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 4);

        Database.registerCar(carNum, value, time);
        uint256 tokenId = Database.tokenIdGen(carNum, value, time);
        uint256 supply = value;
        //uint256 tokenId, address to, uint256 supply
        Token._mint(tokenId, msg.sender, supply);
    }

    // dev delete registerd car onto smart contract
    // @param carNum
    function carUnregister(string memory carNum) public{

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 4);

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

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 4);

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
        emit ReportAccident(msg.sender, time, carNum);
    }

    // @param time // the time when Accident occured
    // @param carNum // the car that is involved in this accident
    // @param repaired // the value of repairment
    // @param data // the data about accident such as the final fault-determination
    function reportRepairment(uint256 time, string memory carNum, uint256 repaired, string memory data) public{
        // try to report event to Database

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 4);

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
        emit ReportRepairment(msg.sender, time, carNum);


    }

    // @dev get data about repaired car
    function getRepairmentData(string memory carNum) public view returns(string memory){

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 1);

        uint256 [] memory time;
        uint256 [] memory restoredValue;
        string memory data;

        (time, restoredValue, data) = Database.getAccident(carNum);
        string memory ret = makeStringReturn(time, restoredValue, data);

        return ret;
    }

    // @dev get data about accident car get through
    function getAccidentData(string memory carNum) public view returns(string memory){

        uint256 permission;
        permission = Database.checkPermission(msg.sender);
        require(permission >= 1);

        uint256 [] memory time;
        uint256 [] memory lostValue;
        string memory data;

        (time, lostValue, data) = Database.getAccident(carNum);
        string memory ret = makeStringReturn(time, lostValue, data);

        return ret;
    }

    function makeStringReturn(uint256 [] memory time, uint256 [] memory value, string memory data)
        private pure returns(string memory){

        string memory tmp_a = "";
        string memory tmp_b = "";

        for(uint256 i = 0; i < time.length; i++){
            tmp_a = string(abi.encodePacked( tmp_a, "\\", uint2str(time[i])));
            tmp_b = string(abi.encodePacked( tmp_b, "\\", uint2str(value[i])));
        }

        return string(abi.encodePacked(tmp_a, "@", tmp_b, "@", data));
        //return string(abi.encodePacked(tmp_a, tmp_b, data));

    }

    /*REFERENCE: loomnetwork/erc721x/blob/master/contracts/Core/ERC721X/ERC721XTokenNFT.sol*/
    function uint2str(uint256 _i) private pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }

        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }

        return string(bstr);
    }

}
