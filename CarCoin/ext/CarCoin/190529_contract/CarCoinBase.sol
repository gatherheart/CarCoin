pragma solidity >=0.4.22 <0.6.0;
import "./CarCoinControl.sol";

contract CarCoinBase is CarCoinControl{
    
    using SafeMath for uint256;
    using ArrayUtils for uint256 [];
    
    mapping (address => ISC) public insuranceCompany; // insurance Company data
    mapping (string => Car) carList; // list of cars 
    
    address CarCoinContract; // the contract of carcoin
    uint256 zeroCoin = 0;
    
    
    modifier RegisteredCarNum(string memory number){
        require(carList[number].registered);
        _;
    }
    
    function setCarCoinAddr(address addr) external OnlyCEO whenNotPaused {
        permission[CarCoinContract] = 0;
        CarCoinContract = addr;
        permission[CarCoinContract] = 7;
    }
    
    // initialize the registered car 
    function registerCar(string calldata carNum, uint256 value, uint256 time) external ReadWrite whenNotPaused{
        
        ISC storage isc = insuranceCompany[msg.sender];
        // the car should not be registered car to insuranceCompany or others
        require(
            !isc.managingCar[carNum].registered
            && !carList[carNum].registered,
            "Already registered car"
            );
        
        Car storage car = carList[carNum]; 
        car.registered = true;
        car.carNum = carNum;
        car.manager = isc;
        car.carValue = value;
        
        car.registeredDate = time;
        car.tokenId = tokenIdGen(carNum, value, time);
        // register to isc
        isc.tokenNum = isc.tokenNum.incr();
        isc.managingCar[carNum] = car;
        
        return;
    }
    
    function checkCar(string calldata carNum) external view whenNotPaused returns(bool, uint256, uint256){
        return (carList[carNum].registered, carList[carNum].registeredDate, carList[carNum].tokenId);
    }
    
    function deleteCar(string calldata carNum) external ReadWrite whenNotPaused{
        
        ISC storage isc = insuranceCompany[msg.sender];
        // the car should not be registered car to insuranceCompany or others
        require(
            carList[carNum].registered
            && isc.managingCar[carNum].registered,
            "Not registered car to the company"
            );
        
        delete isc.managingCar[carNum]; 
        delete carList[carNum];
        
        isc.tokenNum = isc.tokenNum.decr();
        
    }
    
    // @param time // the time when Accident occured
    // @param carNum // the car that is involved in this accident
    // @param loss // the lost out of a car 
    // @param data // the data about accident such as the final fault-determination
    function saveAccident(uint256 time, string calldata carNum, uint256 loss, string calldata data) 
        external ReadWrite whenNotPaused{
        ISC storage isc = insuranceCompany[msg.sender];
        Car storage car = carList[carNum];
        
        require(car.registered, "Not registered car to the ISC");
        
        Accident memory acid;
        acid.time = time;
        acid.carNum = carNum;
        acid.loss = loss;
        acid.data = data;
        
        car.accidents.push(acid);
        isc.managingCar[carNum] = car;
        
        return;
    }
    
    function getAccident(string calldata carNum) external view OnlyRead returns(uint256 [] memory, uint256 [] memory, string memory){
        Car memory car = carList[carNum];
        
        uint256[] memory loss = new uint256[] (car.accidents.length);
        uint256[] memory time = new uint256[] (car.accidents.length);
        string memory tmp; 
        string memory delim = "/";
        for(uint256 i = 0; i < car.accidents.length; i++){
            loss[i] = car.accidents[i].loss;
            time[i] = car.accidents[i].time;
            
            tmp = string(abi.encodePacked(tmp, delim, car.accidents[i].data));
        }
        return (time, loss, tmp);
    }
    
    // @param time // the time when Accident occured
    // @param carNum // the car that is involved in this accident
    // @param restored // the restored value to the car 
    // @param data // the data about accident such as the correction about the accident
    function saveRepairment(uint256 time, string calldata carNum, uint256 restored, string calldata data)
        external ReadWrite whenNotPaused{
        ISC storage isc = insuranceCompany[msg.sender];
        Car storage car = carList[carNum];
        
        require(car.registered, "Not registered car to the ISC");
        
        Repairment memory repr;
        repr.time = time;
        repr.carNum = carNum;
        repr.restored = restored;
        repr.data = data;
        
        car.repaired.push(repr);
        isc.managingCar[carNum] = car;
        return;
    }
    
    function getRepairment(string calldata carNum) external view OnlyRead returns(uint256 [] memory, uint256 [] memory, string memory){
        Car memory car = carList[carNum];
        
        uint256[] memory restored = new uint256[] (car.repaired.length);
        uint256[] memory time = new uint256[] (car.repaired.length);
        string memory tmp; 
        string memory delim = "/";
        
        for(uint256 i = 0; i < car.repaired.length; i++){
            restored[i] = car.repaired[i].restored;
            time[i] = car.repaired[i].time;
            tmp = string(abi.encodePacked(tmp, delim, car.repaired[i].data));
        }
        return (time, restored, tmp);
    }
    
    // initialize the registered ISC 
    function verifyISC(address manager) external AllPermitted whenNotPaused NotZeroAddr(manager){
        
        // Before registration, own should allow target address as permitted
        require(permission[manager] == 4);
        ISC storage isc = insuranceCompany[manager];
        isc.manager = manager;
        isc.verified = true;
        isc.credibility = 100;
        isc.tokenNum = 0; 
    }
    
    
    function setCredibility(address manager, uint256 credibility) external AllPermitted whenNotPaused NotZeroAddr(manager){
        ISC storage isc = insuranceCompany[manager];
        isc.credibility = credibility;
    }
    
    function registerReader(address target) external AllPermitted whenNotPaused NotZeroAddr(target){
        permission[target] = 1;
    }
    
    function unverifyISC(address manager) external AllPermitted whenNotPaused NotZeroAddr(manager){
        delete insuranceCompany[manager];
        permission[manager] = 0; 

    }
    
    function tokenIdGen(string memory carNum, uint256 value, uint256 time) public view returns (uint256){
        uint256 tokenId = uint256(keccak256(abi.encodePacked(carNum, value, time)));
        require(tokenId != zeroCoin);
        return tokenId;
    }
    
    function checkPermission(address target) public view returns(uint8){
        return permission[target];
    }
}