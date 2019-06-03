pragma solidity >=0.4.22 <0.6.0;
import "./Ownerable.sol";
import "./SafeMath.sol";
import "./ArrayUtils.sol";

contract CarCoinDatabase {
    
    event CeoRegistered(address NewOwner);
    // The addresses that can execute actions within each roles.
    address public ceoAddress;
    
    constructor () public {
        ceoAddress = msg.sender;
        emit CeoRegistered(msg.sender);
    }

    struct Car {
        bool registered; // check wether registered or not 
        string carNum; // who possess this car
        
        uint256 tokenId; // serial number of the CarCoin 
        
        uint256 carValue; // the initial value of the car bought
        uint256 registeredDate; // the time of registered date
        ISC manager; // Insurance Company who manage this CarCoin
        
        Accident [] accidents; // the list of accidents of car history
        Repairment [] repaired; // the list of Repairment
    }
    
    // Insurance Company
    struct ISC {
        bool verified; // check wether verified or not
        address manager; // the address of ISC manager 
        
        uint256 tokenNum; // the number of car which managing
        mapping (string => Car) managingCar; // the informations of a car which is mapped by car number
        
        uint256 credibility; // the reliability of insurance company 
        mapping (uint256 => uint256) balances; // the amount of tokens which ISC holds (tokenId -> balances)
    }
    
    // car Accident report
    struct Accident{
        
        uint256 time; // the time when Accident occured
        string carNum; // the cars that are involved in this accident
        uint256 loss; // the lost out of a car 
        string data; // the data about accident
    }
    
    // car Repairment report
    struct Repairment{
        string carNum; // the car address which is  repaired 
        uint256 time; // the tile when Repairment occured for the car
        uint256 restored; // the amount of restored tokens
        string data; // the data about Repairments
    }
    
    
}