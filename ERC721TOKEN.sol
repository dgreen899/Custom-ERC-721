pragma solidity ^0.4.16;

//ERC721 contract template
contract ERC721 {
   // ERC20 compatible functions
   function name() constant returns (string name);
   function symbol() constant returns (string symbol);
   function totalSupply() constant returns (uint256 totalSupply);
   function balanceOf(address _owner) constant returns (uint balance);
   // Functions that define ownership
   function ownerOf(uint256 _tokenId) constant returns (address owner);
   function approve(address _to, uint256 _tokenId);
   function takeOwnership(uint256 _tokenId);
   function transfer(address _to, uint256 _tokenId);
   function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId);
   // Token metadata
   function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
   // Events
   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

}

pragma solidity ^0.4.19;
contract SpecialToken {
   string constant private tokenName = "My Special ERC721 Token";
   string constant private tokenSymbol = "SPEC";
   uint256 constant private totalTokens = 12000000;
   mapping(address => uint) private balances;
   mapping(uint256 => address) private tokenOwners;
   mapping(uint256 => bool) private tokenExists;
   mapping(address => mapping (address => uint256)) private allowed;
   mapping(address => mapping(uint256 => uint256)) private ownerTokens;

   mapping(uint256 => string) tokenLinks;
   function removeFromTokenList(address owner,int256 _tokenId) private {
     for(uint256 i = 0;ownerTokens[owner][i] != _tokenId;i++){
       ownerTokens[owner][i] = 0;
     }
}
   function name() public constant returns (string){
       return tokenName;
   }
   function symbol() public constant returns (string) {
       return tokenSymbol;
   }
   function totalSupply() public constant returns (uint256){
       return totalTokens;
   }
   function balanceOf(address _owner) constant returns (uint){
       return balances[_owner];
   }
   function ownerOf(uint256 _tokenId) constant returns (address){
       require(tokenExists[_tokenId]);
       return tokenOwners[_tokenId];
   }
   function approve(address _to, uint256 _tokenId){
       require(msg.sender == ownerOf(_tokenId));
       require(msg.sender != _to);
       allowed[msg.sender][_to] = _tokenId;
       Approval(msg.sender, _to, _tokenId);
   }
   function takeOwnership(uint256 _tokenId){
       require(tokenExists[_tokenId]);
       address oldOwner = ownerOf(_tokenId);
       address newOwner = msg.sender;
       require(newOwner != oldOwner);
       require(allowed[oldOwner][newOwner] == _tokenId);
       balances[oldOwner] -= 1;
       tokenOwners[_tokenId] = newOwner;
       balances[oldOwner] += 1;
       Transfer(oldOwner, newOwner, _tokenId);
   }
   function transfer(address _to, uint256 _tokenId){
       address currentOwner = msg.sender;
       address newOwner = _to;
       require(tokenExists[_tokenId]);
       require(currentOwner == ownerOf(_tokenId));
       require(currentOwner != newOwner);
       require(newOwner != address(0));
       removeFromTokenList(currentOwner, _tokenId);
       balances[currentOwner] -= 1;
       tokenOwners[_tokenId] = newOwner;
       balances[newOwner] += 1;
       Transfer(currentOwner, newOwner, _tokenId);
   }
   function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId){
       return ownerTokens[_owner][_index];
   }
   function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl){
       return tokenLinks[_tokenId];
   }

   function setTokenMetadata(uint256 _tokenId, string infoUrl) {
    require(msg.sender == ownerOf(_tokenId));
    tokenLinks[_tokenId] = infoUrl;
}

   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
