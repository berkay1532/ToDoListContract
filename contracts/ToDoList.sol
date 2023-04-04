// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// import "hardhat/console.sol";

contract ToDoList {

    //Variables

    uint public taskCount = 0;
    address public owner ;
    mapping (uint => Task) public tasks;
    struct Task {
        uint id;
        address developer;
        address ownerOfTask;
        string content;
        bool completed;
        bool inProgress;
        uint salary;
    }


    constructor () {
        owner = msg.sender;
    }


    //Features functions

    //This function creates tasks and transfer the salary*11/10 of task (1/10) of the salary goes to owner of the contract
    function createTask(string memory contentOfTask, uint salary) public payable enoughEther(salary) {
        taskCount++;
        tasks[taskCount] = Task(taskCount,address(0), msg.sender, contentOfTask, false, false, salary);
        
    }

    function takeTask (uint id) public isNotTask(id) hasTaskTaken(id) isCompleted(id) {
        tasks[id].developer = msg.sender;
        tasks[id].inProgress = true;
    }

    function completeTask (uint id) public  isNotTask(id) notInProggress(id) taskIsNotBelongMsgSender(id) isCompleted(id) {
        tasks[id].completed = true;
        (payable (tasks[id].developer)).transfer(tasks[id].salary);
    }

    function withdraw() public onlyOwner{
        payable(owner).transfer(address(this).balance);
    }



    //Usefull funtions


    //This function provides us to check there is a task which has id = key
    function containsKey(uint256 key) public view returns (bool) {
        return bytes(tasks[key].content).length > 0;
    }


    modifier onlyOwner() {
        require(msg.sender == owner,"You are not the owner of the contract");
        _;
    }
    modifier notInProggress(uint id) {
        require(tasks[id].inProgress != false, "This task has not taken");
        _;
    }
    modifier taskIsNotBelongMsgSender(uint id) {
        require(msg.sender == tasks[id].developer, "This task is not belong to the this address");
        _;
    }
    modifier isNotTask(uint id) {
        require(containsKey(id) == true, "This task is not exist");
        _;
    }
    modifier isCompleted(uint id) {
        require(tasks[id].completed != true, "This task has already done");
        _;
    }
    modifier hasTaskTaken(uint id) {
        require(tasks[id].developer == address(0), "Task has already been taken");
        _;
    }
    modifier enoughEther(uint salary) {
        require(msg.value == (salary*11) / 10, "Dont enough ether");
        _;
    }
}
