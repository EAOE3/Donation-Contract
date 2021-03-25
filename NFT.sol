pragma solidity ^0.8.0;

interface INFT{
     
    function NFTstats(uint256 NFTID) external view returns(string memory symbol, string memory name, string memory about, address owner);
    
    function NFTatIndex(address user, uint256 index) external view returns(uint256);
    
    function createNFT(address user, string calldata symbol, string calldata name, string calldata about) external returns(bool);
    
    function transferNFT(address user, uint256 NFTID) external returns(bool);
    
    function transferOwnership(address user) external returns(bool);
}
contract NFT is INFT{
    
    address _ContractOwner;
    
    uint256 NFTs = 0;
    
    mapping(uint256 => string) private _symbol;
    mapping(uint256 => string) private _name;
    mapping(uint256 => string) private _about;
    mapping(uint256 => address) private _owner;
    
    mapping(address => uint256) private _ownedNFT;
    mapping(address => mapping(uint256 => uint256)) private _NFTatIndex;   
    constructor(){
        _ContractOwner = msg.sender;
    }
    
    
    function NFTstats(uint256 NFTID) external view override returns(string memory symbol, string memory name, string memory about, address owner) {
        symbol = _symbol[NFTID];
        name = _name[NFTID];
        about = _about[NFTID];
        owner = _owner[NFTID];
    }
    
    function NFTatIndex(address user, uint256 index) external view override returns(uint256){
        return _NFTatIndex[user][index];
    }
    
    function ownedNFT(address user) external view returns(uint256){
        return _ownedNFT[user];
    }
    
    function createNFT(address user, string calldata symbol, string calldata name, string calldata about) external override returns(bool) {
        require(msg.sender == _ContractOwner);
        _symbol[NFTs] = symbol;
        _name[NFTs] = name;
        _about[NFTs] = about;
        _owner[NFTs] = user;
        
        _NFTatIndex[user][_ownedNFT[user]] = NFTs;
        _ownedNFT[user] += 1;
        
        NFTs += 1;
        
        return true;
        
    }
    
    function transferNFT(address user, uint256 NFTID) external override returns(bool){
        require(_owner[NFTID] == msg.sender);
        _owner[NFTID] = user;
        
        _NFTatIndex[user][_ownedNFT[user]] = NFTs;
        _ownedNFT[user] += 1;
        return true;
    }
    
    function transferOwnership(address user) external override returns(bool){
        require(_ContractOwner == msg.sender);
        _ContractOwner = user;
        return true;
    }    
    
    
    
}
