// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

// This contract is an ERC721 token (a type of non-fungible token) and it also has the Ownable contract
// to track ownership
contract RoboPunksNFT is ERC721, Ownable {
    // This variable stores the price of minting (creating) a new token
    uint256 public mintPrice;
    
    // This variable stores the total number of tokens that have been minted
    uint256 public totalSupply;
    
    // This variable stores the maximum number of tokens that can be minted
    uint256 public maxSuplly;
    
    // This variable stores the maximum number of tokens that a single wallet can mint
    uint256 public maxPerWallet;
    
    // This variable stores whether or not public minting is enabled (i.e. anyone can mint a new token)
    bool public isPublicMintEnabled;
    
    // This variable stores the base URI for all tokens, which is used to provide metadata about the token
    string internal baseTokenUri;
    
    // This variable stores the address of the wallet where minting fees will be deposited
    address payable public withdrawWallet;
    
    // This mapping stores the number of tokens that each wallet has minted
    mapping(address => uint256) public walletMints;


    // This is the constructor for the contract, which is called when the contract is deployed
    // It is marked as payable because it accepts an initial ether payment
    constructor() payable ERC721('RoboPunks', 'RP') {
            // Set the mint price to 0.02 ether
            mintPrice = 0.02 ether;
            
            // Set the total supply to 0
            totalSupply = 0;
            
            // Set the maximum supply to 1000
            maxSuplly = 1000;
            
            // Set the maximum number of tokens that a single wallet can mint to 3
            maxPerWallet = 3;
            
            // Set the withdraw wallet address to the contract's own address
           
        }
    
    // This function allows the contract owner to enable or disable public minting
    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }
    
    // This function allows the contract owner to set the base URI for all tokens
    function setBaseTokenURI(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }
    
    // This function returns the URI for a specific token
    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        // Check that the token exists
        require(_exists(tokenId_), 'Token does not exist!');
        
        // Return the URI by appending the token ID to the base URI
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));
    }

    // This function allows the contract owner to withdraw the contract's balance
    function withdraw() external onlyOwner {
        // Call the withdraw wallet contract with the contract's balance as the value
        (bool success, ) = withdrawWallet.call{ value: address(this).balance}('');
        
        // Check that the call was successful
        require(success, 'withdraw failed');
    }

    // This function allows someone to mint (create) a new token
    function mint(uint256 quantity_) public payable {
        // Check that public minting is enabled
        require(isPublicMintEnabled, 'minting not enabled');
        
        // Check that the correct amount of ether was sent with the transaction
        require(msg.value == quantity_ * mintPrice, 'wrong mint value');
        
        // Check that there are enough tokens available to mint
        require(totalSupply + quantity_ <= maxSuplly, 'sold out');
        
        // Check that the wallet hasn't exceeded its maximum number of tokens
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceed max wallet');
        
        // Mint the requested number of tokens
        for (uint256 i = 0; i < quantity_; i++) {
            // Increment the total supply and assign a new token ID
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            
            // Mint the new token
            _safeMint(msg.sender, newTokenId);
        }
    }
}