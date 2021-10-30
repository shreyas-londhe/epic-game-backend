// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./libraries/Base64.sol";

contract MyEpicGame is ERC721 {

  event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
  event AttackComplete(uint newBossChakra, uint newPlayerChakra);

  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;        
    uint chakra;
    uint maxChakra;
    uint attackDamage;
  }

  struct BigBoss {
    string name;
    string imageURI;
    uint chakra;
    uint maxChakra;
    uint attackDamage;
  }

  BigBoss public bigBoss;

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;  

  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
  mapping(address => uint256) public nftHolders;

  CharacterAttributes[] defaultCharacters;

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterChakra,
    uint[] memory characterAttackDmg,
    string memory bossName, 
    string memory bossImageURI,
    uint bossChakra,
    uint bossAttackDamage
  )
    ERC721("Shinobis", "SHINOBI")
  {
    bigBoss = BigBoss({
      name: bossName,
      imageURI: bossImageURI,
      chakra: bossChakra,
      maxChakra: bossChakra,
      attackDamage: bossAttackDamage
    });

    console.log(
      "Done initializing boss %s w/ HP %s, img %s", 
      bigBoss.name, 
      bigBoss.chakra, 
      bigBoss.imageURI
    );

    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        chakra: characterChakra[i],
        maxChakra: characterChakra[i],
        attackDamage: characterAttackDmg[i]
      }));

      CharacterAttributes memory c = defaultCharacters[i];
      console.log(
        "Done initializing %s w/ HP %s, img %s", 
        c.name, 
        c.chakra, 
        c.imageURI
      );
    }

    _tokenIds.increment();
  }

  function mintCharacterNFT(uint _characterIndex) external {
    uint256 newItemId = _tokenIds.current();

    _safeMint(msg.sender, newItemId);

    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      chakra: defaultCharacters[_characterIndex].chakra,
      maxChakra: defaultCharacters[_characterIndex].chakra,
      attackDamage: defaultCharacters[_characterIndex].attackDamage
    });

    console.log(
      "Minted NFT w/ tokenId %s and characterIndex %s", 
      newItemId, 
      _characterIndex
    );
    
    nftHolders[msg.sender] = newItemId;

    _tokenIds.increment();
    emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
  }

  function tokenURI(uint _tokenId) public view override returns (string memory) {
    CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

    string memory strChakra = Strings.toString(charAttributes.chakra);
    string memory strMaxChakra = Strings.toString(charAttributes.maxChakra);
    string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked (
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Shinobi Showdown!", "image": "ipfs://',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Chakra", "value": ',strChakra,', "max_value":',strMaxChakra,'}, { "trait_type": "Attack Damage", "value": ',
            strAttackDamage,'} ]}'
          )
        )
      )
    );

    string memory output = string(
      abi.encodePacked("data:application/json;base64,", json)
    );
    
    return output;
  }

  function attackBoss() public {
    uint256 charId = nftHolders[msg.sender];
    CharacterAttributes storage char = nftHolderAttributes[charId];
    console.log(
      "\nPlayer w/ character %s about to attack. Has %s HP and %s AD", 
      char.name, 
      char.chakra, 
      char.attackDamage
    );
    console.log(
      "Boss %s has %s HP and %s AD", 
      bigBoss.name, 
      bigBoss.chakra, 
      bigBoss.attackDamage
    );

    require (
      char.chakra > 0,
      "Error: character must have HP to attack boss."
    );
    require (
      bigBoss.chakra > 0,
      "Error: boss must have HP to attack boss."
    );

    if (bigBoss.chakra < char.attackDamage) {
      bigBoss.chakra = 0;
    } else {
      bigBoss.chakra = bigBoss.chakra - char.attackDamage;
    }

    if (char.chakra < char.attackDamage) {
      char.chakra = 0;
    } else {
      char.chakra = char.chakra - bigBoss.attackDamage;
    }

    console.log(
      "\nPlayer w/ character %s has attacked. Has %s HP and %s AD", 
      char.name, 
      char.chakra, 
      char.attackDamage
    );
    console.log(
      "Boss %s has %s HP and %s AD", 
      bigBoss.name, 
      bigBoss.chakra, 
      bigBoss.attackDamage
    );

    emit AttackComplete(bigBoss.chakra, char.chakra);
  }

  function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
    uint256 userNftTokenId = nftHolders[msg.sender];
    if (userNftTokenId > 0) {
      return nftHolderAttributes[userNftTokenId];
    }
    else {
      CharacterAttributes memory emptyStruct;
      return emptyStruct;
    }
  }

  function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
    return defaultCharacters;
  }

  function getBigBoss() public view returns (BigBoss memory) {
    return bigBoss;
  }

}