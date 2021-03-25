pragma solidity ^0.8.0;

interface IERC20{
    
    function balanceOf(address account) external view returns (uint256);
    
    function allowance(address owner, address spender) external view returns (uint256);
    
    function transfer(address recipient, uint256 amount) external  returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}

interface INFT{
     
    function createNFT(address user, string calldata symbol, string calldata name, string calldata about) external returns(bool);
    
}

interface IDonations {
    
    function setToken(address tokenAddress) external ;
    function setNFT(address NFTcontractAddress) external ;
    function transferOwnership(address user) external ;
    function donate(uint256 amount) external returns(bool);
    function refundAll() external;
    function newEvent() external ;
    function withdraw(address user, uint256 amount) external returns(bool);
    
}
contract Donations is IDonations {
    
    IERC20 token;
    INFT NFT;
    
    address private _contractOwner;
    
    uint256 _event = 0;
    uint256 _donaters = 0;
    mapping(uint256 => mapping(uint256 => address payable)) private _donater;
    mapping(uint256 => mapping(address => uint256)) private _donation;
    mapping(uint256 => mapping(address => bool))private _rewarded;
    
    constructor(){
        _contractOwner = msg.sender;
    }
    
    function setToken(address tokenAddress) external override {
        token = IERC20(tokenAddress);
    }
    
    function setNFT(address NFTcontractAddress) external override {
        NFT = INFT(NFTcontractAddress);
    }
    
    function transferOwnership(address user) external override {
        require(_contractOwner == msg.sender);
        _contractOwner = user;
    }
    
    function donate(uint256 amount) external override returns(bool){
        require(token.allowance(msg.sender, address(this)) >= amount);
        require(token.balanceOf(msg.sender) >= amount);
        
        if(token.transferFrom(msg.sender, address(this), amount)){
            _donater[_event][_donaters] = payable(msg.sender);
            _donation[_event][msg.sender] += amount;
            
            if(!_rewarded[_event][msg.sender]){
                NFT.createNFT(msg.sender, "DT", "Donation Token", "A thank you for your donation during our event");
                _rewarded[_event][msg.sender] = true;
            }
            return true;
        }
        
        return false; 
    }
    
    function refundAll() external override {
        require(msg.sender == _contractOwner);
        
        for(uint t = 0; t < _donaters; t += 1){
            _donater[_event][t].transfer(_donation[_event][_donater[_event][t]]);
        }
    }
    
    function newEvent() external override {
        _event += 1;
    }
    
    function withdraw(address user, uint256 amount) external override returns(bool){
        require(token.balanceOf(address(this)) >= amount);
        return token.transfer(user, amount);
    }
    
    
}    
